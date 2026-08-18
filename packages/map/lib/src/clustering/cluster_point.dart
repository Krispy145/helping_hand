import 'package:latlong2/latlong.dart';

/// A single clusterable coordinate plus caller-owned payload.
final class ClusterPoint<T> {
  final String id;
  final LatLng position;
  final T data;

  const ClusterPoint({
    required this.id,
    required this.position,
    required this.data,
  });
}
