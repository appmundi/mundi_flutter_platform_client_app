import 'package:flutter/material.dart';

class AppBreakpoints {
  static const double small = 360;
  static const double medium = 400;
  static const double large = 600;
}

extension ScreenSizeContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  bool get isSmallScreen => screenWidth <= AppBreakpoints.small;
  bool get isMediumScreen =>
      screenWidth > AppBreakpoints.small && screenWidth <= AppBreakpoints.medium;
  bool get isLargeScreen => screenWidth >= AppBreakpoints.large;
}
