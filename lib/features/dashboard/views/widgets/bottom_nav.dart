import 'package:flutter/material.dart';
import 'package:razinsoft_task/app_theme.dart';
import 'package:razinsoft_task/utils/dimensions.dart';

class FancyBottomBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  const FancyBottomBar({super.key, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(Dimensions.paddingSizeFifteen),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(Dimensions.radiusForty),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0,8))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(child: _item(Icons.home_rounded, 0)),
            Expanded(child: _item(Icons.assignment_rounded, 1)),
            Expanded(child: _item(Icons.calendar_month_rounded, 2)),
          ],
        ),
      ),
    );
  }

  Widget _item(IconData icon, int i) {
    final selected = index == i;
    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radiusForty),
      onTap: () => onTap(i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 12),
        margin: EdgeInsets.all(Dimensions.marginSizeFive),
        decoration: BoxDecoration(
          color: selected ? AppColors.chipBg : Colors.transparent,
          borderRadius: BorderRadius.circular(Dimensions.radiusForty),
        ),
        child: Icon(icon, color: selected ? AppColors.primary : AppColors.gray),
      ),
    );
  }
}
