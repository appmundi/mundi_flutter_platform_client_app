import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:mundi_flutter_platform_client_app/app/models/entrepreneur.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/address/i_address_repository.dart';

class AddressRepository implements IAddressRepository {
  @override
  Future<List<Entrepreneur>> calculateDistante(
    List<Entrepreneur> entrepreneurs,
  ) async {
    try {
      final position = await _myLocation();

      for (Entrepreneur entrepreneur in entrepreneurs) {
        if (entrepreneur.latitude == 0.0 && entrepreneur.longitude == 0.0) {
          entrepreneur.distance = null;
          continue;
        }

        final distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          entrepreneur.latitude,
          entrepreneur.longitude,
        );

        entrepreneur.distance = distance / 1000;
      }

      return entrepreneurs;
    } catch (e) {
      print(e);
      return entrepreneurs;
    }
  }

  Future<Position> _myLocation() async {
    final permission = await Geolocator.checkPermission();
    if ([
      LocationPermission.denied,
      LocationPermission.deniedForever,
    ].contains(permission)) {
      await Geolocator.requestPermission();
    }

    final position = await Geolocator.getCurrentPosition();

    return position;
  }
}
