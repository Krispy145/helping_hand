import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapBuilder extends StatelessWidget {
  final LatLng? initialCenter;
  final List<Marker> markers;
  final MapController? mapController;
  final VoidCallback? onMapReady;
  final void Function(MapEvent event)? onMapEvent;

  const MapBuilder({
    super.key,
    this.initialCenter,
    this.markers = const [],
    this.mapController,
    this.onMapReady,
    this.onMapEvent,
  });

  @override
  Widget build(BuildContext context) {
    final center = initialCenter ?? const LatLng(-33.9249, 18.4241);

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: center,
        initialZoom: 13.0,
        onMapReady: onMapReady,
        onMapEvent: onMapEvent,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.helpinghand.map',
        ),
        MarkerLayer(
          key: ValueKey(markers.map((marker) => '${marker.point.latitude},${marker.point.longitude}').join('|')),
          markers: markers,
        ),
        SafeArea(
          child: RichAttributionWidget(attributions: [TextSourceAttribution('OpenStreetMap contributors', onTap: () {})]),
        ),
      ],
    );
  }
}
