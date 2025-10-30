import 'package:mundi_flutter_platform_client_app/app/models/entrepreneur.dart';

abstract class IAddressRepository {
  Future<List<Entrepreneur>> calculateDistante(List<Entrepreneur> entrepreneurs);
}