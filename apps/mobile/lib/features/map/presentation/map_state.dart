import 'package:latlong2/latlong.dart';
import 'package:models/models.dart';

class MapState {
  final LatLng center;
  final double zoom;
  final bool isSearching;
  final List<RequestDto> requests;
  final LatLng? userLocation;
  final Object? error;

  const MapState({this.center = const LatLng(-33.9249, 18.4241), this.zoom = 13.0, this.isSearching = false, this.requests = const [], this.userLocation, this.error});

  MapState copyWith({LatLng? center, double? zoom, bool? isSearching, List<RequestDto>? requests, LatLng? userLocation, Object? error}) {
    return MapState(
      center: center ?? this.center,
      zoom: zoom ?? this.zoom,
      isSearching: isSearching ?? this.isSearching,
      requests: requests ?? this.requests,
      userLocation: userLocation ?? this.userLocation,
      error: error ?? this.error,
    );
  }
}
