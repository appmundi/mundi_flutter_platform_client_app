import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:mundi_flutter_platform_client_app/app/core/notifications/channels.dart';
import 'package:mundi_flutter_platform_client_app/app/core/notifications/notification_payload.dart';
import 'package:mundi_flutter_platform_client_app/app/core/notifications/notification_service.dart';

class RenderServiceStepUseCase {
  final NotificationService _notificationService;

  RenderServiceStepUseCase(this._notificationService);

  Future<void> execute(Map<String, String?> data) async {
    final stepStr = data[NotificationKeys.step];
    if (stepStr == null) return;

    final step = ServiceStep.fromString(stepStr);
    final appointmentId =
        int.tryParse(data[NotificationKeys.appointmentId] ?? '') ?? 0;
    final providerName = data[NotificationKeys.providerName] ?? 'Profissional';
    final modalityTitle = data[NotificationKeys.modalityTitle] ?? 'Serviço';
    final eta = data[NotificationKeys.eta];

    final body = step == ServiceStep.enRoute && (eta?.isNotEmpty ?? false)
        ? '${step.body} — ETA: $eta'
        : step.body;

    // Use appointmentId as notification ID so subsequent steps replace the card
    final notifId = appointmentId % 2147483647;

    final isFinished = step == ServiceStep.finished;

    await _notificationService.createNotification(
      id: notifId,
      channelKey: AppChannels.serviceStepChannelKey,
      title: '${step.title} • $modalityTitle',
      body: '$body\n$providerName',
      layout: NotificationLayout.ProgressBar,
      progress: step.progress, // int 33 / 66 / 100
      locked: !isFinished,
      payload: {
        NotificationKeys.type: NotificationType.serviceStep,
        NotificationKeys.appointmentId: appointmentId.toString(),
      },
      actionButtons: isFinished
          ? [
              NotificationActionButton(
                key: 'view',
                label: 'Ver detalhes',
              ),
            ]
          : null,
    );
  }
}
