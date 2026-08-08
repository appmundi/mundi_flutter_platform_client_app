import 'package:mundi_flutter_platform_client_app/app/models/entrepreneur.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/entrepeneur/entrepreneur_search_result.dart';

abstract class IEntrepreneurRepository {
  Future<List<Entrepreneur>?> searchAll([String? query, String? section]);
  Future<EntrepreneurSearchResult> nearby({
    String? query,
    String? section,
    double? latitude,
    double? longitude,
  });
  Future<Entrepreneur?> search(int id);
}
