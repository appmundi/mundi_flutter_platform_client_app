import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mundi_flutter_platform_client_app/app/core/config/firebase/firebase_options.dart';
import 'package:mundi_flutter_platform_client_app/app/core/helpers/environments.dart';


class ApplicationConfig {
  Future<void> configure() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await Environments.load();
  }
}