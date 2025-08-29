import 'package:flutter/material.dart';
import 'package:task_manager/app_theme.dart';
import 'package:task_manager/utils/dimensions.dart';

class DateChipsRow extends StatefulWidget {
  const DateChipsRow({super.key});

  @override
  State<DateChipsRow> createState() => _DateChipsRowState();
}

class _DateChipsRowState extends State<DateChipsRow> {
  late int selected;
  late List<DateTime> days;
  final ScrollController _scrollController = ScrollController();

  final double unselectedSize = 50;
  final double selectedSize = 65;
  final double spacing = 10;

  @override
  void initState() {
    super.initState();

    // Generate 7 days: 3 before, today, 3 after
    days = List.generate(7, (i) => DateTime.now().subtract(Duration(days: 3 - i)));

    // Find today's index
    selected = days.indexWhere((d) => d.year == DateTime.now().year && d.month == DateTime.now().month && d.day == DateTime.now().day);

    // Center today after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerSelected();
    });
  }

  void _centerSelected() {
    if (!_scrollController.hasClients) return;

    // Horizontal padding of ListView
    const double horizontalPadding = 10;

    // 1. Start with the ListView’s left padding
    double offset = horizontalPadding;

    // 2. Add widths + spacings for all items BEFORE selected
    offset += selected * (unselectedSize + spacing);

    // 3. Add half of the selected item width
    offset += selectedSize / 2;

    // 4. Subtract half the screen width to center
    final screenWidth = MediaQuery.of(context).size.width;
    offset -= screenWidth / 2;

    // 5. Clamp so it doesn’t overshoot
    offset = offset.clamp(
      _scrollController.position.minScrollExtent,
      _scrollController.position.maxScrollExtent,
    );

    _scrollController.jumpTo(offset);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
      color: AppColors.card,
      padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeFifteen),
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (_, i) {
          final d = days[i];
          final isSel = i == selected;
          final size = isSel ? selectedSize : unselectedSize;

          return Container(
            width: size,
            height: size,
            margin: EdgeInsets.only(
              top: isSel ? 0 : 7.5,
              bottom: isSel ? 0 : 7.5,
            ),
            decoration: BoxDecoration(
              color: isSel ? AppColors.primary : AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Dimensions.radiusFifteen),
              gradient: isSel ? LinearGradient(
                colors: [const Color(0xff886CED), AppColors.primary],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ) : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ['Fri', 'Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu'][d.weekday % 7],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSel ? Colors.white : AppColors.primary,
                    fontSize: Dimensions.fontSizeTen,
                  ),
                ),
                Text(
                  '${d.day}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: isSel ? Colors.white : AppColors.primary, fontSize: isSel ? Dimensions.fontSizeSixteen : Dimensions.fontSizeFourteen,
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => SizedBox(width: spacing),
        itemCount: days.length,
      ),
    );
  }
}


