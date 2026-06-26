import 'package:flutter/material.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/extension/size_screen_extension.dart';

class MundiAppBar extends StatelessWidget {
  final String imagePath;
  final Color buttonColor;
  final Color iconButtonColor;
  final bool showButton;
  final VoidCallback? onButtonPress;
  const MundiAppBar({super.key, this.showButton = false, this.onButtonPress})
      : imagePath = 'assets/images/logo.png',
        buttonColor = const Color.fromRGBO(64, 182, 75, 1),
        iconButtonColor = Colors.white;

  const MundiAppBar.darkTheme(
      {super.key, this.showButton = false, this.onButtonPress})
      : imagePath = 'assets/images/dark_logo.png',
        buttonColor = Colors.white,
        iconButtonColor = const Color.fromRGBO(64, 182, 75, 1);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Visibility(
          visible: showButton,
          child: SizedBox(
            width: 40,
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.grey.withValues(alpha: .2),
                backgroundColor: buttonColor,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onButtonPress,
              child: Center(
                child: Icon(
                  Icons.arrow_back,
                  color: iconButtonColor,
                ),
              ),
            ),
          ),
        ),
        Image.asset(
          imagePath,
          width: .4743.sw,
        ),
        Visibility(
          visible: showButton,
          child: const SizedBox(
            width: 40,
          ),
        ),
      ],
    );
  }
}