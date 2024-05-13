import 'package:flutter/material.dart' as material;

class CustomTimePicker {
  static Future<material.TimeOfDay?> showTimePicker(
      {required material.BuildContext context,
      material.TimeOfDay? initialTime}) {
    return material.showTimePicker(
      confirmText: "Aceptar",
      cancelText: "Cancelar",
      helpText: "Selecciona una hora de inicio",
      hourLabelText: "Hora",
      minuteLabelText: "Minuto",
      errorInvalidText: "Hora inválida",
      context: context,
      builder: (context, child) {
        return material.Localizations.override(
          context: context,
          locale: const material.Locale('en', 'US'),
          child: child,
        );
      },
      initialTime: initialTime ?? material.TimeOfDay.now(),
      initialEntryMode: material.TimePickerEntryMode.input,
    );
  }
}
