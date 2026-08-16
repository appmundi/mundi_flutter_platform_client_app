import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mundi_flutter_platform_client_app/app/core/deep_link/deep_link_service.dart';
import 'package:mundi_flutter_platform_client_app/app/core/notifications/notification_service.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/config/ui_config.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/notifications/use_cases/handle_notification_tap_use_case.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/notifications/use_cases/register_fcm_token_use_case.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      DeepLinkService().init();
      NotificationService.instance.registerListeners();

      // Handle cold-start notification tap before anything else. Guarded on its
      // own: a throw here must not stop the permission request below from
      // being scheduled.
      try {
        final action = await AwesomeNotifications()
            .getInitialNotificationAction(removeFromActionEvents: true);
        if (action != null) {
          await Modular.get<HandleNotificationTapUseCase>().execute(action);
        }
      } catch (e) {
        debugPrint('Initial notification action failed: $e');
      }

      // Delayed 3s so the user sees the app before the permission dialog.
      Future.delayed(const Duration(seconds: 3), _bootstrapPush);
    });
  }

  /// Permission has to come first: on iOS the FCM token is only minted after
  /// the APNs registration that follows the user granting it.
  Future<void> _bootstrapPush() async {
    try {
      await NotificationService.instance.ensurePermission();
      await Modular.get<RegisterFcmTokenUseCase>().run();
      await NotificationService.instance.syncMarketingSubscription();
    } catch (e) {
      debugPrint('Push bootstrap failed: $e');
    }
  }

  @override
  void dispose() {
    DeepLinkService().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute('/splash/');
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) {
        return MaterialApp.router(
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            physics: const BouncingScrollPhysics(),
          ),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('pt', 'BR'),
          ],
          title: UiConfig.title,
          locale: const Locale('pt', 'BR'),
          theme: UiConfig.theme,
          routeInformationParser: Modular.routeInformationParser,
          routerDelegate: Modular.routerDelegate,
        );
      },
    );
  }
}
