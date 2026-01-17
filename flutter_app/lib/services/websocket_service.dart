import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../utils/constants.dart';

enum WebSocketConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
}

class WebSocketService {
  WebSocketChannel? _channel;
  StreamController<Map<String, dynamic>>? _controller;
  StreamSubscription? _subscription;
  Timer? _reconnectTimer;

  WebSocketConnectionState _connectionState =
      WebSocketConnectionState.disconnected;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 10;
  static const Duration _initialReconnectDelay = Duration(seconds: 1);
  static const Duration _maxReconnectDelay = Duration(seconds: 30);

  Stream<Map<String, dynamic>>? get stream => _controller?.stream;
  WebSocketConnectionState get connectionState => _connectionState;
  bool get isConnected =>
      _connectionState == WebSocketConnectionState.connected;

  void connect() {
    if (_connectionState == WebSocketConnectionState.connected ||
        _connectionState == WebSocketConnectionState.connecting) {
      return;
    }

    _connectInternal();
  }

  void _connectInternal() {
    try {
      _connectionState = WebSocketConnectionState.connecting;
      _controller ??= StreamController<Map<String, dynamic>>.broadcast();

      _channel = WebSocketChannel.connect(Uri.parse(AppConstants.wsUrl));

      _subscription = _channel!.stream.listen(
        (message) {
          _handleMessage(message);
        },
        onError: (error) {
          _handleError(error);
        },
        onDone: () {
          _handleDisconnection();
        },
        cancelOnError: false,
      );

      _connectionState = WebSocketConnectionState.connected;
      _reconnectAttempts = 0;
      _controller?.add({'type': 'connection_state', 'state': 'connected'});

      if (kDebugMode) {
        print('WebSocket connected successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error connecting to WebSocket: $e');
      }
      _handleError(e);
    }
  }

  void _handleMessage(dynamic message) {
    try {
      final data = json.decode(message) as Map<String, dynamic>;
      _controller?.add(data);
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing WebSocket message: $e');
      }
    }
  }

  void _handleError(dynamic error) {
    if (kDebugMode) {
      print('WebSocket error: $error');
    }

    _connectionState = WebSocketConnectionState.disconnected;
    _controller?.addError(error);
    _scheduleReconnect();
  }

  void _handleDisconnection() {
    if (kDebugMode) {
      print('WebSocket connection closed');
    }

    _connectionState = WebSocketConnectionState.disconnected;
    _controller?.add({'type': 'connection_state', 'state': 'disconnected'});
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      if (kDebugMode) {
        print('Max reconnection attempts reached');
      }
      _connectionState = WebSocketConnectionState.disconnected;
      return;
    }

    _reconnectTimer?.cancel();
    _connectionState = WebSocketConnectionState.reconnecting;
    final delay = Duration(
      milliseconds: (_initialReconnectDelay.inMilliseconds *
              (1 << _reconnectAttempts.clamp(0, 4)))
          .clamp(
        _initialReconnectDelay.inMilliseconds,
        _maxReconnectDelay.inMilliseconds,
      ),
    );

    _reconnectAttempts++;

    if (kDebugMode) {
      print(
          'Scheduling reconnection attempt $_reconnectAttempts in ${delay.inSeconds}s');
    }

    _reconnectTimer = Timer(delay, () {
      if (_connectionState != WebSocketConnectionState.connected) {
        _connectInternal();
      }
    });
  }

  void disconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _subscription?.cancel();
    _subscription = null;
    _channel?.sink.close();
    _channel = null;
    _connectionState = WebSocketConnectionState.disconnected;
    _reconnectAttempts = 0;

    if (kDebugMode) {
      print('WebSocket manually disconnected');
    }
  }

  void dispose() {
    disconnect();
    _controller?.close();
    _controller = null;
  }

  void resetReconnectAttempts() {
    _reconnectAttempts = 0;
  }
}
