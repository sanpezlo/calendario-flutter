import 'package:calendario_flutter/components/text_fields/custom_text_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class EmailTextField extends StatelessWidget {
  final double? width, height;
  final TextEditingController controller;

  const EmailTextField({
    super.key,
    required this.controller,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: "Correo electrónico",
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingrese su correo electrónico';
        }

        if (!EmailValidator.validate(value)) {
          return 'El correo electrónico no es válido';
        }

        return null;
      },
      width: width,
      height: height,
      controller: controller,
      keyboardType: TextInputType.emailAddress,
    );
  }
}
