import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../clustering/map_cluster_hit.dart';
import '../../clustering/map_cluster_index.dart';
import 'request_map_pin.dart';

/// Renders [index] as a [MarkerLayer], reclustering only when the integer zoom
/// or the index instance changes. Pan frames reuse the last marker list.
class ClusteredMarkerLayer<T> extends StatefulWidget {
  final MapClusterIndex<T> index;
  final Widget Function(BuildContext context, T data) pointBuilder;
  final Widget Function(BuildContext context, MapClusterGroup<T> cluster) clusterBuilder;
  final void Function(T data)? onPointTap;
  final void Function(MapClusterGroup<T> cluster)? onClusterTap;
  final double markerWidth;
  final double markerHeight;

  const ClusteredMarkerLayer({
    super.key,
    required this.index,
    required this.pointBuilder,
    required this.clusterBuilder,
    this.onPointTap,
    this.onClusterTap,
    this.markerWidth = RequestMapPin.size,
    this.markerHeight = RequestMapPin.size,
  });

  @override
  State<ClusteredMarkerLayer<T>> createState() => _ClusteredMarkerLayerState<T>();
}

class _ClusteredMarkerLayerState<T> extends State<ClusteredMarkerLayer<T>> {
  MapClusterIndex<T>? _index;
  int? _zoom;
  Brightness? _brightness;
  List<Marker> _markers = const [];

  @override
  Widget build(BuildContext context) {
    final camera = MapCamera.of(context);
    final zoom = camera.zoom.floor();
    final brightness = Theme.of(context).brightness;
    if (!identical(widget.index, _index) || zoom != _zoom || brightness != _brightness) {
      _index = widget.index;
      _zoom = zoom;
      _brightness = brightness;
      _markers = _buildMarkers(context, camera.zoom);
    }
    return MarkerLayer(markers: _markers);
  }

  List<Marker> _buildMarkers(BuildContext context, double zoom) {
    final hits = widget.index.search(zoom: zoom);
    return [
      for (final hit in hits)
        Marker(
          key: ValueKey(hit.key),
          point: hit.position,
          width: widget.markerWidth,
          height: widget.markerHeight,
          child: GestureDetector(
            onTap: () => _handleTap(hit),
            child: switch (hit) {
              MapClusterLeaf<T>(:final data) => widget.pointBuilder(context, data),
              MapClusterGroup<T>() => widget.clusterBuilder(context, hit),
            },
          ),
        ),
    ];
  }

  void _handleTap(MapClusterHit<T> hit) {
    switch (hit) {
      case MapClusterLeaf<T>(:final data):
        widget.onPointTap?.call(data);
      case MapClusterGroup<T>():
        widget.onClusterTap?.call(hit);
    }
  }
}
