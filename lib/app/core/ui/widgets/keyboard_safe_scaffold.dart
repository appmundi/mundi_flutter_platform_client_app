import 'package:flutter/material.dart';

/// Scaffold wrapper that keeps content visible when the keyboard opens.
/// Pass [stickyBottom] for CTAs that should float above the keyboard.
class KeyboardSafeScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? stickyBottom;
  final Color? backgroundColor;
  final Widget? floatingActionButton;

  const KeyboardSafeScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.stickyBottom,
    this.backgroundColor,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: Column(
        children: [
          Expanded(child: body),
          if (stickyBottom != null)
            AnimatedPadding(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(bottom: viewInsets.bottom),
              child: stickyBottom!,
            ),
        ],
      ),
    );
  }
}
