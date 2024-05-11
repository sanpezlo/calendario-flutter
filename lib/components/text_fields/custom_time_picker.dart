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
      initialTime: initialTime ?? material.TimeOfDay.now(),
      initialEntryMode: material.TimePickerEntryMode.input,
    );
  }
}
