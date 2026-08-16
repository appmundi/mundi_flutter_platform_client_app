import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'channels.dart';
import 'notification_controller.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  bool _coreInitialized = false;

  /// Initializes only the core AwesomeNotifications plugin (channels + groups).
  /// Idempotent and safe to call from a background isolate — required before
  /// [createNotification] works inside the FCM silent data handler, since the
  /// background isolate never runs `main()` and therefore never calls
  /// [initialize].
  Future<void> ensureCoreInitialized() async {
    if (_coreInitialized) return;
    await AwesomeNotifications().initialize(
      'resource://drawable/ic_stat_notification',
      AppChannels.channels,
      channelGroups: AppChannels.groups,
      debug: kDebugMode,
    );
    _coreInitialized = true;
  }

  Future<void> initialize() async {
    await ensureCoreInitialized();

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

  /// The plugin returns '' (never null) when no token is available yet, so
  /// normalize it to null for callers.
  Future<String?> currentFcmToken() async {
    final token = await AwesomeNotificationsFcm().requestFirebaseAppToken();
    return token.isEmpty ? null : token;
  }

  /// Aplica a preferência salva de marketing ao tópico. Chamado a cada abertura
  /// do app: antes o boot reinscrevia incondicionalmente, o que desfazia o
  /// opt-out do usuário na abertura seguinte.
  Future<void> syncMarketingSubscription() async {
    final sp = await SharedPreferences.getInstance();
    final enabled = sp.getBool(NotificationPrefs.marketingEnabled) ?? true;

    await unsubscribeFromTopic(AppChannels.legacyMarketingTopic);

    if (enabled) {
      await subscribeToTopic(AppChannels.marketingTopic);
    } else {
      await unsubscribeFromTopic(AppChannels.marketingTopic);
    }
  }

  Future<void> subscribeToTopic(String topic) =>
      AwesomeNotificationsFcm().subscribeToTopic(topic);

  Future<void> unsubscribeFromTopic(String topic) =>
      AwesomeNotificationsFcm().unsubscribeToTopic(topic);
}
