import 'package:flutter/material.dart';

class ColorsApp {
  static ColorsApp? _instance;

  ColorsApp._();

  static ColorsApp get i {
    _instance ??= ColorsApp._();
    return _instance!;
  }

  Color get primary => const Color(0xff060E31);

  Color get white => const Color(0xffF3F4F6);

  Color get secondary => const Color(0xff40B64B);
  Color get secondary4 => const Color(0xffF3F4F6);

  Color get grey => Colors.grey.shade500;

  Color get darkGrey => const Color(0xff353839);

  Color get decorationPrimary => const Color(0xff40B64B);

  // Extended palette
  Color get mutedText => const Color(0xFFA4A4A4);
  Color get cardBackground => const Color(0xFFF2F2F2);
  Color get surface => Colors.white;
  Color get border => const Color(0xFFE0E0E0);
  Color get danger => const Color(0xFFD32F2F);
  Color get warning => const Color(0xFFF57C00);
  Color get success => secondary;
  Color get textPrimary => const Color(0xFF212121);
  Color get textSecondary => const Color(0xFF3A3A3A);
  Color get atHomeBadgeBg => const Color(0xFFE8F5E9);
  Color get atHomeBadgeFg => const Color(0xFF1B5E20);
  Color get atVenueBadgeBg => const Color(0xFFE3F2FD);
  Color get atVenueBadgeFg => const Color(0xFF0D47A1);
}

extension ColorsAppExtension on BuildContext {
  ColorsApp get colors => ColorsApp.i;
}
