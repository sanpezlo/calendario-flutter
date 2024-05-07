import 'package:calendario_flutter/components/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final Function() onPressed;
  final String title;
  final Color? color;

  const CustomTextButton(
      {super.key, required this.onPressed, required this.title, this.color});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(AppColor.transparent),
          foregroundColor:
              MaterialStateProperty.all<Color>(color ?? AppColor.text),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
          ),
        ));
  }
}
