import 'modality.dart';

class Schedule {
  int id;
  String scheduledDate;
  int userUserId;
  int entrepreneurEntrepreneurId;
  Modality modality;
  String cep;
  String entrepreneurPhone;
  String? status;
  bool optionwork;
  double entrepreneurLatitude;
  double entrepreneurLongitude;
  String entrepreneurAddress;

  Schedule(
      {required this.id,
      required this.entrepreneurEntrepreneurId,
      required this.scheduledDate,
      required this.userUserId,
      required this.status,
      required this.modality,
      required this.cep,
      required this.entrepreneurPhone,
      this.optionwork = false,
      this.entrepreneurLatitude = 0.0,
      this.entrepreneurLongitude = 0.0,
      this.entrepreneurAddress = ''});

  bool get hasValidCoordinates =>
      entrepreneurLatitude != 0.0 && entrepreneurLongitude != 0.0;

  factory Schedule.fromMap(Map<String, dynamic> map) {
    final rawOptionwork = map['entrepreneur']['optionwork'];
    final optionwork = rawOptionwork != null
        ? rawOptionwork is int
            ? rawOptionwork == 1
            : rawOptionwork as bool
        : false;

    final entrepreneurMap = map['entrepreneur'] as Map<String, dynamic>;

    return Schedule(
        id: map['id'],
        userUserId: map['user']['userId'],
        entrepreneurEntrepreneurId: entrepreneurMap['entrepreneurId'],
        scheduledDate: map['scheduledDate'],
        status: map['status'],
        cep: entrepreneurMap['cep'] ?? '',
        modality: Modality.fromMap(map['modality']),
        entrepreneurPhone: entrepreneurMap['phone'] ?? '',
        optionwork: optionwork,
        entrepreneurLatitude:
            (entrepreneurMap['latitude'] as num?)?.toDouble() ?? 0.0,
        entrepreneurLongitude:
            (entrepreneurMap['longitude'] as num?)?.toDouble() ?? 0.0,
        entrepreneurAddress:
            '${entrepreneurMap['address'] ?? ''}, ${entrepreneurMap['addressNumber'] ?? ''} - ${entrepreneurMap['city'] ?? ''}, ${entrepreneurMap['state'] ?? ''}');
  }

  @override
  String toString() {
    return 'Schedule{id: $id, scheduledDate: $scheduledDate, userUserId: $userUserId, entrepreneurEntrepreneurId: $entrepreneurEntrepreneurId, modality: $modality, cep: $cep, entrepreneurPhone: $entrepreneurPhone, status: $status, optionwork: $optionwork}';
  }
}
