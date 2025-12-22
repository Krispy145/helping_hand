import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A mixin that adds [Listenable] support to an [AsyncNotifier].
/// Useful for GoRouter's `refreshListenable`.
mixin ListenableNotifier<T> on AsyncNotifier<T> implements Listenable {
  final _listeners = <VoidCallback>[];

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  /// Call this when you want to notify listeners (e.g. router).
  /// Note: Riverpod notifiers don't automatically trigger standard Listenable listeners
  /// when `state` changes, this is a bridge.
  /// However, for GoRouter + Riverpod, it's often better to use a `Stream` or
  /// just watch the provider if using `go_router_builder` or dedicated riverpod integration.
  ///
  /// Given the current simple setup without extra dependencies, we will override
  /// the state setter to notify.

  @override
  set state(AsyncValue<T> value) {
    super.state = value;
    _notifyListeners();
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }
}
