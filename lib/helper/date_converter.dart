import 'package:intl/intl.dart';

class DateConverter {

  static String formatDate(DateTime date) {
    return DateFormat('MMMM d, y').format(date);
  }

  static String today() {
    final d = DateTime.now();
    final months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
    return "${d.day} ${months[d.month-1]}, ${d.year}";
  }

}