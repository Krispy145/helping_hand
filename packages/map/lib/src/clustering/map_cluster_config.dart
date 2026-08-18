/// Tuning for hierarchical grid clustering.
///
/// [radius] is in CSS pixels at the current zoom, matching Mapbox Supercluster:
/// two points closer than this on screen are merged. [extent] is the world size
/// in pixels at zoom 0 (512 matches web-mercator tiles at retina-style scale).
final class MapClusterConfig {
  final int minZoom;
  final int maxZoom;
  final int minPoints;
  final double radius;
  final double extent;

  const MapClusterConfig({
    this.minZoom = 0,
    this.maxZoom = 20,
    this.minPoints = 2,
    this.radius = 60,
    this.extent = 512,
  });
}
