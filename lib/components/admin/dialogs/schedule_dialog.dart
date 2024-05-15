import 'package:calendario_flutter/components/app_colors.dart';
import 'package:calendario_flutter/components/buttons/primary_button.dart';
import 'package:calendario_flutter/components/buttons/secondary_button.dart';
import 'package:calendario_flutter/components/dialogs/error_dialog.dart';
import 'package:calendario_flutter/components/dialogs/loading_dialog.dart';
import 'package:calendario_flutter/components/text_fields/custom_dropdown_button.dart';
import 'package:calendario_flutter/components/text_fields/custom_text_field.dart';
import 'package:calendario_flutter/components/text_fields/custom_time_picker.dart';
import 'package:calendario_flutter/models/error_model.dart';
import 'package:calendario_flutter/models/program_model.dart';
import 'package:calendario_flutter/models/schedule_model.dart';
import 'package:calendario_flutter/models/subject_model.dart';
import 'package:calendario_flutter/services/firebase_firestore_service.dart';
import 'package:calendario_flutter/services/firebase_messaging_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ScheduleDialog extends StatefulWidget {
  final List<SubjectModel> subjects;
  final List<ProgramModel> programs;

  final ScheduleModel? scheduleModel;
  final bool isDelete;

  const ScheduleDialog(
      {super.key,
      required this.subjects,
      required this.programs,
      this.scheduleModel,
      this.isDelete = false});

  @override
  State<ScheduleDialog> createState() => _ScheduleDialogState();

  static void show({
    required BuildContext context,
    required List<SubjectModel> subjects,
    required List<ProgramModel> programs,
    ScheduleModel? scheduleModel,
    bool isDelete = false,
  }) {
    showDialog(
      context: context,
      builder: (context) => ScheduleDialog(
        subjects: subjects,
        programs: programs,
        scheduleModel: scheduleModel,
        isDelete: isDelete,
      ),
    );
  }
}

class _ScheduleDialogState extends State<ScheduleDialog> {
  final _formKey = GlobalKey<FormState>();

