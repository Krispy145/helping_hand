import 'package:latlong2/latlong.dart';
import 'package:models/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../requests/providers/request_provider.dart';
import 'map_state.dart';

part 'map_controller.g.dart';

@riverpod
class MapController extends _$MapController {
  static const _minRadarDuration = Duration(milliseconds: 1500);
  DateTime? _searchingSince;
  int _searchGeneration = 0;

  @override
  MapState build() {
    return const MapState();
  }

  void setUserLocation(LatLng location) {
    state = state.copyWith(userLocation: location);
  }

  void setRequests(List<RequestDto> requests) {
    state = state.copyWith(requests: requests);
  }

  Future<void> setSearching(bool isSearching) async {
    if (isSearching) {
      _searchGeneration++;
      _searchingSince = DateTime.now();
      state = state.copyWith(isSearching: true);
      return;
    }

    final generation = _searchGeneration;
    final started = _searchingSince ?? DateTime.now();
    final remaining = _minRadarDuration - DateTime.now().difference(started);
    if (remaining > Duration.zero) {
      await Future<void>.delayed(remaining);
    }
    if (generation != _searchGeneration) return;
    _searchingSince = null;
    state = state.copyWith(isSearching: false);
  }

  Future<void> searchArea(LatLng center, double radius) async {
    state = state.copyWith(center: center);
    await setSearching(true);
    try {
      final requests = await ref.read(nearbyRequestsProvider.notifier).refresh();
      state = state.copyWith(requests: requests);
    } catch (e) {
      state = state.copyWith(error: e);
    } finally {
      await setSearching(false);
    }
  }
}
