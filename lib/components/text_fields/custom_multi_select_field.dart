import 'package:calendario_flutter/components/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class CustomMultiSelectField extends StatelessWidget {
  final List<MultiSelectItem<dynamic>> items;
  final void Function(List<dynamic>) onConfirm;
  final String title;
  final String buttonText;
  final String searchHint;
  final String? Function(List<dynamic>?)? validator;
  final List<dynamic> initialValue;

  const CustomMultiSelectField({
    super.key,
    required this.items,
    required this.onConfirm,
    required this.title,
    required this.buttonText,
    required this.searchHint,
    this.validator,
    this.initialValue = const [],
  });

  @override
  Widget build(BuildContext context) {
    return MultiSelectDialogField(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1,
        ),
      ),
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onConfirm: onConfirm,
      initialValue: initialValue,
      cancelText: const Text("Cancelar"),
      confirmText: const Text("Confirmar"),
      title: Text(title),
      buttonIcon: Icon(
        Icons.arrow_drop_down,
        color: AppColor.text,
      ),
      searchable: true,
      searchHint: searchHint,
      buttonText: Text(
        buttonText,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      items: items,
      chipDisplay: MultiSelectChipDisplay(
        chipColor: AppColor.secondary,
        textStyle: TextStyle(
          color: AppColor.white,
        ),
      ),
    );
  }
}
