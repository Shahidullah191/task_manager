import 'package:flutter/material.dart';
import 'package:task_manager/app_theme.dart';
import 'package:task_manager/utils/dimensions.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool backButton;
  final Function? onBackPressed;
  final Widget? actionWidget;
  final bool automaticallyImplyLeading;
  const CustomAppBar({super.key, required this.title, this.backButton = true, this.onBackPressed, this.actionWidget, this.automaticallyImplyLeading = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.bg,
      surfaceTintColor: AppColors.bg,
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: Dimensions.fontSizeEighteen)),
      actions: actionWidget != null ? [actionWidget!] : [const SizedBox()],
    );
  }

  @override
  Size get preferredSize => const Size(1170, 50);
}