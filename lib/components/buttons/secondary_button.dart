import 'package:calendario_flutter/components/app_colors.dart';
import 'package:calendario_flutter/components/buttons/custom_button.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Icon? icon;
  final bool? fullWidth;

  const SecondaryButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.icon,
      this.fullWidth = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth! ? double.infinity : null,
      child: CustomButton(
        onPressed: onPressed,
        text: text,
        color: AppColor.secondary,
        textColor: AppColor.white,
        icon: icon,
      ),
    );
  }
}
