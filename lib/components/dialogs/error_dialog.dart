import 'package:calendario_flutter/components/dialogs/custom_dialog.dart';
import 'package:calendario_flutter/components/buttons/secondary_button.dart';
import 'package:calendario_flutter/models/error_model.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final ErrorModel errorModel;
  final void Function()? onPress;

  const ErrorDialog({super.key, required this.errorModel, this.onPress});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: "Error",
      body: errorModel.message,
      actions: [
        Expanded(
          child: SecondaryButton(
            onPressed: onPress ?? () => Navigator.pop(context),
            text: 'Aceptar',
          ),
        ),
      ],
    );
  }

  static void show({required BuildContext context, ErrorModel? errorModel}) {
    showDialog(
      context: context,
      builder: (context) => ErrorDialog(
        errorModel: errorModel ?? ErrorModel(),
      ),
    );
  }
}
