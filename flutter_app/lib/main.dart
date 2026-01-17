import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'providers/market_data_provider.dart';

final appRouter = AppRouter();

void main() {
  runApp(const PulseNowApp());
}

class PulseNowApp extends StatelessWidget {
  const PulseNowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => MarketDataProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp.router(
            title: 'PulseNow',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.provideThemeData(
              context,
              brightness: Brightness.light,
            ),
            darkTheme: AppTheme.provideThemeData(
              context,
              brightness: Brightness.dark,
            ),
            themeMode: themeProvider.themeMode,
            routerConfig: appRouter.config(),
          );
        },
      ),
    );
  }
}