import 'package:flutter/widgets.dart';

import '../logger/app_logger.dart';

class LoggingNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppLogger.info('Navigation: Pushed ${route.settings.name ?? 'unnamed route'}', extras: {'from': previousRoute?.settings.name, 'args': route.settings.arguments});
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppLogger.info('Navigation: Popped ${route.settings.name ?? 'unnamed route'}', extras: {'to': previousRoute?.settings.name});
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    AppLogger.info('Navigation: Replaced ${oldRoute?.settings.name} with ${newRoute?.settings.name}');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppLogger.info('Navigation: Removed ${route.settings.name}');
  }
}
