import 'package:flutter/material.dart';
import 'package:razinsoft_task/app_theme.dart';
import 'package:razinsoft_task/utils/dimensions.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final int maxLines;
  final bool isPassword;
  final Function? onTap;
  final Function? onChanged;
  final Function? onSubmit;
  final bool isMarginEnable;
  final String? Function(String? value)? validator;
  final AutovalidateMode? autoValidateMode;
  final String? titleText;
  final bool showTitle;
  final bool isRequired;
  final String labelText;

  const CustomTextField({
    super.key,
    this.isPassword = false,
    this.hintText = '',
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.next,
    this.maxLines = 1,
    this.onTap,
    this.onChanged,
    this.onSubmit,
    this.isMarginEnable = false,
    this.validator,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.titleText,
    this.showTitle = true,
    this.isRequired = false,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Text(labelText, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: Dimensions.fontSizeFourteen)),
      ),

      TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: inputType,
        textInputAction: inputAction,
        maxLines: maxLines,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: Dimensions.fontSizeTwelve),
        decoration: InputDecoration(
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: Dimensions.fontSizeTwelve),
          hintText: hintText,
          contentPadding: const EdgeInsets.all(Dimensions.paddingSizeFifteen),
          focusedBorder: border(),
          enabledBorder: border(),
          disabledBorder: border(),
          focusedErrorBorder: border(),
          errorBorder: border(),
        ),
        onTap: onTap as void Function()?,
        onSaved: (text) => nextFocus != null ? FocusScope.of(context).requestFocus(nextFocus) : onSubmit != null ? onSubmit!(text) : null,
        onChanged: onChanged as void Function(String)?,
        validator: validator,
        autovalidateMode: autoValidateMode,
      ),

    ]);
  }

  OutlineInputBorder border () {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusTwenty)),
      borderSide: BorderSide(width: 1, color: AppColors.bg),
    );
  }
}
