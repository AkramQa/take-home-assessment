import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../screens/home_screen.dart';
import '../../screens/market_data_detail_screen.dart';
import '../../models/market_data_model.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}

@RoutePage()
class MarketDataDetailPage extends StatelessWidget {
  final MarketData marketData;

  const MarketDataDetailPage({
    super.key,
    required this.marketData,
  });

  @override
  Widget build(BuildContext context) {
    return MarketDataDetailScreen(marketData: marketData);
  }
}
