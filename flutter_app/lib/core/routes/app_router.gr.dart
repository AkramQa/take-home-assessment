// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomePage(),
      );
    },
    MarketDataDetailRoute.name: (routeData) {
      final args = routeData.argsAs<MarketDataDetailRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: MarketDataDetailPage(
          key: args.key,
          marketData: args.marketData,
        ),
      );
    },
  };
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MarketDataDetailPage]
class MarketDataDetailRoute extends PageRouteInfo<MarketDataDetailRouteArgs> {
  MarketDataDetailRoute({
    Key? key,
    required MarketData marketData,
    List<PageRouteInfo>? children,
  }) : super(
          MarketDataDetailRoute.name,
          args: MarketDataDetailRouteArgs(
            key: key,
            marketData: marketData,
          ),
          initialChildren: children,
        );

  static const String name = 'MarketDataDetailRoute';

  static const PageInfo<MarketDataDetailRouteArgs> page =
      PageInfo<MarketDataDetailRouteArgs>(name);
}

class MarketDataDetailRouteArgs {
  const MarketDataDetailRouteArgs({
    this.key,
    required this.marketData,
  });

  final Key? key;

  final MarketData marketData;

  @override
  String toString() {
    return 'MarketDataDetailRouteArgs{key: $key, marketData: $marketData}';
  }
}
