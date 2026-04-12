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

  Schedule(
      {required this.id,
      required this.entrepreneurEntrepreneurId,
      required this.scheduledDate,
      required this.userUserId,
      required this.status,
      required this.modality,
      required this.cep,
      required this.entrepreneurPhone,
      this.optionwork = false});

  factory Schedule.fromMap(Map<String, dynamic> map) {
    final rawOptionwork = map['entrepreneur']['optionwork'];
    final optionwork = rawOptionwork != null
        ? rawOptionwork is int
            ? rawOptionwork == 1
            : rawOptionwork as bool
        : false;

    return Schedule(
        id: map['id'],
        userUserId: map['user']['userId'],
        entrepreneurEntrepreneurId: map['entrepreneur']['entrepreneurId'],
        scheduledDate: map['scheduledDate'],
        status: map['status'],
        cep: map['entrepreneur']['cep'],
        modality: Modality.fromMap(map['modality']),
        entrepreneurPhone: map['entrepreneur']['phone'],
        optionwork: optionwork);
  }

  @override
  String toString() {
    return 'Schedule{id: $id, scheduledDate: $scheduledDate, userUserId: $userUserId, entrepreneurEntrepreneurId: $entrepreneurEntrepreneurId, modality: $modality, cep: $cep, entrepreneurPhone: $entrepreneurPhone, status: $status, optionwork: $optionwork}';
  }
}
