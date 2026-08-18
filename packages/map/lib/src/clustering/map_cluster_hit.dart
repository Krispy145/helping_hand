import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'cluster_point.dart';

/// A renderable item from [MapClusterIndex.search]: one request, or a group.
sealed class MapClusterHit<T> {
  const MapClusterHit();

  String get key;
  LatLng get position;
  int get count;
}

final class MapClusterLeaf<T> extends MapClusterHit<T> {
  final ClusterPoint<T> point;

  const MapClusterLeaf(this.point);

  @override
  String get key => 'p-${point.id}';

  @override
  LatLng get position => point.position;

  @override
  int get count => 1;

  T get data => point.data;
}

final class MapClusterGroup<T> extends MapClusterHit<T> {
  MapClusterGroup({
    required this.id,
    required this.position,
    required this.count,
    required this.expansionZoom,
    required this.bounds,
    required List<ClusterPoint<T>> members,
  }) : _members = members;

  final int id;
  final double expansionZoom;
  final LatLngBounds bounds;
  final List<ClusterPoint<T>> _members;

  @override
  final LatLng position;

  @override
  final int count;

  @override
  String get key => 'c-$id';

  /// All requests inside this cluster (pre-resolved, stable order).
  List<T> get items => [for (final member in _members) member.data];

  List<ClusterPoint<T>> get members => _members;

  /// True when every member shares effectively the same coordinate.
  bool get isCoincident {
    const epsilon = 1e-5;
    return (bounds.north - bounds.south).abs() < epsilon && (bounds.east - bounds.west).abs() < epsilon;
  }
}
