import 'package:flutter/material.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/extension/size_screen_extension.dart';

class DefaultPadding extends StatelessWidget {
  final Widget? child;
  final String bgImagePath;
  const DefaultPadding({super.key, required this.bgImagePath, this.child});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: screenHeight,
          child: Image.asset(bgImagePath, fit: BoxFit.cover),
        ),
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.only(top: 1.statusBar + 28),
            child: child,
          ),
        ),
      ],
    );
  }
}
