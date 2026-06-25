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

      // Handle cold-start notification tap before anything else
      final action = await AwesomeNotifications()
          .getInitialNotificationAction(removeFromActionEvents: true);
      if (action != null) {
        await Modular.get<HandleNotificationTapUseCase>().execute(action);
      }

      await Modular.get<RegisterFcmTokenUseCase>().run();
      await NotificationService.instance.subscribeToTopic('marketing_general');

      // Request permission after 3s so user sees the app first
      Future.delayed(const Duration(seconds: 3), () async {
        await NotificationService.instance.ensurePermission();
      });
    });
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
