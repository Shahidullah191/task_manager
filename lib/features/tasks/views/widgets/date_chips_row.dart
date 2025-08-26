import 'package:flutter/material.dart';
import 'package:razinsoft_task/app_theme.dart';

class DateChipsRow extends StatefulWidget {
  const DateChipsRow({super.key});

  @override
  State<DateChipsRow> createState() => _DateChipsRowState();
}

class _DateChipsRowState extends State<DateChipsRow> {
  int selected = 3;

  @override
  Widget build(BuildContext context) {
    final days = List.generate(7, (i) => DateTime.now().subtract(Duration(days: 3 - i)));
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (_, i) {
          final d = days[i];
          final isSel = i == selected;
          return Container(
            width: 90,
            decoration: BoxDecoration(
              color: isSel ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0,6))],
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(['Fri','Sat','Sun','Mon','Tue','Wed','Thu'][d.weekday % 7],
                    style: TextStyle(color: isSel ? Colors.white : AppColors.textMuted, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text('${d.day}', style: TextStyle(color: isSel ? Colors.white : AppColors.text, fontSize: 22, fontWeight: FontWeight.w700)),
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemCount: days.length,
      ),
    );
  }
}
