import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mundi_flutter_platform_client_app/app/app_module.dart';
import 'package:mundi_flutter_platform_client_app/app/app_widget.dart';
import 'package:mundi_flutter_platform_client_app/app/core/config/application_config.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  await ApplicationConfig().configure();

  Geolocator.requestPermission();

  tz.initializeTimeZones();

  tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));

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