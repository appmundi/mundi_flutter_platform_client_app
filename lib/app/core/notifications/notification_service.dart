import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:flutter/foundation.dart';

import 'channels.dart';
import 'notification_controller.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      null,
      AppChannels.channels,
      channelGroups: AppChannels.groups,
      debug: kDebugMode,
    );

    await AwesomeNotificationsFcm().initialize(
      onFcmSilentDataHandle: NotificationController.silentDataHandle,
      onFcmTokenHandle: NotificationController.fcmTokenHandle,
      debug: kDebugMode,
    );
  }

  void registerListeners() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
    );
  }

  Future<bool> ensurePermission() async {
    final allowed = await AwesomeNotifications().isNotificationAllowed();
    if (!allowed) {
      return AwesomeNotifications().requestPermissionToSendNotifications();
    }
    return true;
  }

  Future<bool> createNotification({
    required int id,
    required String channelKey,
    required String title,
    required String body,
    NotificationLayout layout = NotificationLayout.Default,
    Map<String, String?>? payload,
    List<NotificationActionButton>? actionButtons,
    int? progress,
    bool locked = false,
    String? largeIcon,
  }) {
    return AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: channelKey,
        title: title,
        body: body,
        notificationLayout: layout,
        payload: payload,
        progress: progress?.toDouble(),
        locked: locked,
        largeIcon: largeIcon,
      ),
      actionButtons: actionButtons,
    );
  }

  Future<void> schedule({
    required int id,
    required String channelKey,
    required String title,
    required String body,
    required NotificationCalendar schedule,
    Map<String, String?>? payload,
  }) {
    return AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: channelKey,
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
        payload: payload,
      ),
      schedule: schedule,
    );
  }

  Future<void> cancelById(int id) => AwesomeNotifications().cancel(id);

  Future<String?> currentFcmToken() =>
      AwesomeNotificationsFcm().requestFirebaseAppToken();

  Future<void> subscribeToTopic(String topic) =>
      AwesomeNotificationsFcm().subscribeToTopic(topic);

  Future<void> unsubscribeFromTopic(String topic) =>
      AwesomeNotificationsFcm().unsubscribeToTopic(topic);
}
