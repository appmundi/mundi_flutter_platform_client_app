extension DateTimeExtension on DateTime {
  String get appTimeFormat {
    // Garante que os minutos sempre tenham 2 dígitos
    final minuteStr = minute.toString().padLeft(2, '0');
    return "${hour}h$minuteStr";
  }

  DateTime fillHourAndMinute(int hour, int minute) {
    return DateTime(year, month, day, hour, minute);
  }
}

extension ApiDateStringExtension on String {
  DateTime get apiDateMinusThreeHours {
    return DateTime.parse(this).subtract(const Duration(hours: 3));
  }
}
