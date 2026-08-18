import 'dart:math' as math;

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'cluster_point.dart';
import 'map_cluster_config.dart';
import 'map_cluster_hit.dart';

/// Precomputed hierarchical clusters (Mapbox Supercluster / grid).
///
/// Build once when the point set changes ([build] is O(n * zoomLevels) with
/// spatial hashing). [search] is an O(k) lookup on the zoom layer — it does
/// not rescan the full point set on pan or pinch.
final class MapClusterIndex<T> {
  MapClusterIndex._({
    required this.config,
    required List<ClusterPoint<T>> points,
    required List<List<_Node<T>>> trees,
  }) : _points = points,
       _trees = trees;

  final MapClusterConfig config;
  final List<ClusterPoint<T>> _points;
  final List<List<_Node<T>>> _trees;

  int get pointCount => _points.length;

  factory MapClusterIndex.build(
    Iterable<ClusterPoint<T>> points, {
    MapClusterConfig config = const MapClusterConfig(),
  }) {
    final list = List<ClusterPoint<T>>.of(points, growable: false);
    final leafZoom = config.maxZoom + 1;
    final leaves = <_Node<T>>[
      for (var i = 0; i < list.length; i++) _Node.leaf(id: i, point: list[i], originZoom: leafZoom),
    ];

    final trees = List<List<_Node<T>>>.filled(config.maxZoom + 2, const []);
    trees[leafZoom] = leaves;

    var nextClusterId = list.length;
    for (var zoom = config.maxZoom; zoom >= config.minZoom; zoom--) {
      final clustered = _cluster(
        nodes: trees[zoom + 1],
        zoom: zoom,
        config: config,
        nextClusterId: nextClusterId,
      );
      nextClusterId += clustered.created;
      trees[zoom] = clustered.nodes;
    }

    return MapClusterIndex._(config: config, points: list, trees: trees);
  }

  /// Clusters (and unclustered points) visible at [zoom].
  ///
  /// [zoom] is the camera zoom; clustering uses `floor(zoom)` so the set is
  /// stable while the user pans. Optional [bounds] drops off-screen hits.
  List<MapClusterHit<T>> search({required double zoom, LatLngBounds? bounds}) {
    if (_points.isEmpty) return const [];

    final z = zoom.floor().clamp(config.minZoom, config.maxZoom);
    final layer = _trees[z];
    if (layer.isEmpty) return const [];

    final hits = <MapClusterHit<T>>[];
    for (final node in layer) {
      if (bounds != null && !_overlaps(node, bounds)) continue;
      hits.add(node.toHit());
    }
    return hits;
  }

  static bool _overlaps(_Node<void> node, LatLngBounds bounds) {
    return node.minLat <= bounds.north && node.maxLat >= bounds.south && node.minLng <= bounds.east && node.maxLng >= bounds.west;
  }

  static ({List<_Node<T>> nodes, int created}) _cluster<T>({
    required List<_Node<T>> nodes,
    required int zoom,
    required MapClusterConfig config,
    required int nextClusterId,
  }) {
    if (nodes.isEmpty) return (nodes: <_Node<T>>[], created: 0);

    final radius = config.radius / (config.extent * math.pow(2, zoom));
    final radiusSq = radius * radius;
    final grid = _Grid(radius);
    for (var i = 0; i < nodes.length; i++) {
      grid.insert(i, nodes[i].x, nodes[i].y);
    }

    final visited = List<bool>.filled(nodes.length, false);
    final results = <_Node<T>>[];
    var created = 0;
    var clusterId = nextClusterId;

    for (var i = 0; i < nodes.length; i++) {
      if (visited[i]) continue;
      visited[i] = true;

      final seed = nodes[i];
      final neighborIndexes = <int>[];
      grid.query(seed.x, seed.y, radius, (j) {
        if (j == i || visited[j]) return;
        final other = nodes[j];
        final dx = seed.x - other.x;
        final dy = seed.y - other.y;
        if (dx * dx + dy * dy > radiusSq) return;
        neighborIndexes.add(j);
      });

      if (neighborIndexes.length + 1 < config.minPoints) {
        results.add(seed);
        continue;
      }

      for (final j in neighborIndexes) {
        visited[j] = true;
      }
      results.add(
        _Node.cluster(
          id: clusterId,
          zoom: zoom,
          children: [seed, for (final j in neighborIndexes) nodes[j]],
        ),
      );
      clusterId++;
      created++;
    }

    return (nodes: results, created: created);
  }
}

