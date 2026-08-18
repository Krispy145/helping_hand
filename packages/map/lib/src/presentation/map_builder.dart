import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapBuilder extends StatelessWidget {
  final LatLng? initialCenter;
  final double initialZoom;
  final List<Marker> markers;
  final List<Widget> layers;
  final MapController? mapController;
  final VoidCallback? onMapReady;
  final void Function(MapEvent event)? onMapEvent;

  const MapBuilder({
    super.key,
    this.initialCenter,
    this.initialZoom = 11.0,
    this.markers = const [],
    this.layers = const [],
    this.mapController,
    this.onMapReady,
    this.onMapEvent,
  });

  /// Softens Carto dark-matter so land reads as slate instead of pure black.
  static const _darkTileFilter = ColorFilter.matrix(<double>[
    1.35, 0.00, 0.05, 0, 28,
    0.00, 1.32, 0.08, 0, 28,
    0.04, 0.06, 1.45, 0, 38,
    0.00, 0.00, 0.00, 1, 0,
  ]);

  @override
  Widget build(BuildContext context) {
    final center = initialCenter ?? const LatLng(-33.9249, 18.4241);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final tiles = TileLayer(
      key: ValueKey(isDark ? 'carto-dark' : 'carto-voyager'),
      urlTemplate: isDark
          ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png'
          : 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
      subdomains: const ['a', 'b', 'c', 'd'],
      userAgentPackageName: 'com.helpinghand.map',
    );

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: center,
        initialZoom: initialZoom,
        backgroundColor: isDark ? const Color(0xFF2A3038) : const Color(0xFFF2EFE9),
        onMapReady: onMapReady,
        onMapEvent: onMapEvent,
      ),
      children: [
        if (isDark) ColorFiltered(colorFilter: _darkTileFilter, child: tiles) else tiles,
        ...layers,
        if (markers.isNotEmpty)
          MarkerLayer(
            key: ValueKey(markers.map((marker) => '${marker.point.latitude},${marker.point.longitude}').join('|')),
            markers: markers,
          ),
        SafeArea(
          child: RichAttributionWidget(
            attributions: [
              TextSourceAttribution('OpenStreetMap contributors', onTap: () {}),
              TextSourceAttribution('CARTO', onTap: () {}),
            ],
          ),
        ),
      ],
    );
  }
}
