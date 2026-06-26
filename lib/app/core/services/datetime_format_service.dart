import 'package:intl/intl.dart';

class DateTimeFormatService {
  static final _dayMonth = DateFormat('dd/MM', 'pt_BR');
  static final _hourMinute = DateFormat('HH:mm', 'pt_BR');
  static final _fullDate = DateFormat("dd 'de' MMMM 'de' yyyy", 'pt_BR');
  static final _weekdayDate = DateFormat("EEEE, dd/MM", 'pt_BR');

  static String formatDayMonth(DateTime dt) => _dayMonth.format(dt);

  static String formatHourMinute(DateTime dt) => _hourMinute.format(dt);

  static String formatFullDate(DateTime dt) => _fullDate.format(dt);

  static String formatWeekdayDate(DateTime dt) => _weekdayDate.format(dt);

  /// Returns "dd/MM • HH:mm-HH:mm"
  static String formatRange(DateTime start, DateTime end) =>
      '${_dayMonth.format(start)} • ${_hourMinute.format(start)}-${_hourMinute.format(end)}';

  static DateTime? tryParse(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  /// Parses "9:00" or "09:00" leniently.
  static DateTime parseHourMinute(String value) {
    final parts = value.split(':');
    if (parts.length != 2) throw FormatException('Invalid time: $value');
    final h = int.tryParse(parts[0].trim());
    final m = int.tryParse(parts[1].trim());
    if (h == null || m == null) throw FormatException('Invalid time: $value');
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, h, m);
  }
}
