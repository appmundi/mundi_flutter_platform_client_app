import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:get_it/get_it.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/notifications/use_cases/handle_notification_tap_use_case.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/notifications/use_cases/register_fcm_token_use_case.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/notifications/use_cases/render_cancellation_use_case.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/notifications/use_cases/render_daily_agenda_use_case.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/notifications/use_cases/render_service_step_use_case.dart';

import 'notification_background_di.dart';
import 'notification_payload.dart';
import 'notification_service.dart';

@pragma('vm:entry-point')
class NotificationController {
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    NotificationBackgroundDI.setup();
    await GetIt.I<HandleNotificationTapUseCase>().execute(receivedAction);
  }

  @pragma('vm:entry-point')
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {}

  @pragma('vm:entry-point')
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {}

  @pragma('vm:entry-point')
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {}

  @pragma('vm:entry-point')
  static Future<void> silentDataHandle(FcmSilentData silentData) async {
    NotificationBackgroundDI.setup();
    // The silent handler runs in a background isolate where main() never ran,
    // so AwesomeNotifications must be initialized here before createNotification
    // can display anything.
    await GetIt.I<NotificationService>().ensureCoreInitialized();
    final type = silentData.data?[NotificationKeys.type];

    if (type == NotificationType.serviceStep) {
      await GetIt.I<RenderServiceStepUseCase>().execute(silentData.data!);
    } else if (type == NotificationType.cancellation) {
      await GetIt.I<RenderCancellationUseCase>().execute(silentData.data!);
    } else if (type == NotificationType.dailyAgenda) {
      await GetIt.I<RenderDailyAgendaUseCase>().execute(silentData.data!);
    }
  }

  @pragma('vm:entry-point')
  static Future<void> fcmTokenHandle(String token) async {
    NotificationBackgroundDI.setup();
    await GetIt.I<RegisterFcmTokenUseCase>().storeToken(token);
  }
}
