import 'package:flutter/material.dart';

class CustomRichText extends StatelessWidget {
  final String title, subtitle;
  final TextStyle subtitleTextStyle;
  final VoidCallback onTab;
  final Color? color;

  const CustomRichText({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTab,
    required this.subtitleTextStyle,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: RichText(
        text: TextSpan(
          text: title,
          style: TextStyle(
              color: color ?? Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: 'Inter'),
          children: <TextSpan>[
            TextSpan(
              text: subtitle,
              style: subtitleTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
