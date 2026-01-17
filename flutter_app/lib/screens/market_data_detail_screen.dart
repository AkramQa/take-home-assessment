import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../core/theme/app_colors.dart';
import '../providers/market_data_provider.dart';
import '../models/market_data_model.dart';

class MarketDataDetailScreen extends StatefulWidget {
  final MarketData marketData;

  const MarketDataDetailScreen({
    super.key,
    required this.marketData,
  });

  @override
  State<MarketDataDetailScreen> createState() => _MarketDataDetailScreenState();
}

class _MarketDataDetailScreenState extends State<MarketDataDetailScreen> {
  MarketData? _currentMarketData;
  StreamSubscription? _providerSubscription;
  MarketDataProvider? _provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    if (_provider == null) {
      _provider = Provider.of<MarketDataProvider>(context, listen: false);
      _currentMarketData = widget.marketData;
      final providerData = _provider!.getMarketDataBySymbol(widget.marketData.symbol);
      if (providerData != null) {
        _currentMarketData = providerData;
      }
      _provider!.addListener(_onProviderUpdate);
    }
  }

  void _onProviderUpdate() {
    if (_provider == null || !mounted) return;
    
    final updatedData = _provider!.getMarketDataBySymbol(widget.marketData.symbol);
    
    if (updatedData != null && updatedData != _currentMarketData) {
      if (mounted) {
        setState(() {
          _currentMarketData = updatedData;
        });
      }
    }
  }

  @override
  void dispose() {
    // Use saved provider reference instead of accessing context
    _provider?.removeListener(_onProviderUpdate);
    _providerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final marketData = _currentMarketData ?? widget.marketData;
    
    final priceFormatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );
    final formattedPrice = priceFormatter.format(marketData.price);

    final volumeFormatter = NumberFormat.decimalPattern();
    final formattedVolume = volumeFormatter.format(marketData.volume);

    // Get theme colors
    final appColors = context.appColors;
    
    // Determine if change is positive or negative
    final isPositive = marketData.change24h >= 0;
    final changeColor = isPositive
        ? appColors.positiveColor
        : appColors.negativeColor;
    
    // Format 24h change with sign
    final changeSign = isPositive ? '+' : '';
    final formattedChange = '$changeSign${marketData.change24h.toStringAsFixed(2)}';
    final formattedChangePercent =
        '$changeSign${marketData.changePercent24h.toStringAsFixed(2)}%';
    
    // Animation controller for entrance animation
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: _buildContent(
        context,
        marketData,
        formattedPrice,
        formattedVolume,
        appColors,
        changeColor,
        isPositive,
        formattedChange,
        formattedChangePercent,
      ),
    );
  }
  
  Widget _buildContent(
    BuildContext context,
    MarketData marketData,
    String formattedPrice,
    String formattedVolume,
    appColors,
    Color changeColor,
    bool isPositive,
    String formattedChange,
    String formattedChangePercent,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(marketData.symbol),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Price Card with animation
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: 0.9 + (0.1 * value),
                    child: child,
                  ),
                );
              },
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Text(
                        'Current Price',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formattedPrice,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Change Card with animation
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: 0.9 + (0.1 * value),
                    child: child,
                  ),
                );
              },
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '24h Change',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            formattedChange,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: changeColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            formattedChangePercent,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: changeColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Additional Details Card with animation
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: 0.9 + (0.1 * value),
                    child: child,
                  ),
                );
              },
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Market Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _DetailRow(
                        label: 'Symbol',
                        value: marketData.symbol,
                      ),
                      const Divider(),
                      _DetailRow(
                        label: 'Price',
                        value: formattedPrice,
                      ),
                      const Divider(),
                      _DetailRow(
                        label: '24h Change',
                        value: formattedChange,
                        valueColor: changeColor,
                      ),
                      const Divider(),
                      _DetailRow(
                        label: '24h Change %',
                        value: formattedChangePercent,
                        valueColor: changeColor,
                      ),
                      const Divider(),
                      _DetailRow(
                        label: '24h Volume',
                        value: formattedVolume,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
