import 'package:flutter/material.dart';
import 'package:razinsoft_task/app_theme.dart';
import 'package:razinsoft_task/utils/dimensions.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool backButton;
  final Function? onBackPressed;
  final Widget? actionWidget;
  const CustomAppBar({super.key, required this.title, this.backButton = true, this.onBackPressed, this.actionWidget});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.bg,
      surfaceTintColor: AppColors.bg,
      title: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: Dimensions.fontSizeEighteen)),
      actions: actionWidget != null ? [actionWidget!] : [const SizedBox()],
    );
  }

  @override
  Size get preferredSize => const Size(1170, 50);
}