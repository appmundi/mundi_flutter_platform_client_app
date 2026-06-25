import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:mundi_flutter_platform_client_app/app/core/notifications/channels.dart';
import 'package:mundi_flutter_platform_client_app/app/core/notifications/notification_payload.dart';
import 'package:mundi_flutter_platform_client_app/app/core/notifications/notification_service.dart';
import 'package:timezone/timezone.dart' as tz;

class ScheduleDailyReminderUseCase {
  final NotificationService _notificationService;

  ScheduleDailyReminderUseCase(this._notificationService);

  /// Schedules a morning-of reminder at 08:00 America/Sao_Paulo for the given appointment.
  Future<void> scheduleForAppointment({
    required int appointmentId,
    required DateTime scheduledDate,
    required String serviceName,
    required String providerName,
  }) async {
    final saopaulo = tz.getLocation('America/Sao_Paulo');
    final localDate = tz.TZDateTime.from(scheduledDate, saopaulo);

    // Schedule at 08:00 on the appointment day
    final reminderTime = tz.TZDateTime(
      saopaulo,
      localDate.year,
      localDate.month,
      localDate.day,
      8,
      0,
    );

    // Skip if the reminder time has already passed
    if (reminderTime.isBefore(tz.TZDateTime.now(saopaulo))) return;

    final notifId =
        ('reminder_$appointmentId').hashCode.abs() % 2147483647;

    await _notificationService.schedule(
      id: notifId,
      channelKey: AppChannels.dailyReminderChannelKey,
      title: 'Você tem um serviço hoje!',
      body: '$serviceName com $providerName',
      schedule: NotificationCalendar(
        year: reminderTime.year,
        month: reminderTime.month,
        day: reminderTime.day,
        hour: reminderTime.hour,
        minute: reminderTime.minute,
        second: 0,
        millisecond: 0,
        preciseAlarm: true,
        allowWhileIdle: true,
      ),
      payload: {
        NotificationKeys.type: NotificationType.serviceStep,
        NotificationKeys.appointmentId: appointmentId.toString(),
      },
    );
  }

  /// Cancels the morning reminder for the given appointment (e.g., on cancellation).
  Future<void> cancelForAppointment(int appointmentId) async {
    final notifId =
        ('reminder_$appointmentId').hashCode.abs() % 2147483647;
    await _notificationService.cancelById(notifId);
  }
}
