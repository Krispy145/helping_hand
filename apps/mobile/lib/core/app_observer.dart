import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utils/utils.dart';

final class AppObserver extends ProviderObserver {
  @override
  void didUpdateProvider(ProviderObserverContext context, Object? previousValue, Object? newValue) {
    if (newValue is AsyncError) {
      AppLogger.error('Provider Error [${context.provider.name ?? context.provider.runtimeType}]', error: newValue.error, stackTrace: newValue.stackTrace);
    }
  }

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    if (value is AsyncError) {
      AppLogger.error('Provider Init Error [${context.provider.name ?? context.provider.runtimeType}]', error: value.error, stackTrace: value.stackTrace);
    }
  }
}
