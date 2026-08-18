import 'package:flutter_test/flutter_test.dart';
import 'package:map/map.dart';

void main() {
  const capeTown = LatLng(-33.9249, 18.4241);
  const config = MapClusterConfig();

  ClusterPoint<String> point(String id, LatLng position) {
    return ClusterPoint(id: id, position: position, data: id);
  }

  MapClusterIndex<String> indexFor(List<ClusterPoint<String>> points) {
    return MapClusterIndex.build(points, config: config);
  }

  int clusterCount(List<MapClusterHit<String>> hits) {
    return hits.whereType<MapClusterGroup<String>>().length;
  }

  test('empty input yields no hits', () {
    final index = indexFor([]);
    expect(index.search(zoom: 11), isEmpty);
    expect(index.pointCount, 0);
  });

  test('a single point is never clustered', () {
    final index = indexFor([point('a', capeTown)]);
    for (final zoom in [0, 11, 20]) {
      final hits = index.search(zoom: zoom.toDouble());
      expect(hits, hasLength(1));
      expect(hits.single, isA<MapClusterLeaf<String>>());
      expect((hits.single as MapClusterLeaf<String>).data, 'a');
    }
  });

  test('coincident points stay clustered at every zoom', () {
    final index = indexFor([
      point('a', capeTown),
      point('b', capeTown),
      point('c', capeTown),
    ]);

    for (final zoom in [0, 11, 16, 20]) {
      final hits = index.search(zoom: zoom.toDouble());
      expect(hits, hasLength(1));
      final group = hits.single as MapClusterGroup<String>;
      expect(group.count, 3);
      expect(group.items, unorderedEquals(['a', 'b', 'c']));
      expect(group.isCoincident, isTrue);
    }
  });

  test('nearby neighborhood points cluster at city overview and split when zoomed in', () {
    // ~120m apart — one block. Clusters at zoom 11, separates by street-level zoom.
    final a = capeTown;
    final b = LatLng(capeTown.latitude + 0.0011, capeTown.longitude);
    final index = indexFor([point('a', a), point('b', b)]);

    final overview = index.search(zoom: 11);
    expect(overview, hasLength(1));
    expect(overview.single, isA<MapClusterGroup<String>>());
    expect(overview.single.count, 2);

    final street = index.search(zoom: 18);
    expect(street, hasLength(2));
    expect(clusterCount(street), 0);
  });

  test('city-scale points stay separate at neighborhood zoom', () {
    final a = capeTown;
    final b = LatLng(capeTown.latitude + 0.08, capeTown.longitude); // ~9km
    final index = indexFor([point('a', a), point('b', b)]);

    final hits = index.search(zoom: 12);
    expect(hits, hasLength(2));
    expect(clusterCount(hits), 0);
  });

  test('search bounds drops off-screen clusters', () {
    final west = capeTown;
    final east = LatLng(capeTown.latitude, capeTown.longitude + 0.5);
    final index = indexFor([point('west', west), point('east', east)]);

    final hits = index.search(
      zoom: 12,
      bounds: LatLngBounds(
        LatLng(west.latitude - 0.01, west.longitude - 0.01),
        LatLng(west.latitude + 0.01, west.longitude + 0.01),
      ),
    );

    expect(hits, hasLength(1));
    expect((hits.single as MapClusterLeaf<String>).data, 'west');
  });

  test('cluster count matches the full member set for a dense group', () {
    final points = [
      for (var i = 0; i < 40; i++)
        point('p$i', LatLng(capeTown.latitude + i * 0.00002, capeTown.longitude + i * 0.00002)),
    ];
    final index = indexFor(points);
    final hits = index.search(zoom: 10);
    expect(hits, hasLength(1));
    final group = hits.single as MapClusterGroup<String>;
    expect(group.count, 40);
    expect(group.items.toSet(), hasLength(40));
  });

  test('integer zoom is stable: 11.0 and 11.9 return the same clustering', () {
    final a = capeTown;
    final b = LatLng(capeTown.latitude + 0.0011, capeTown.longitude);
    final index = indexFor([point('a', a), point('b', b)]);
    final low = index.search(zoom: 11.0);
    final high = index.search(zoom: 11.9);
    expect(low.single.key, high.single.key);
    expect(low.single.count, high.single.count);
  });
}
