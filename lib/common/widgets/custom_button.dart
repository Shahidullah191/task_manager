import 'package:flutter/material.dart';
import 'package:task_manager/app_theme.dart';
import 'package:task_manager/utils/dimensions.dart';

class CustomButton extends StatelessWidget {
  final double? height;
  final double? width;
  final String text;
  final Color? color;
  final Color? textColor;
  final Function()? onTap;
  final bool isBorderEnable;
  final bool isLoading;
  const CustomButton({super.key, this.height = 50, this.width, required this.text, this.color, this.textColor,
    this.onTap, this.isBorderEnable = true, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: color ?? AppColors.primary,
          borderRadius: BorderRadius.circular(Dimensions.radiusForty),
        ),
        child: Center(
          child: isLoading ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              height: 15, width: 15,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).cardColor),
                strokeWidth: 2,
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeTen),

            Text('Loading', style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: Dimensions.fontSizeFourteen, color: textColor ?? AppColors.card)),
          ]) : Text(text, style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: Dimensions.fontSizeFourteen, color: textColor ?? AppColors.card)),
        ),
      ),
    );
  }
}