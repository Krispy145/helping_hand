import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../data/repositories/map_repository.dart';

final mapRepositoryProvider = Provider<MapRepository>((ref) {
  return MapRepository();
});

final userLocationProvider = FutureProvider<LatLng?>((ref) async {
  final repo = ref.watch(mapRepositoryProvider);
  return repo.getCurrentLocation();
});
