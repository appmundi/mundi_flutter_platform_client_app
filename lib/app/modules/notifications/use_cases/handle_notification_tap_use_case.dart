import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mundi_flutter_platform_client_app/app/core/notifications/notification_payload.dart';

class HandleNotificationTapUseCase {
  Future<void> execute(ReceivedAction action) async {
    try {
      final payload = action.payload;
      if (payload == null) return;

      final type = payload[NotificationKeys.type];
      final appointmentId = payload[NotificationKeys.appointmentId];
      final route = payload[NotificationKeys.route];

      switch (type) {
        case NotificationType.serviceStep:
        case NotificationType.cancellation:
          _navigate(appointmentId != null
              ? '/home/schedules/?appointmentId=$appointmentId'
              : '/home/schedules/');
          break;
        case NotificationType.marketing:
          _navigate(route ?? '/home/');
          break;
        default:
          _navigate('/home/');
      }
    } catch (_) {
      // Navigation may fail on cold start — handled by getInitialNotificationAction
    }
  }

  void _navigate(String route) {
    try {
      Modular.to.pushNamed(route);
    } catch (_) {
      Modular.to.pushNamed('/home/');
    }
  }
}
