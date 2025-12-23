import 'package:latlong2/latlong.dart';
import 'package:models/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../requests/providers/request_provider.dart';
import 'map_state.dart';

part 'map_controller.g.dart';

@riverpod
class MapController extends _$MapController {
  @override
  MapState build() {
    // Initial load logic if needed, or just return initial state
    // We can listen to userLocationProvider here to update userLocation in state?
    // Or just let the UI watch userLocationProvider directly for the "My Location" marker,
    // but for "Recenter" logic, the controller needs to know.

    // For now, simple build.
    return const MapState();
  }

  void setUserLocation(LatLng location) {
    state = state.copyWith(userLocation: location);
  }

  void setRequests(List<RequestDto> requests) {
    state = state.copyWith(requests: requests);
  }

  Future<void> searchArea(LatLng center, double radius) async {
    state = state.copyWith(isSearching: true, center: center);
    try {
      // Simulate "Searching" delay for UI effect (Radar Pulse)
      await Future<void>.delayed(const Duration(seconds: 2));

      // Force refresh the provider to get new data
      final requests = await ref.refresh(nearbyRequestsProvider((lat: center.latitude, lng: center.longitude, radius: radius)).future);
      state = state.copyWith(isSearching: false, requests: requests);
    } catch (e) {
      state = state.copyWith(isSearching: false, error: e);
    }
  }
}
