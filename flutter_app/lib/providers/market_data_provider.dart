import 'dart:async';
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../services/websocket_service.dart';
import '../models/market_data_model.dart';

class MarketDataProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final WebSocketService _webSocketService = WebSocketService();

  List<MarketData> _marketData = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription? _webSocketSubscription;
  WebSocketConnectionState _webSocketState =
      WebSocketConnectionState.disconnected;

  List<MarketData> get marketData => _marketData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  WebSocketConnectionState get webSocketState => _webSocketState;
  bool get isWebSocketConnected =>
      _webSocketState == WebSocketConnectionState.connected;

  // Get a specific market data item by symbol
  MarketData? getMarketDataBySymbol(String symbol) {
    try {
      return _marketData.firstWhere((item) => item.symbol == symbol);
    } catch (e) {
      return null;
    }
  }

  MarketDataProvider() {
    _initializeWebSocket();
  }

  void _initializeWebSocket() {
    // Connect to WebSocket
    _webSocketService.connect();

    // Listen to WebSocket stream
    _webSocketSubscription = _webSocketService.stream?.listen(
      (data) {
        _handleWebSocketMessage(data);
      },
      onError: (error) {
        if (kDebugMode) {
          print('WebSocket stream error: $error');
        }
        _updateWebSocketState();
      },
    );

    // Listen to connection state changes
    _updateWebSocketState();

    // Periodically check connection state
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_webSocketService.connectionState != _webSocketState) {
        _updateWebSocketState();
      }
    });
  }

  void _updateWebSocketState() {
    final newState = _webSocketService.connectionState;
    if (newState != _webSocketState) {
      _webSocketState = newState;
      notifyListeners();
    }
  }

  void _handleWebSocketMessage(Map<String, dynamic> message) {
    try {
      // Handle connection state messages
      if (message['type'] == 'connection_state') {
        _updateWebSocketState();
        return;
      }

      // Handle market update messages
      if (message['type'] == 'market_update' && message['data'] != null) {
        final updateData = message['data'] as Map<String, dynamic>;
        final symbol = updateData['symbol'] as String?;

        if (symbol != null) {
          // Find the index of the item to update
          final index = _marketData.indexWhere((item) => item.symbol == symbol);

          if (index != -1) {
            // Update existing item
            try {
              final updatedItem = MarketData.fromJson(updateData);
              _marketData[index] = updatedItem;

              // Maintain sort order by price (descending)
              _marketData.sort((a, b) => b.price.compareTo(a.price));

              notifyListeners();
            } catch (e) {
              if (kDebugMode) {
                print('Error updating market data: $e');
              }
            }
          } else {
            // New item, add it
            try {
              final newItem = MarketData.fromJson(updateData);
              _marketData.add(newItem);
              _marketData.sort((a, b) => b.price.compareTo(a.price));
              notifyListeners();
            } catch (e) {
              if (kDebugMode) {
                print('Error adding new market data: $e');
              }
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error handling WebSocket message: $e');
      }
    }
  }

  Future<void> loadMarketData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Add minimum loading time to ensure shimmer is visible (at least 800ms)
      final stopwatch = Stopwatch()..start();
      final data = await _apiService.getMarketData();

      // Ensure minimum loading time of 800ms for better UX
      final elapsed = stopwatch.elapsedMilliseconds;
      if (elapsed < 800) {
        await Future.delayed(Duration(milliseconds: 800 - elapsed));
      }

      // Sort by price (descending - highest to lowest)
      data.sort((a, b) => b.price.compareTo(a.price));
      _marketData = data;

      // Update WebSocket connection status
      _updateWebSocketState();

      // Ensure WebSocket is connected
      if (!_webSocketService.isConnected) {
        _webSocketService.connect();
      }
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadMarketData();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void reconnectWebSocket() {
    _webSocketService.disconnect();
    _webSocketService.resetReconnectAttempts();
    _webSocketService.connect();
    _updateWebSocketState();
  }

  @override
  void dispose() {
    _webSocketSubscription?.cancel();
    _webSocketService.dispose();
    super.dispose();
  }
}
