// TODO: Create MarketData model class
// Required fields:
// - symbol (String)
// - price (double)
// - change24h (double)
// - changePercent24h (double)
// - volume (double)
//
// Add a factory constructor fromJson that parses the JSON response
// Example JSON structure from API:
// {
//   "symbol": "BTC/USD",
//   "price": 43250.50,
//   "change24h": 2.5,
//   "changePercent24h": 2.5,
//   "volume": 1250000000
// }

class MarketData {
  final String symbol;
  final double price;
  final double change24h;
  final double changePercent24h;
  final double volume;

  MarketData({
    required this.symbol,
    required this.price,
    required this.change24h,
    required this.changePercent24h,
    required this.volume,
  });

  factory MarketData.fromJson(Map<String, dynamic> json) {
    // Helper function to safely parse numeric values (handles both String and num)
    double parseNumeric(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) {
        return double.tryParse(value) ?? 0.0;
      }
      return 0.0;
    }

    final symbol = json['symbol'] as String? ?? '';
    final price = parseNumeric(json['price']);
    final change24h = parseNumeric(json['change24h']);
    final volume = parseNumeric(json['volume']);
    
    // Calculate changePercent24h if not provided (from price and change24h)
    double changePercent24h;
    if (json['changePercent24h'] != null) {
      changePercent24h = parseNumeric(json['changePercent24h']);
    } else if (price > 0 && change24h != 0) {
      // Calculate percentage: (change24h / (price - change24h)) * 100
      final previousPrice = price - change24h;
      changePercent24h = previousPrice > 0 ? (change24h / previousPrice) * 100 : 0.0;
    } else {
      changePercent24h = 0.0;
    }

    return MarketData(
      symbol: symbol,
      price: price,
      change24h: change24h,
      changePercent24h: changePercent24h,
      volume: volume,
    );
  }
}
//
// // Import freezed annotation package (usually do this way to create models )
// import 'package:freezed_annotation/freezed_annotation.dart';
//
// // Part directives for generated freezed and JSON serialization files
// part 'market_data_model.freezed.dart';
// part 'market_data_model.g.dart';
//
// // Freezed annotation to generate immutable data class with union types support
// @freezed
// class MarketDataV2 with _$MarketData {
//   // Factory constructor defining all required fields
//   factory MarketData({
//     required String symbol,
//     required double price,
//     required double change24h,
//     required double changePercent24h,
//     required double volume,
//   }) = _MarketData;
//
//   // Factory constructor for JSON deserialization
//   // Uses generated _$MarketDataFromJson function
//   factory MarketData.fromJson(Map<String, dynamic> json) =>
//       _$MarketDataFromJson(json);
// }
