import 'package:calendario_flutter/components/app_colors.dart';
import 'package:calendario_flutter/components/buttons/primary_button.dart';
import 'package:calendario_flutter/components/custom_rich_text.dart';
import 'package:calendario_flutter/components/dialogs/custom_dialog.dart';
import 'package:calendario_flutter/models/professor_model.dart';
import 'package:calendario_flutter/models/schedule_model.dart';
import 'package:calendario_flutter/models/subject_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleDialog extends StatelessWidget {
  final ScheduleModel scheduleModel;
  final SubjectModel subjectModel;
  final ProfessorModel professorModel;

  const ScheduleDialog(
      {super.key,
      required this.scheduleModel,
      required this.subjectModel,
      required this.professorModel});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: subjectModel.name,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomRichText(
            title: 'Profesor: ',
            color: AppColor.primary,
            subtitle: professorModel.name,
            onTab: () {},
            subtitleTextStyle: TextStyle(
              color: AppColor.text,
            ),
          ),
          const SizedBox(height: 4),
          CustomRichText(
            title: 'Día: ',
            color: AppColor.primary,
            subtitle: scheduleModel.day.format(),
            onTab: () {},
            subtitleTextStyle: TextStyle(
              color: AppColor.text,
            ),
          ),
          const SizedBox(height: 4),
          CustomRichText(
            title: 'Hora de inicio: ',
            color: AppColor.primary,
            subtitle: DateFormat("h:mm a").format(
              DateTime(0, 0, 0, scheduleModel.startTime.hour,
                  scheduleModel.startTime.minute),
            ),
            onTab: () {},
            subtitleTextStyle: TextStyle(
              color: AppColor.text,
            ),
          ),
          const SizedBox(height: 4),
          CustomRichText(
            title: 'Hora de fin: ',
            color: AppColor.primary,
            subtitle: DateFormat("h:mm a").format(
              DateTime(0, 0, 0, scheduleModel.endTime.hour,
                  scheduleModel.endTime.minute),
            ),
            onTab: () {},
            subtitleTextStyle: TextStyle(
              color: AppColor.text,
            ),
          ),
          const SizedBox(height: 4),
          CustomRichText(
            title: 'Salón: ',
            color: AppColor.primary,
            subtitle: scheduleModel.classroom,
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
      {required BuildContext context,
      required ScheduleModel scheduleModel,
      required SubjectModel subjectModel,
      required ProfessorModel professorModel}) {
    showDialog(
      context: context,
      builder: (context) => ScheduleDialog(
        scheduleModel: scheduleModel,
        subjectModel: subjectModel,
        professorModel: professorModel,
      ),
    );
  }
}
