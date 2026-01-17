import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData provideThemeData(
    BuildContext context, {
    required Brightness brightness,
  }) {
    final appColors = AppColors.getAppColors(brightness: brightness);
    
    // Create standard ColorScheme based on brightness
    final colorScheme = brightness == Brightness.light
        ? ColorScheme.light(
            primary: const Color(0xFF2197FF),
            onPrimary: Colors.white,
            secondary: const Color(0xFF92A5B5),
            onSecondary: Colors.white,
            error: const Color(0xFFE4626F),
            onError: Colors.white,
            surface: Colors.white,
            onSurface: const Color(0xFF4A5E6D),
            surfaceVariant: const Color(0xFFDFE2EB),
            onSurfaceVariant: const Color(0xFF637D92),
            outline: const Color(0xFFE8E8E9),
          )
        : ColorScheme.dark(
            primary: const Color(0xFF2197FF),
            onPrimary: const Color(0xFF0A0A0B),
            secondary: const Color(0xFFAAB9C5),
            onSecondary: const Color(0xFF0A0A0B),
            error: const Color(0xFFE4626F),
            onError: const Color(0xFF690005),
            surface: const Color(0xFF1A1C1E),
            onSurface: const Color(0xFFE2E2E6),
            surfaceVariant: const Color(0xFF43474E),
            onSurfaceVariant: const Color(0xFFC3C7CF),
            outline: const Color(0xFF8D9199),
          );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        color: appColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: appColors.searchBackground,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
      ),
    );
  }
}
