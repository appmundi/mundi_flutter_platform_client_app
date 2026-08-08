import 'package:mundi_flutter_platform_client_app/app/models/entrepreneur.dart';

enum AppliedGeoFilter { distance, uf, none }

class EntrepreneurSearchResult {
  final List<Entrepreneur> data;
  final AppliedGeoFilter appliedFilter;
  final String? clientUf;

  const EntrepreneurSearchResult({
    required this.data,
    required this.appliedFilter,
    this.clientUf,
  });

  factory EntrepreneurSearchResult.fromMap(Map<String, dynamic> map) {
    return EntrepreneurSearchResult(
      data: ((map['data'] as List?) ?? [])
          .map<Entrepreneur>((item) => Entrepreneur.fromMap(item))
          .toList(),
      appliedFilter: switch (map['appliedFilter']) {
        'distance' => AppliedGeoFilter.distance,
        'uf' => AppliedGeoFilter.uf,
        _ => AppliedGeoFilter.none,
      },
      clientUf: map['clientUf'] as String?,
    );
  }
}
