import 'package:geolocator/geolocator.dart';
import 'package:mundi_flutter_platform_client_app/app/core/location/i_location_service.dart';

class LocationService implements ILocationService {
  static const _cacheTtl = Duration(seconds: 60);

  Position? _cachedPosition;
  DateTime? _cachedAt;
  Future<Position?>? _inFlight;

  @override
  Future<Position?> currentPosition() {
    final cachedAt = _cachedAt;
    if (_cachedPosition != null &&
        cachedAt != null &&
        DateTime.now().difference(cachedAt) < _cacheTtl) {
      return Future.value(_cachedPosition);
    }

    return _inFlight ??= _fetch().whenComplete(() => _inFlight = null);
  }

  Future<Position?> _fetch() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition()
          .timeout(const Duration(seconds: 5));

      _cachedPosition = position;
      _cachedAt = DateTime.now();
      return position;
    } catch (_) {
      return null;
    }
  }
}
