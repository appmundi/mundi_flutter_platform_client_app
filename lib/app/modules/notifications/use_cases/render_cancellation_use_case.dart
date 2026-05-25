import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:mundi_flutter_platform_client_app/app/core/notifications/channels.dart';
import 'package:mundi_flutter_platform_client_app/app/core/notifications/notification_payload.dart';
import 'package:mundi_flutter_platform_client_app/app/core/notifications/notification_service.dart';

class RenderCancellationUseCase {
  final NotificationService _notificationService;

  RenderCancellationUseCase(this._notificationService);

  Future<void> execute(Map<String, String?> data) async {
    final appointmentId =
        int.tryParse(data[NotificationKeys.appointmentId] ?? '') ?? 0;
    final serviceName =
        data[NotificationKeys.serviceName] ?? 'Agendamento';
    final otherPartyName =
        data[NotificationKeys.otherPartyName] ?? 'Outra parte';
    final otherPartyRole = data[NotificationKeys.otherPartyRole] ?? '';
    final appointmentDatetime = data[NotificationKeys.appointmentDatetime];

    final roleLabel =
        otherPartyRole == 'user' ? 'cliente' : 'profissional';
    final dateLabel = _formatDate(appointmentDatetime);

    await _notificationService.createNotification(
      id: ('cancel_$appointmentId').hashCode.abs() % 2147483647,
      channelKey: AppChannels.cancellationChannelKey,
      title: 'Agendamento cancelado',
      body: '$otherPartyName ($roleLabel) cancelou "$serviceName"$dateLabel.',
      layout: NotificationLayout.BigText,
      payload: {
        NotificationKeys.type: NotificationType.cancellation,
        NotificationKeys.appointmentId: appointmentId.toString(),
      },
      actionButtons: [
        NotificationActionButton(
          key: 'view',
          label: 'Ver detalhes',
        ),
        NotificationActionButton(
          key: 'reschedule',
          label: 'Reagendar',
        ),
      ],
    );

    // Cancel any pending service-step notification for the same appointment
    await _notificationService.cancelById(
      appointmentId % 2147483647,
    );

    // Cancel any pending daily reminder for the same appointment
    await _notificationService.cancelById(
      ('reminder_$appointmentId').hashCode.abs() % 2147483647,
    );
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return '';
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      return ' em ${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')} às ${dt.hour.toString().padLeft(2, '0')}h${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }
}
