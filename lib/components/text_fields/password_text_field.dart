import 'package:calendario_flutter/components/text_fields/custom_text_field.dart';
import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final double? width, height;
  final TextEditingController controller;

  const PasswordTextField({
    super.key,
    required this.controller,
    this.width,
    this.height,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      maxLines: 1,
      hintText: "Contraseña",
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingrese su contraseña';
        }

        if (value.length < 6) {
          return 'La contraseña debe tener al menos 6 caracteres';
        }

        return null;
      },
      width: widget.width,
      height: widget.height,
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: TextInputType.visiblePassword,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          size: 24,
        ),
        onPressed: () {
          setState(
            () {
              _obscureText = !_obscureText;
            },
          );
        },
      ),
    );
  }
}
