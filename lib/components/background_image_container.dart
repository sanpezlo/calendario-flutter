import 'package:calendario_flutter/components/app_colors.dart';
import 'package:flutter/material.dart';

class BackgroundImageContainer extends StatelessWidget {
  const BackgroundImageContainer({
    super.key,
    required this.child,
  });
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        image: const DecorationImage(
          image: AssetImage('assets/logo_negro_unicesmag.png'),
          scale: 1.5,
        ),
      ),
      child: child,
    );
  }
}
