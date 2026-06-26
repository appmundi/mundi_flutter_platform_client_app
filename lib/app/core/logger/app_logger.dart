import 'package:flutter/foundation.dart';

class Log {
  static void d(String tag, [Object? message]) {
    if (!kReleaseMode) debugPrint('[$tag] DEBUG: $message');
  }

  static void i(String tag, [Object? message]) {
    if (!kReleaseMode) debugPrint('[$tag] INFO: $message');
  }

  static void w(String tag, [Object? message]) {
    if (!kReleaseMode) debugPrint('[$tag] WARN: $message');
  }

  static void e(String tag, [Object? message]) {
    if (!kReleaseMode) debugPrint('[$tag] ERROR: $message');
  }
}
