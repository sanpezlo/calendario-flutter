import 'package:calendario_flutter/components/app_colors.dart';
import 'package:flutter/material.dart';

class CustomDropdownButton<T> extends StatelessWidget {
  final String hintText;
  final void Function(T?)? onChanged;
  final List<DropdownMenuItem<T>>? items;
  final T? value;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(dynamic)? validator;
  final bool isDense;

  const CustomDropdownButton(
      {super.key,
      required this.hintText,
      required this.onChanged,
      required this.items,
      required this.value,
      this.prefixIcon,
      this.suffixIcon,
      this.validator,
      this.isDense = true});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
        isExpanded: true,
        isDense: isDense,
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
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColor.text,
        ),
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        value: value,
        items: items,
        onChanged: onChanged);
  }
}
