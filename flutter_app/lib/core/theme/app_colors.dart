import 'package:flutter/material.dart';

@immutable
class AppColors {
  const AppColors({
    required this.positiveColor,
    required this.negativeColor,
    required this.cardBackground,
    required this.searchBackground,
    required this.borderColor,
  });

  final Color positiveColor;
  final Color negativeColor;
  final Color cardBackground;
  final Color searchBackground;
  final Color borderColor;

  static AppColors getAppColors({required Brightness brightness}) {
    return brightness == Brightness.light
        ? _lightColors()
        : _darkColors();
  }

  static AppColors _lightColors() => const AppColors(
        positiveColor: Color(0xFF4CAF50),
        negativeColor: Color(0xFFF44336),
        cardBackground: Color(0xFFFFFFFF),
        searchBackground: Color(0xFFFFFFFF),
        borderColor: Color(0xFFE1E8E8),
      );

  static AppColors _darkColors() => const AppColors(
        positiveColor: Color(0xFF4CAF50),
        negativeColor: Color(0xFFF44336),
        cardBackground: Color(0xFF2F3033),
        searchBackground: Color(0xFF2F3033),
        borderColor: Color(0xFF43474E),
      );
}

// Extension to easily access AppColors from BuildContext
extension AppColorsExtension on BuildContext {
  AppColors get appColors {
    final brightness = Theme.of(this).brightness;
    return AppColors.getAppColors(brightness: brightness);
  }
}
