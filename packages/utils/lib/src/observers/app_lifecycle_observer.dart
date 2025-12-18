import 'package:flutter/widgets.dart';

import '../logger/app_logger.dart';

/// An extensible class for observing app lifecycle events.
///
/// Usage:
/// 1. Create a class that extends [AppLifecycleObserver].
/// 2. Override methods like [onResume], [onPause] for custom logic.
/// 3. Add the observer to [WidgetsBinding] in your app initialization.
///
/// Example:
/// ```dart
/// final observer = AppLifecycleObserver();
/// WidgetsBinding.instance.addObserver(observer);
/// ```
class AppLifecycleObserver with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    AppLogger.info('Lifecycle: App state changed to $state');

    switch (state) {
      case AppLifecycleState.resumed:
        onResume();
        break;
      case AppLifecycleState.paused:
        onPause();
        break;
      case AppLifecycleState.inactive:
        onInactive();
        break;
      case AppLifecycleState.detached:
        onDetached();
        break;
      case AppLifecycleState.hidden:
        onHidden();
        break;
    }
  }

  /// Called when the app is visible and responding to user input.
  @protected
  void onResume() {}

  /// Called when the app is not currently running.
  @protected
  void onPause() {}

  /// Called when the app is in an inactive state and is not receiving user input.
  @protected
  void onInactive() {}

  /// Called when the engine is detached from any views.
  @protected
  void onDetached() {}

  /// Called when the app is hidden.
  @protected
  void onHidden() {}

  @override
  void didChangeLocales(List<Locale>? locales) {
    AppLogger.info('Lifecycle: Locales changed to $locales');
    super.didChangeLocales(locales);
  }

  @override
  void didChangePlatformBrightness() {
    AppLogger.info('Lifecycle: Platform brightness changed');
    super.didChangePlatformBrightness();
  }
}
