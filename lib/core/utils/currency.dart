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

  static String convertToWIB(String inputDate) {
    DateTime utcDate = DateTime.parse(inputDate).toUtc();

    DateTime wibDate = utcDate.add(const Duration(hours: 7));

    DateFormat formatter = DateFormat('dd MMMM yyyy HH:mm', 'id_ID');

    String formattedDate = formatter.format(wibDate);

    return '$formattedDate WIB';
  }
}
