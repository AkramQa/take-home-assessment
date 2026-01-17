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
    return MarketData(
      symbol: json['symbol'] as String,
      price: (json['price'] as num).toDouble(),
      change24h: (json['change24h'] as num).toDouble(),
      changePercent24h: (json['changePercent24h'] as num).toDouble(),
      volume: (json['volume'] as num).toDouble(),
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