final class _Node<T> {
  _Node._({
    required this.id,
    required this.x,
    required this.y,
    required this.lat,
    required this.lng,
    required this.childCount,
    required this.originZoom,
    required this.minLat,
    required this.maxLat,
    required this.minLng,
    required this.maxLng,
    required this.leaves,
    this.point,
  });

  factory _Node.leaf({
    required int id,
    required ClusterPoint<T> point,
    required int originZoom,
  }) {
    final projected = _Mercator.project(point.position.latitude, point.position.longitude);
    final lat = point.position.latitude;
    final lng = point.position.longitude;
    return _Node._(
      id: id,
      x: projected.x,
      y: projected.y,
      lat: lat,
      lng: lng,
      childCount: 1,
      originZoom: originZoom,
      minLat: lat,
      maxLat: lat,
      minLng: lng,
      maxLng: lng,
      leaves: [point],
      point: point,
    );
  }

  factory _Node.cluster({
    required int id,
    required int zoom,
    required List<_Node<T>> children,
  }) {
    var weightX = 0.0;
    var weightY = 0.0;
    var count = 0;
    var minLat = 90.0;
    var maxLat = -90.0;
    var minLng = 180.0;
    var maxLng = -180.0;
    final leaves = <ClusterPoint<T>>[];

    for (final child in children) {
      weightX += child.x * child.childCount;
      weightY += child.y * child.childCount;
      count += child.childCount;
      minLat = math.min(minLat, child.minLat);
      maxLat = math.max(maxLat, child.maxLat);
      minLng = math.min(minLng, child.minLng);
      maxLng = math.max(maxLng, child.maxLng);
      leaves.addAll(child.leaves);
    }

    final x = weightX / count;
    final y = weightY / count;
    return _Node._(
      id: id,
      x: x,
      y: y,
      lat: _Mercator.yToLat(y),
      lng: _Mercator.xToLng(x),
      childCount: count,
      originZoom: zoom,
      minLat: minLat,
      maxLat: maxLat,
      minLng: minLng,
      maxLng: maxLng,
      leaves: leaves,
    );
  }

  final int id;
  final double x;
  final double y;
  final double lat;
  final double lng;
  final int childCount;
  final int originZoom;
  final double minLat;
  final double maxLat;
  final double minLng;
  final double maxLng;
  final List<ClusterPoint<T>> leaves;
  final ClusterPoint<T>? point;

  MapClusterHit<T> toHit() {
    final leafPoint = point;
    if (leafPoint != null) return MapClusterLeaf<T>(leafPoint);
    return MapClusterGroup<T>(
      id: id,
      position: LatLng(lat, lng),
      count: childCount,
      expansionZoom: originZoom + 1,
      bounds: LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng)),
      members: leaves,
    );
  }
}

/// Uniform grid for O(1) expected neighbor lookup. Cell size equals the
/// cluster radius so a 3×3 (or slightly larger) neighborhood is sufficient.
final class _Grid {
  _Grid(this.cellSize);

  final double cellSize;
  final Map<(int, int), List<int>> _cells = {};

  void insert(int index, double x, double y) {
    final key = ((x / cellSize).floor(), (y / cellSize).floor());
    (_cells[key] ??= []).add(index);
  }

  void query(double x, double y, double radius, void Function(int index) visit) {
    final minX = ((x - radius) / cellSize).floor();
    final maxX = ((x + radius) / cellSize).floor();
    final minY = ((y - radius) / cellSize).floor();
    final maxY = ((y + radius) / cellSize).floor();
    for (var gx = minX; gx <= maxX; gx++) {
      for (var gy = minY; gy <= maxY; gy++) {
        final cell = _cells[(gx, gy)];
        if (cell == null) continue;
        for (final index in cell) {
          visit(index);
        }
      }
    }
  }
}

/// Web Mercator in unit-square space, matching Mapbox Supercluster.
abstract final class _Mercator {
  static ({double x, double y}) project(double lat, double lng) {
    final x = (lng / 360) + 0.5;
    final sinLat = math.sin(lat * math.pi / 180);
    var y = 0.5 - 0.25 * math.log((1 + sinLat) / (1 - sinLat)) / math.pi;
    if (y < 0) {
      y = 0;
    } else if (y > 1) {
      y = 1;
    }
    return (x: x, y: y);
  }

  static double xToLng(double x) => (x - 0.5) * 360;

  static double yToLat(double y) {
    final y2 = (180 - y * 360) * math.pi / 180;
    return 360 * math.atan(math.exp(y2)) / math.pi - 90;
  }
}
