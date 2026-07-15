import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mundi_flutter_platform_client_app/app/app_module.dart';
import 'package:mundi_flutter_platform_client_app/app/app_widget.dart';
import 'package:mundi_flutter_platform_client_app/app/core/config/application_config.dart';
import 'package:mundi_flutter_platform_client_app/app/core/notifications/notification_background_di.dart';
import 'package:mundi_flutter_platform_client_app/app/core/notifications/notification_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  await ApplicationConfig().configure();
  await initializeDateFormatting('pt_BR', null);

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));

  await NotificationService.instance.initialize();
  NotificationBackgroundDI.setup();

  Geolocator.requestPermission();

  FlutterError.onError = (details) {
    debugPrint("Erro no Flutter (Skia): ${details.exception}");
  };

  runApp(
    ModularApp(
      module: AppModule(),
      child: const AppWidget(),
    ),
  );
}