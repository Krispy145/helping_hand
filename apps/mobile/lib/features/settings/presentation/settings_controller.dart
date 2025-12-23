import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/app_lifecycle_provider.dart';
import 'settings_state.dart';

part 'settings_controller.g.dart';

@riverpod
class SettingsController extends _$SettingsController {
  @override
  SettingsState build() {
    // Listen to lifecycle changes to refresh permissions when resumed
    ref.listen(appLifecycleProvider, (previous, next) {
      if (next.value == AppLifecycleState.resumed) {
        checkPermissions();
      }
    });

    // Initial check
    checkPermissions();

    return const SettingsState.initial();
  }

  Future<void> checkPermissions() async {
    state = state.copyWith(isLoading: true);

    final location = await Permission.locationWhenInUse.status;
    final notification = await Permission.notification.status;
    final camera = await Permission.camera.status;

    state = state.copyWith(location: location, notification: notification, camera: camera, isLoading: false);
  }

  Future<void> handlePermission(Permission permission) async {
    final status = await permission.status;
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    } else {
      await permission.request();
      // Re-check all permissions after request to ensure consistent state
      await checkPermissions();
    }
  }
}
