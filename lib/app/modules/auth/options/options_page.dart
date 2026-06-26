import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/extension/size_screen_extension.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/app_button.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/app_button_outline.dart';
import 'package:themed/themed.dart';

class OptionsPage extends StatefulWidget {
  const OptionsPage({Key? key}) : super(key: key);

  @override
  State<OptionsPage> createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
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
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  //tileMode: TileMode.clamp,
                  stops: const [.063, .6, .4, .7, .9],
                  colors: [
                    const Color.fromARGB(255, 4, 10, 31).withValues(alpha: .1),
                    const Color.fromARGB(255, 4, 10, 31).withValues(alpha: .1),
                    const Color.fromARGB(255, 4, 10, 31).withValues(alpha: .14),
                    const Color.fromARGB(255, 4, 10, 31).withValues(alpha: .94),
                    const Color.fromARGB(255, 4, 10, 31)
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 1.statusBar,
            child: GestureDetector(
              onTap: () {
                Modular.to.pop();
              },
              child: Container(
                width: 40,
                height: 30,
                padding: const EdgeInsets.all(5.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_back,
                    size: 20,
                    color: context.colors.decorationPrimary,
                  ),
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
          Positioned(
            left: 0,
            right: 0,
            bottom: 150,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  AppButton(
                    onPressed: () {
                      Modular.to.pushNamed('/auth/register');
                    },
                    text: 'Registre-se aqui',
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  AppButtonOutline(
                    onPressed: () {
                      Modular.to.pushNamed('/auth/login');
                    },
                    text: 'Login',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
