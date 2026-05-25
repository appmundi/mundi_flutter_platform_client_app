abstract class NotificationType {
  static const String serviceStep = 'service_step';
  static const String cancellation = 'cancellation';
  static const String marketing = 'marketing';
}

abstract class NotificationKeys {
  static const String type = 'type';
  static const String appointmentId = 'appointment_id';
  static const String step = 'step';
  static const String providerName = 'provider_name';
  static const String providerAvatarUrl = 'provider_avatar_url';
  static const String eta = 'eta';
  static const String modalityTitle = 'modality_title';
  static const String serviceName = 'service_name';
  static const String otherPartyName = 'other_party_name';
  static const String otherPartyRole = 'other_party_role';
  static const String appointmentDatetime = 'appointment_datetime';
  static const String route = 'route';
  static const String campaignId = 'campaign_id';
}

enum ServiceStep {
  enRoute,
  started,
  finished;

  static ServiceStep fromString(String s) {
    return switch (s) {
      'en_route' => enRoute,
      'started' => started,
      'finished' => finished,
      _ => throw ArgumentError('Unknown step: $s'),
    };
  }

  int get progress => switch (this) {
        enRoute => 33,
        started => 66,
        finished => 100,
      };

  String get title => switch (this) {
        enRoute => 'Profissional a caminho',
        started => 'Serviço iniciado',
        finished => 'Serviço finalizado',
      };

  String get body => switch (this) {
        enRoute => 'Seu profissional está indo até você',
        started => 'Seu serviço foi iniciado',
        finished => 'Seu serviço foi concluído com sucesso',
      };
}
