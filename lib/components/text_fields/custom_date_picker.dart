import 'package:flutter/material.dart' as material;

class CustomDatePicker {
  static Future<DateTime?> showDatePicker(
      {required material.BuildContext context,
      DateTime? initialDate,
      DateTime? firstDate,
      DateTime? lastDate}) {
    return material.showDatePicker(
      locale: const material.Locale("es", "CO"),
      helpText: "Fecha y hora",
      cancelText: "Cancelar",
      confirmText: "Aceptar",
      errorFormatText: "Formato de fecha inválido",
      errorInvalidText: "Fecha inválida",
      fieldLabelText: "Fecha",
      fieldHintText: "Día/Mes/Año",
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime.now(),
      lastDate: lastDate ?? DateTime.now().add(const Duration(days: 365)),
    );
  }
}
