import 'package:calendario_flutter/components/app_colors.dart';
import 'package:calendario_flutter/components/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';

class PrimaryTextButton extends StatelessWidget {
  final Function() onPressed;
  final String title;

  const PrimaryTextButton(
      {super.key, required this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return CustomTextButton(
      onPressed: onPressed,
      title: title,
      color: AppColor.primary,
    );
  }
}
