import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:mundi_flutter_platform_client_app/app/core/notifications/channels.dart';
import 'package:mundi_flutter_platform_client_app/app/core/notifications/notification_payload.dart';
import 'package:mundi_flutter_platform_client_app/app/core/notifications/notification_service.dart';

class RenderDailyAgendaUseCase {
  final NotificationService _notificationService;

  RenderDailyAgendaUseCase(this._notificationService);

  /// Renders the morning reminder for the client: one card per appointment
  /// happening today.
  Future<void> execute(Map<String, String?> data) async {
    final appointmentId =
        int.tryParse(data[NotificationKeys.appointmentId] ?? '') ?? 0;
    final serviceName = data[NotificationKeys.serviceName] ?? 'Serviço';
    final providerName = data[NotificationKeys.providerName] ?? 'Profissional';
    final timeLabel = _formatTime(data[NotificationKeys.appointmentDatetime]);

    final body = timeLabel.isEmpty
        ? '$serviceName com $providerName'
        : '$serviceName com $providerName às $timeLabel';

    final notifId =
        ('daily_$appointmentId').hashCode.abs() % 2147483647;

    await _notificationService.createNotification(
      id: notifId,
      channelKey: AppChannels.dailyReminderChannelKey,
      title: 'Você tem um agendamento hoje',
      body: body,
      layout: NotificationLayout.Default,
      payload: {
        NotificationKeys.type: NotificationType.dailyAgenda,
        NotificationKeys.appointmentId: appointmentId.toString(),
      },
    );
  }

  String _formatTime(String? isoDate) {
    if (isoDate == null) return '';
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      return '${dt.hour.toString().padLeft(2, '0')}h${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }
}
