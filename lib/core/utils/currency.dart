import 'package:intl/intl.dart';

class CurrencyFormat {
  static String convertToIdr(dynamic number) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return currencyFormatter.format(number);
  }

  static String formatNumber(String input) {
    int number = int.parse(input);

    final formatter = NumberFormat('#,##0', 'en_US');

    return formatter.format(number).replaceAll(',', '.');
  }
}
