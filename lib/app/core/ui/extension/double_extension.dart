import 'package:intl/intl.dart';

extension DoubleExtension on double {
  String get currency {
    final currencyFormat = NumberFormat.simpleCurrency();
    return "R\$ ${currencyFormat.format(this).replaceAll("\$", "").replaceAll(".", ",")}";
  }
}