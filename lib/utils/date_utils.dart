import 'package:intl/intl.dart';

String formatDate(DateTime? date) {
  if (date == null) return '';
  return DateFormat('MMMM d, y').format(date);
}

String today() {
  final d = DateTime.now();
  final months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
  return "${d.day} ${months[d.month-1]}, ${d.year}";
}