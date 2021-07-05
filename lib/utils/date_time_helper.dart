import 'package:intl/intl.dart';

class DateTimeHelper {
  static String formatDate(DateTime data) {
    final dateFormat = DateFormat('dd-MMM-yy');
    final dataDate = dateFormat.format(data);
    return dataDate;
  }
  static String formatDateSort(String data) {
    try {
      var inputFormat = DateFormat('dd-MMM-yy');
      var date1 = inputFormat.parse(data);

      var outputFormat = DateFormat("yyyy-MM-dd");
      var date2 = outputFormat.parse("$date1");

      return date2.toString();
    }catch(e) {
      return data;
    }
  }
}