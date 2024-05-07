import 'package:calendario_flutter/components/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final Icon? icon;
  final Color? color;
  final Color? textColor;

  const CustomButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.icon,
      this.color,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon!,
        label: Text(text),
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(color ?? AppColor.primary),
          foregroundColor:
              MaterialStateProperty.all<Color>(textColor ?? AppColor.white),
          textStyle: MaterialStateProperty.all<TextStyle>(
            const TextStyle(
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(color ?? AppColor.primary),
        foregroundColor:
            MaterialStateProperty.all<Color>(textColor ?? AppColor.white),
        textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
          ),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      child: Text(text),
    );
  }
}
