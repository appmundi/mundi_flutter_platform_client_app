import 'package:mundi_flutter_platform_client_app/app/models/modality.dart';

class Reservation {
  final int userId;
  final int entrepreneurId;
  final Modality modality;
  final DateTime startAt;
  final String? entrepreneurPhone;
  final int scheduleId;
  final bool optionwork;
  final String? entrepreneurAddress;

  const Reservation({
    required this.userId,
    required this.entrepreneurId,
    required this.modality,
    required this.startAt,
    required this.entrepreneurPhone,
    required this.scheduleId,
    this.optionwork = false,
    this.entrepreneurAddress,
  });
}
