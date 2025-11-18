import 'package:intl/intl.dart';
import 'package:smart_solutions/constants/services.dart';

class CurrencyUtils {
  static String formatIndianCurrency(dynamic amount) {
    print("format currency is $amount");
    if (amount == null || amount == 'N/A') return 'N/A';

    try {
      // Remove commas if the amount is a string
      if (amount is String) {
        amount = amount.replaceAll(',', ''); // Remove commas
      }

      double numericAmount =
          amount is String ? double.parse(amount) : amount.toDouble();

      return NumberFormat.currency(
        locale: 'en_IN',
        symbol: '₹',
        decimalDigits: 0,
      ).format(numericAmount);
    } catch (e) {
      logOutput("error occurred while formatting currency: $e");
      return '';
    }
  }

  static String formatAmount(String amount) {
    final f = NumberFormat.decimalPattern('hi_IN');
    final numValue = num.tryParse(amount) ?? 0;
    return f.format(numValue);
  }
}
