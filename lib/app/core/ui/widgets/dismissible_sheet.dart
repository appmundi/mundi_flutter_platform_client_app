import 'package:flutter/material.dart';

/// Bottom-sheet barrier that dismisses on background tap but NOT on content tap.
class DismissibleSheet extends StatelessWidget {
  final VoidCallback onBarrierTap;
  final Widget child;

  const DismissibleSheet({
    super.key,
    required this.onBarrierTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onBarrierTap,
          ),
        ),
        Align(alignment: Alignment.bottomCenter, child: child),
      ],
    );
  }
}
