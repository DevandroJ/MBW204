import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ConnexistHelper {
  static String formatCurrency(double number) {
    final NumberFormat _fmt = NumberFormat.currency(locale: 'id', symbol: 'Rp ');
    String s = _fmt.format(number);
    String _format = s.toString().replaceAll(RegExp(r"([,]*00)(?!.*\d)"), "");
    return _format;
  }
  static String formatDate(DateTime dateTime) {
    initializeDateFormatting("id");
    return DateFormat.yMMMMEEEEd("id").format(dateTime);
  }
}