  String? subjectIdController;
  TimeOfDay? startTimeController;
  TimeOfDay? endTimeController;
  String? dayController;
  final classroomController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.scheduleModel != null) {
      subjectIdController = widget.scheduleModel!.subjectId;
      startTimeController = widget.scheduleModel!.startTime;
      endTimeController = widget.scheduleModel!.endTime;
      dayController = widget.scheduleModel!.day.name;
      classroomController.text = widget.scheduleModel!.classroom;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _dialogContent(context),
    );
  }

  Widget _dialogContent(BuildContext context) {
    return Container(
      width: kIsWeb ? 400 : null,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: AppColor.alternative,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_form(context)],
      ),
    );
  }

  Form _form(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            widget.scheduleModel != null
                ? widget.isDelete
                    ? "¿Estás seguro de eliminar este horario?"
                    : "Actualizar Horario"
                : "Crear Horario",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
              color: AppColor.text,
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          widget.isDelete
              ? CustomTextField(
                  maxLines: 2,
                  hintText: "Materia",
                  enabled: false,
                  controller: TextEditingController(
                      text: widget.subjects
                          .where((subjectModel) =>
                              subjectModel.id ==
                              widget.scheduleModel!.subjectId)
                          .map((e) =>
                              "${e.name} - ${widget.programs.where((programModel) => programModel.id == e.programId).map((e) => e.name).firstOrNull ?? "No encontrado"}")
                          .firstOrNull),
                )
              : CustomDropdownButton(
                  isDense: false,
                  hintText: "Materia",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor seleccione una materia";
                    }

                    return null;
                  },
                  value: subjectIdController,
                  items: [
                    for (final subjectModel in widget.subjects)
                      DropdownMenuItem(
                        value: subjectModel.id,
                        child: Text(
                          "${subjectModel.name} - ${widget.programs.where((programModel) => programModel.id == subjectModel.programId).map((e) => e.name).firstOrNull ?? "No encontrado"}",
                        ),
                      )
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      subjectIdController = newValue!;
                    });
                  },
                ),
          const SizedBox(
            height: 16,
          ),
          CustomTextField(
            hintText: "Hora de inicio",
            controller: TextEditingController(
              text: startTimeController != null
                  ? DateFormat("h:mm a").format(
                      DateTime(
                        0,
                        0,
                        0,
                        startTimeController!.hour,
                        startTimeController!.minute,
                      ),
                    )
                  : null,
            ),
            enabled: !widget.isDelete,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Por favor seleccione una hora de inicio";
              }

              if (startTimeController != null &&
                  startTimeController!
                      .isBefore(const TimeOfDay(hour: 7, minute: 0))) {
                return "La hora de inicio no puede ser antes de las 7:00 AM";
              }

              if (startTimeController != null &&
                  startTimeController!
                      .isAfter(const TimeOfDay(hour: 21, minute: 5))) {
                return "La hora de inicio no puede ser después de las 9:05 PM";
              }

              return null;
            },
            onChanged: (_) {
              setState(() {});
            },
            onTap: () async {
              final TimeOfDay? timeOfDay =
                  await CustomTimePicker.showTimePicker(
                      context: context, initialTime: startTimeController);

              if (timeOfDay != null) {
                setState(() {
                  startTimeController = timeOfDay;
                });
                await Future.delayed(Duration.zero, () {
                  setState(() {
                    _formKey.currentState!.validate();
                  });
                });
              }
            },
          ),
          const SizedBox(
            height: 16,
          ),
          CustomTextField(
            hintText: "Hora de fin",
            controller: TextEditingController(
              text: endTimeController != null
                  ? DateFormat("h:mm a").format(
                      DateTime(
                        0,
                        0,
                        0,
                        endTimeController!.hour,
                        endTimeController!.minute,
                      ),
                    )
                  : null,
            ),
            enabled: !widget.isDelete,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Por favor seleccione una hora de fin";
              }

              if (startTimeController != null &&
                  endTimeController != null &&
                  startTimeController!.isAfter(endTimeController!)) {
                return "La hora de fin debe ser después de la hora de inicio";
              }

              if (startTimeController != null &&
                  endTimeController != null &&
                  startTimeController == endTimeController) {
                return "La hora de fin no puede ser igual a la hora de inicio";
              }

              if (endTimeController != null &&
                  endTimeController!
                      .isBefore(const TimeOfDay(hour: 7, minute: 50))) {
                return "La hora de fin no puede ser antes de las 7:50 AM";
              }

              if (endTimeController != null &&
                  endTimeController!
                      .isAfter(const TimeOfDay(hour: 21, minute: 55))) {
                return "La hora de fin no puede ser después de las 9:55 PM";
              }

              return null;
            },
            onChanged: (_) {
              setState(() {});
            },
            onTap: () async {
              final TimeOfDay? timeOfDay =
                  await CustomTimePicker.showTimePicker(
                context: context,
                initialTime: endTimeController,
              );

              if (timeOfDay != null) {
                setState(() {
                  endTimeController = timeOfDay;
                });
                await Future.delayed(Duration.zero, () {
                  setState(() {
                    _formKey.currentState!.validate();
                  });
                });
              }
            },
          ),
          const SizedBox(
            height: 16,
          ),
          widget.isDelete
              ? CustomTextField(
                  hintText: "Día",
                  enabled: false,
                  controller: TextEditingController(
                    text: widget.scheduleModel!.day.format(),
                  ),
                )
              : CustomDropdownButton(
                  hintText: "Día",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor seleccione un día";
                    }

                    return null;
                  },
                  value: dayController,
                  items: [
                    for (final day in Day.values)
                      DropdownMenuItem(
                        value: day.name,
                        child: Text(
                          day.format(),
                        ),
                      )
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      dayController = newValue!;
                    });
                  },
                ),
          const SizedBox(
            height: 16,
          ),
          CustomTextField(
            hintText: "Aula",
            enabled: !widget.isDelete,
            controller: classroomController,
            validator: (name) {
              if (name == null || name.isEmpty) {
                return "Por favor ingrese el aula";
              }

              if (name.length < 3) {
                return "El aula debe tener al menos 3 caracteres";
              }

              return null;
            },
          ),
          const SizedBox(
            height: 16,
          ),
          widget.isDelete
              ? SecondaryButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    LoadingDialog.show(context: context);

                    try {
                      await FirebaseFirestoreService()
                          .deleteSchedule(widget.scheduleModel!.id)
                          .then(
                        (value) {
                          Navigator.pop(context);
                          _formKey.currentState!.reset();
                          Navigator.pop(context);
                        },
                      );
                    } catch (e) {
                      if (context.mounted) {
                        Navigator.pop(context);
                        ErrorDialog.show(
                            context: context,
                            errorModel: e is ErrorModel ? e : null);
                      }
                    }
                  },
                  text: "Eliminar",
                )
              : PrimaryButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    LoadingDialog.show(context: context);

                    try {
                      if (widget.scheduleModel != null) {
                        await FirebaseFirestoreService()
                            .updateSchedule(
                          ScheduleModel(
                            id: widget.scheduleModel!.id,
                            subjectId: subjectIdController!,
                            startTime: startTimeController!,
                            endTime: endTimeController!,
                            day: Day.values.firstWhere(
                                (element) => element.name == dayController),
                            classroom: classroomController.text,
                          ),
                        )
                            .then(
                          (value) {
                            final SubjectModel subjectModel = widget.subjects
                                .where((element) =>
                                    element.id == subjectIdController)
                                .firstOrNull!;

                            FirebaseMessagingService().sendNotification(
                              topic:
                                  "${subjectModel.programId}_${subjectModel.semester}",
                              title:
                                  "Horario Actualizado: ${subjectModel.name}",
                              body:
                                  "El horario de la materia ${subjectModel.name} ha sido actualizado a las ${DateFormat("h:mm a").format(DateTime(0, 0, 0, startTimeController!.hour, startTimeController!.minute))} - ${DateFormat("h:mm a").format(DateTime(0, 0, 0, endTimeController!.hour, endTimeController!.minute))} el día ${Day.values.firstWhere((element) => element.name == dayController).format()} en el aula ${classroomController.text}",
                            );

                            Navigator.pop(context);
                            _formKey.currentState!.reset();
                            Navigator.pop(context);
                          },
                        );
                      } else {
                        await FirebaseFirestoreService()
                            .addSchedule(
                          ScheduleModel(
                            id: const Uuid().v4(),
                            subjectId: subjectIdController!,
                            startTime: startTimeController!,
                            endTime: endTimeController!,
                            day: Day.values.firstWhere(
                                (element) => element.name == dayController),
                            classroom: classroomController.text,
                          ),
                        )
                            .then(
                          (value) {
                            Navigator.pop(context);
                            _formKey.currentState!.reset();
                            Navigator.pop(context);
                          },
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        Navigator.pop(context);
                        ErrorDialog.show(
                            context: context,
                            errorModel: e is ErrorModel ? e : null);
                      }
                    }
                  },
                  text: widget.scheduleModel != null ? "Actualizar" : "Crear",
                ),
        ],
      ),
    );
  }
}
