abstract class IReserveRepository {
  Future<void> createReserve({
    required int entrepreneurId,
    required String scheduledDate,
    required List<int> modalityIds,
    required String description,
    Map<String, String>? address,
  });

  Future<List<String>> checkHour({
    required int entrepreneurId,
    required String date,
    int? duration,
  });
}
