import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

@immutable
class SettingsState {
  final PermissionStatus? location;
  final PermissionStatus? notification;
  final PermissionStatus? camera;
  final bool isLoading;

  const SettingsState({this.location, this.notification, this.camera, this.isLoading = false});

  const SettingsState.initial() : location = null, notification = null, camera = null, isLoading = false;

  SettingsState copyWith({PermissionStatus? location, PermissionStatus? notification, PermissionStatus? camera, bool? isLoading}) {
    return SettingsState(location: location ?? this.location, notification: notification ?? this.notification, camera: camera ?? this.camera, isLoading: isLoading ?? this.isLoading);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SettingsState && other.location == location && other.notification == notification && other.camera == camera && other.isLoading == isLoading;
  }

  @override
  int get hashCode {
    return location.hashCode ^ notification.hashCode ^ camera.hashCode ^ isLoading.hashCode;
  }
}
