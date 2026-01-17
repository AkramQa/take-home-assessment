import 'dart:async';
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/market_data_model.dart';

class MarketDataProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<MarketData> _marketData = [];
  bool _isLoading = false;
  String? _error;

  List<MarketData> get marketData => _marketData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // TODO: Implement loadMarketData() method
  // This should:
  // 1. Set _isLoading = true and _error = null
  // 2. Call notifyListeners()
  // 3. Call _apiService.getMarketData()
  // 4. Convert the response to List<MarketData> using MarketData.fromJson
  // 5. Set _marketData with the result
  // 6. Handle errors by setting _error
  // 7. Set _isLoading = false
  // 8. Call notifyListeners() again

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
}
