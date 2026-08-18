import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:map/map.dart';
import 'package:models/models.dart';
import 'package:ui/ui.dart';

import '../../../router.dart';
import '../../chat/data/chat_models.dart';
import '../../chat/data/chat_repository.dart';
import '../../reports/presentation/report_entry.dart';
import '../../requests/data/request_repository.dart';
import '../../requests/presentation/request_assist.dart';
import '../../requests/providers/request_provider.dart';
import 'map_controller.dart' as logic;

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  static const _capeTownCenter = LatLng(-33.9249, 18.4241);
  static const _userZoom = 14.0;
  static const _capeTownOverviewZoom = 11.0;
  static final _emptyClusterIndex = MapClusterIndex<RequestDto>.build(const []);

  final MapController _mapController = MapController();
  Timer? _idleRefreshTimer;
  String? _lastBoundsKey;
  bool _didCenterOnUser = false;
  MapClusterIndex<RequestDto> _clusterIndex = _emptyClusterIndex;
  int? _clusterSignature;

  @override
  void dispose() {
    _idleRefreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(logic.mapControllerProvider);
    final locationAsync = ref.watch(userLocationProvider);
    final requestsAsync = ref.watch(nearbyRequestsProvider);
    final mySessions = ref.watch(mySessionsProvider).asData?.value;
    final location = locationAsync.asData?.value;

    if (locationAsync.isLoading && location == null) {
      return const Scaffold(body: Center(child: BreathingLoader()));
    }

    if (location != null) {
      _didCenterOnUser = true;
    }

    ref.listen(userLocationProvider, (previous, next) {
      final userLocation = next.asData?.value;
      if (userLocation == null || _didCenterOnUser) return;
      _centerOnUser(userLocation);
    });

    final clusterIndex = requestsAsync.maybeWhen(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      data: _indexFor,
      orElse: () => _clusterIndex,
    );

    final overlayMarkers = <Marker>[
      if (location != null)
        Marker(
          point: location,
          width: 24,
          height: 24,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.information,
              shape: BoxShape.circle,
              border: Border.all(color: context.surface, width: 2),
              boxShadow: [BoxShadow(color: context.information.withValues(alpha: 0.4), blurRadius: 8, spreadRadius: 2)],
            ),
            child: Center(child: Icon(Icons.circle, size: 12, color: context.onInformation)),
          ),
        ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          MapBuilder(
            mapController: _mapController,
            initialCenter: location ?? _capeTownCenter,
            initialZoom: location != null ? _userZoom : _capeTownOverviewZoom,
            markers: overlayMarkers,
            layers: [
              ClusteredMarkerLayer<RequestDto>(
                index: clusterIndex,
                pointBuilder: (context, req) => RequestMapPin(busy: req.isBusy),
                clusterBuilder: (context, cluster) {
                  final allBusy = cluster.items.every((req) => req.isBusy);
                  return RequestMapPin(busy: allBusy, badgeCount: cluster.count);
                },
                onPointTap: (req) {
                  final mine = sessionForRequest(mySessions, req.id);
                  _showRequestDetails(context, ref, req, mine != null);
                },
                onClusterTap: (cluster) => _onClusterTap(context, ref, cluster, mySessions),
              ),
            ],
            onMapReady: _scheduleVisibleRefresh,
            onMapEvent: _onMapEvent,
          ),
          if (state.isSearching)
            Positioned.fill(
              child: MapRadar(color: context.primary, size: MediaQuery.of(context).size.width * 0.8),
            ),
          Positioned(
            right: 16,
            top: MediaQuery.of(context).viewInsets.top + 164,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MapZoomButtons(
                  onZoomIn: () {
                    final currentZoom = _mapController.camera.zoom;
                    _mapController.move(_mapController.camera.center, currentZoom + 1);
                  },
                  onZoomOut: () {
                    final currentZoom = _mapController.camera.zoom;
                    _mapController.move(_mapController.camera.center, currentZoom - 1);
                  },
                ),
                const SizedBox(height: 16),
                MapLocationButton(
                  onPressed: () {
                    if (location != null) {
                      _mapController.move(location, _userZoom);
                    } else {
                      _mapController.move(_capeTownCenter, _capeTownOverviewZoom);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _centerOnUser(LatLng userLocation) {
    _didCenterOnUser = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        _mapController.move(userLocation, _userZoom);
      } on Exception {
        // Map is not attached yet; initialCenter already used the user location when available.
      }
    });
  }

  void _onMapEvent(MapEvent event) {
    final movementEnded = event is MapEventMoveEnd || event is MapEventFlingAnimationEnd || event is MapEventDoubleTapZoomEnd || event is MapEventNonRotatedSizeChange;
    if (!movementEnded) return;
    _scheduleVisibleRefresh();
  }

  void _scheduleVisibleRefresh() {
    _idleRefreshTimer?.cancel();
    _idleRefreshTimer = Timer(const Duration(milliseconds: 350), _refreshVisibleRequests);
  }

  Future<void> _refreshVisibleRequests() async {
    NearbyBounds bounds;
    try {
      bounds = _boundsFromCamera(_mapController.camera.visibleBounds);
    } catch (_) {
      return;
    }

    if (!_isUsableBounds(bounds)) return;

    final boundsKey = '${bounds.minLat.toStringAsFixed(4)},${bounds.minLng.toStringAsFixed(4)},${bounds.maxLat.toStringAsFixed(4)},${bounds.maxLng.toStringAsFixed(4)}';
    if (boundsKey == _lastBoundsKey) return;
    _lastBoundsKey = boundsKey;

    ref.read(logic.mapControllerProvider.notifier).setSearching(true);
    try {
      await ref.read(nearbyRequestsProvider.notifier).refresh(bounds: bounds);
    } finally {
      if (mounted) {
        await ref.read(logic.mapControllerProvider.notifier).setSearching(false);
      }
    }
  }

  NearbyBounds _boundsFromCamera(LatLngBounds visible) {
    final latSpan = (visible.north - visible.south).abs();
    final lngSpan = (visible.east - visible.west).abs();
    final latPad = latSpan * 0.1;
    final lngPad = lngSpan * 0.1;
    return NearbyBounds(minLat: visible.south - latPad, minLng: visible.west - lngPad, maxLat: visible.north + latPad, maxLng: visible.east + lngPad);
  }

  bool _isUsableBounds(NearbyBounds bounds) {
    final latSpan = (bounds.maxLat - bounds.minLat).abs();
    final lngSpan = (bounds.maxLng - bounds.minLng).abs();
    return latSpan > 0.0005 && lngSpan > 0.0005;
  }

  MapClusterIndex<RequestDto> _indexFor(List<RequestDto> requests) {
    var signature = requests.length;
    for (final req in requests) {
      signature = Object.hash(signature, req.id, req.lat, req.lng, req.status);
    }
    if (signature == _clusterSignature) return _clusterIndex;

    _clusterSignature = signature;
    return _clusterIndex = MapClusterIndex.build([
      for (final req in requests)
        if (req.lat != null && req.lng != null) ClusterPoint(id: req.id, position: LatLng(req.lat!, req.lng!), data: req),
    ]);
  }

  void _onClusterTap(BuildContext context, WidgetRef ref, MapClusterGroup<RequestDto> cluster, List<ChatSessionDetails>? mySessions) {
    final currentZoom = _mapController.camera.zoom;
    if (cluster.isCoincident || currentZoom >= 17.5) {
      _showClusterList(context, ref, cluster.items, mySessions);
      return;
    }

    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: cluster.bounds,
        padding: const EdgeInsets.fromLTRB(48, 140, 48, 48),
        maxZoom: 18,
      ),
    );
  }

  void _showClusterList(BuildContext context, WidgetRef ref, List<RequestDto> requests, List<ChatSessionDetails>? mySessions) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 24),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text('${requests.length} requests here', style: context.h2),
              ),
              for (final req in requests)
                ListTile(
                  title: Text(req.title),
                  subtitle: Text(req.isBusy ? 'Busy — someone is helping' : req.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                  onTap: () {
                    Navigator.pop(ctx);
                    final mine = sessionForRequest(mySessions, req.id);
                    _showRequestDetails(context, ref, req, mine != null);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _showRequestDetails(BuildContext context, WidgetRef ref, RequestDto req, bool isMine) {
    final busy = req.isBusy;
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(req.title, style: context.h2),
            const SizedBox(height: 8),
            Text(req.description, style: context.bodyLarge),
            if (busy) ...[const SizedBox(height: 8), Text(isMine ? 'This request is busy. You already have a chat.' : 'Busy — someone is already helping.', style: context.bodySmall)],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await openOrStartAssist(context: context, ref: ref, request: req);
                },
                child: Text(
                  isMine
                      ? 'Open chat'
                      : busy
                      ? 'Busy'
                      : 'Offer Help',
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.push(
                    AppRoutes.report,
                    extra: ReportEntry(
                      requestId: req.id,
                      targetUserId: req.user?.id,
                      suggestedType: ReportTypeDto.HELPEE_MISUSE,
                    ),
                  );
                },
                child: Text('Report this request', style: TextStyle(color: context.error)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
