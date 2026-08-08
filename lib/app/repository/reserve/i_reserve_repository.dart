import 'package:mundi_flutter_platform_client_app/app/models/address.dart';

abstract class IReserveRepository {
  Future<void> createReserve({
    required int entrepreneurId,
    required String scheduledDate,
    required List<int> modalityIds,
    required String description,
    Address? address,
  });

  Future<List<String>> checkHour({
    required int entrepreneurId,
    required String date,
    int? duration,
  });
}
