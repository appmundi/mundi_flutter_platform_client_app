import 'package:mundi_flutter_platform_client_app/app/models/entrepreneur.dart';

abstract class IEntrepreneurRepository {
  Future<List<Entrepreneur>?> searchAll([String? query, String? section]);
  Future<Entrepreneur?> search(int id);
}
