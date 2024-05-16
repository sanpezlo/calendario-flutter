import 'package:calendario_flutter/components/app_colors.dart';
import 'package:calendario_flutter/components/buttons/primary_button.dart';
import 'package:calendario_flutter/components/custom_rich_text.dart';
import 'package:calendario_flutter/components/dialogs/custom_dialog.dart';
import 'package:calendario_flutter/components/divider_row.dart';
import 'package:calendario_flutter/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDialog extends StatelessWidget {
  final EventModel eventModel;

  const EventDialog({super.key, required this.eventModel});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: eventModel.title,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(eventModel.description),
          const SizedBox(height: 16),
          const DividerRow(),
          const SizedBox(height: 16),
          CustomRichText(
            title: 'Fecha y hora: ',
            color: AppColor.primary,
            subtitle: DateFormat("dd/MM/yyyy h:mm a").format(eventModel.date),
            onTab: () {},
            subtitleTextStyle: TextStyle(
              color: AppColor.text,
            ),
          ),
          const SizedBox(height: 4),
          CustomRichText(
            title: 'Hora de finalización: ',
            color: AppColor.primary,
            subtitle: DateFormat("h:mm a").format(
              DateTime(
                  0, 0, 0, eventModel.endTime.hour, eventModel.endTime.minute),
            ),
            onTab: () {},
            subtitleTextStyle: TextStyle(
              color: AppColor.text,
            ),
          ),
        ],
      ),
      actions: [
        Expanded(
          child: PrimaryButton(
            onPressed: () => Navigator.pop(context),
            text: 'Aceptar',
          ),
        ),
      ],
    );
  }

  static void show(
      {required BuildContext context, required EventModel eventModel}) {
    showDialog(
      context: context,
      builder: (context) => EventDialog(
        eventModel: eventModel,
      ),
    );
  }
}
