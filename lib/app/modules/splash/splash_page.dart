import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mundi_flutter_platform_client_app/app/core/deep_link/deep_link_service.dart';
import 'package:mundi_flutter_platform_client_app/app/core/session/session_service.dart';
import 'package:mundi_flutter_platform_client_app/app/core/storage/local_storage.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/extension/size_screen_extension.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';
import 'package:themed/themed.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    final session = SessionService(Modular.get<LocalStorage>());
    await session.bootstrap();
    final loggedIn = await session.isLoggedIn();
    if (!mounted) return;
    if (loggedIn) {
      Modular.to.navigate('/home', arguments: {'currentPage': 0});
    } else {
      Modular.to.navigate('/home');
    }
    DeepLinkService().notifyAppReady();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ChangeColors(
            brightness: -.1,
            saturation: .05,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 20,
              sigmaY: 20,
              tileMode: TileMode.mirror,
            ),
            child: Container(
              width: 1.sw,
              height: 1.sh,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  //tileMode: TileMode.clamp,
                  stops: const [.063, .6, .4, .7, .9],
                  colors: [
                    const Color.fromARGB(255, 4, 10, 31),
                    const Color.fromARGB(255, 4, 10, 31).withValues(alpha: .5),
                    const Color.fromARGB(255, 4, 10, 31).withValues(alpha: .5),
                    const Color.fromARGB(255, 4, 10, 31).withValues(alpha: .86),
                    const Color.fromARGB(255, 4, 10, 31)
                  ],
                ),
              ),
            ),
          ),
          SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 255,
                ),
                Text(
                  "O mundo na palma da sua mão.",
                  textAlign: TextAlign.center,
                  style: context.textStyles.textRegular.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 14.33,
                    letterSpacing: .1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
