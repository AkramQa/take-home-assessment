import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../models/market_data_model.dart';
import 'routes.dart';

part 'app_router.gr.dart';

// Custom transition builder for smooth page transitions
RouteTransitionsBuilder slideInWithFade = (
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  const begin = Offset(1.0, 0.0);
  const end = Offset.zero;
  const curve = Curves.easeInOut;

  var slideAnimation = Tween(begin: begin, end: end).animate(
    CurvedAnimation(parent: animation, curve: curve),
  );

  var fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(parent: animation, curve: curve),
  );

  return SlideTransition(
    position: slideAnimation,
    child: FadeTransition(
      opacity: fadeAnimation,
      child: child,
    ),
  );
};

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: HomeRoute.page,
          initial: true,
        ),
        CustomRoute(
          page: MarketDataDetailRoute.page,
          transitionsBuilder: slideInWithFade,
          durationInMilliseconds: 300,
        ),
      ];
}
