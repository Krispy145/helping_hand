import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapRepository {
  Future<LatLng?> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }

    if (permission == LocationPermission.deniedForever) return null;

    final lastKnown = await Geolocator.getLastKnownPosition();
    if (lastKnown != null) {
      return LatLng(lastKnown.latitude, lastKnown.longitude);
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium, timeLimit: Duration(seconds: 2)),
      );
      return LatLng(position.latitude, position.longitude);
    } on Exception {
      return null;
    }
  }
}
