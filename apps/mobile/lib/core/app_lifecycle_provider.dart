import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appLifecycleProvider = StreamProvider<AppLifecycleState>((ref) {
  final binding = WidgetsBinding.instance;
  final observer = _LifecycleObserver();
  binding.addObserver(observer);

  ref.onDispose(() => binding.removeObserver(observer));

  return observer.lifecycleSubject;
});

class _LifecycleObserver extends WidgetsBindingObserver {
  final _controller = StreamController<AppLifecycleState>.broadcast();
  Stream<AppLifecycleState> get lifecycleSubject => _controller.stream;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _controller.add(state);
  }
}
