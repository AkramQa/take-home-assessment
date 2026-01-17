import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../models/market_data_model.dart';

class ApiService {
  static const String baseUrl = AppConstants.baseUrl;

  static const Duration _timeout = Duration(seconds: 30);

  Future<List<MarketData>> getMarketData() async {
    final uri = Uri.parse('$baseUrl${AppConstants.marketDataEndpoint}');

    try {
      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;

        if (decoded['data'] is List) {
          final data = decoded['data'] as List;
          return data
              .map((item) => MarketData.fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception('Invalid API response format');
        }
      } else {
        throw Exception('Failed to load market data: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No Internet connection');
    } on HttpException catch (e) {
      throw Exception('HTTP exception: ${e.message}');
    } on FormatException {
      throw Exception('Bad response format');
    } on TimeoutException {
      throw Exception('Request timed out');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
