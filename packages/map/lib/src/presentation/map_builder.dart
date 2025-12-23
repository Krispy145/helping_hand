import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapBuilder extends StatelessWidget {
  final LatLng? initialCenter;
  final List<Marker> markers;
  final MapController? mapController;

  const MapBuilder({super.key, this.initialCenter, this.markers = const [], this.mapController});

  @override
  Widget build(BuildContext context) {
    // Default to New York if no location provided for MVP
    final center = initialCenter ?? const LatLng(40.7128, -74.0060);

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(initialCenter: center, initialZoom: 13.0),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.helpinghand.map',
          // Use a soft/calm tile style if possible, or standard OSM for MVP
          // For stricter "calm" design, we might overlay a color filter.
        ),
        MarkerLayer(markers: markers),
        // Copyright/Attribution for OSM
        SafeArea(
          child: RichAttributionWidget(attributions: [TextSourceAttribution('OpenStreetMap contributors', onTap: () {})]),
        ),
      ],
    );
  }
}
