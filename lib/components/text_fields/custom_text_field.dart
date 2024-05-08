import 'package:calendario_flutter/components/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final Widget? prefixIcon, suffixIcon;
  final double? width, height;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final bool enabled;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final int? maxLines;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.width,
    this.height,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onTap,
    this.onChanged,
    this.maxLines,
    this.obscureText = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        maxLines: maxLines,
        onChanged: onChanged,
        onTap: onTap,
        obscureText: obscureText,
        controller: controller,
        keyboardType: keyboardType,
        enabled: enabled,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColor.text,
        ),
        cursorColor: AppColor.primary,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.primary, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          fillColor: AppColor.background,
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          prefixIcon: prefixIcon,
          prefixIconColor: AppColor.text,
          suffixIcon: suffixIcon,
          suffixIconColor: AppColor.text,
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColor.grey,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}
