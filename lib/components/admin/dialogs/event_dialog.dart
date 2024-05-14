import 'package:calendario_flutter/components/app_colors.dart';
import 'package:calendario_flutter/components/buttons/primary_button.dart';
import 'package:calendario_flutter/components/buttons/secondary_button.dart';
import 'package:calendario_flutter/components/dialogs/error_dialog.dart';
import 'package:calendario_flutter/components/dialogs/loading_dialog.dart';
import 'package:calendario_flutter/components/text_fields/custom_date_picker.dart';
import 'package:calendario_flutter/components/text_fields/custom_multi_select_field.dart';
import 'package:calendario_flutter/components/text_fields/custom_text_field.dart';
import 'package:calendario_flutter/components/text_fields/custom_time_picker.dart';
import 'package:calendario_flutter/models/error_model.dart';
import 'package:calendario_flutter/models/event_model.dart';
import 'package:calendario_flutter/models/program_model.dart';
import 'package:calendario_flutter/models/schedule_model.dart';
import 'package:calendario_flutter/services/firebase_firestore_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class EventDialog extends StatefulWidget {
  final List<ProgramModel> programs;

  final EventModel? eventModel;
  final bool isDelete;

  const EventDialog(
      {super.key,
      required this.programs,
      this.eventModel,
      this.isDelete = false});

  @override
  State<EventDialog> createState() => _EventDialogState();

  static void show({
    required BuildContext context,
    required List<ProgramModel> programs,
    EventModel? eventModel,
    bool isDelete = false,
  }) {
    showDialog(
      context: context,
      builder: (context) => EventDialog(
        programs: programs,
        eventModel: eventModel,
        isDelete: isDelete,
      ),
    );
  }
}

class _EventDialogState extends State<EventDialog> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  DateTime? dateController;
  TimeOfDay? endTimeController;
  List<String> programIdsController = [];

  @override
  void initState() {
    super.initState();

    if (widget.eventModel != null) {
      titleController.text = widget.eventModel!.title;
      descriptionController.text = widget.eventModel!.description;
      dateController = widget.eventModel!.date;
      endTimeController = widget.eventModel!.endTime;
      programIdsController = widget.eventModel!.programIds;
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
            widget.eventModel != null
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
          CustomTextField(
            hintText: "Título",
            enabled: !widget.isDelete,
            controller: titleController,
            validator: (title) {
              if (title == null || title.isEmpty) {
                return "Por favor ingrese un título";
              }

              if (title.length < 3) {
                return "El título debe tener al menos 3 caracteres";
              }

              return null;
            },
          ),
          const SizedBox(
            height: 16,
          ),
          CustomTextField(
            hintText: "Descripción",
            maxLines: 3,
            enabled: !widget.isDelete,
            controller: descriptionController,
            validator: (description) {
              if (description == null || description.isEmpty) {
                return "Por favor ingrese una descripción";
              }

              if (description.length < 3) {
                return "La descripción debe tener al menos 3 caracteres";
              }

              return null;
            },
          ),
          const SizedBox(
            height: 16,
          ),
          CustomTextField(
            hintText: "Fecha y hora",
            controller: TextEditingController(
              text: dateController != null
                  ? DateFormat("dd/MM/yyyy h:mm a").format(dateController!)
                  : null,
            ),
            enabled: !widget.isDelete,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Por favor seleccione una fecha y hora";
              }

              if (dateController == null) return null;

              if (dateController!.isBefore(DateTime(
                dateController!.year,
                dateController!.month,
                dateController!.day,
                7,
                0,
              ))) {
                return "La hora de inicio no puede ser antes de las 7:00 AM";
              }

              if (dateController!.isAfter(DateTime(
                dateController!.year,
                dateController!.month,
                dateController!.day,
                21,
                5,
              ))) {
                return "La hora de inicio no puede ser después de las 9:05 PM";
              }

              return null;
            },
            onChanged: (_) {
              setState(() {});
            },
            onTap: () async {
              await CustomDatePicker.showDatePicker(
                context: context,
                initialDate: dateController ?? DateTime.now(),
              ).then((dateTime) async {
                if (dateTime != null) {
                  final TimeOfDay? timeOfDay =
                      await CustomTimePicker.showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(
                        dateController ?? DateTime.now()),
                  );

                  if (timeOfDay != null) {
                    setState(() {
                      dateController = DateTime(
                        dateTime.year,
                        dateTime.month,
                        dateTime.day,
                        timeOfDay.hour,
                        timeOfDay.minute,
                      );
                    });

                    await Future.delayed(Duration.zero, () {
                      setState(() {
                        _formKey.currentState!.validate();
                      });
                    });
                  }
                }
              });
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

              if (dateController == null) return null;

              final startTime = TimeOfDay.fromDateTime(dateController!);

              if (endTimeController != null &&
                  startTime.isAfter(endTimeController!)) {
                return "La hora de fin debe ser después de la hora de inicio";
              }

              if (endTimeController != null && startTime == endTimeController) {
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
                initialTime: endTimeController ?? TimeOfDay.now(),
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
          CustomMultiSelectField(
            items: widget.programs
                .map(
                  (program) =>
                      MultiSelectItem<String>(program.id, program.name),
                )
                .toList(),
            onConfirm: (values) {
              setState(() {
                programIdsController = values.map((e) => e.toString()).toList();
              });
            },
            title: "Programas",
            buttonText: programIdsController.isEmpty
                ? "Seleccione uno o más programas"
                : programIdsController.length == 1
                    ? "1 programa seleccionado"
                    : "${programIdsController.length} programas seleccionados",
            searchHint: "Buscar programa",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Por favor seleccione al menos un programa";
              }

              return null;
            },
            initialValue: programIdsController,
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
                          .deleteEvent(widget.eventModel!.id)
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
                      if (widget.eventModel != null) {
                        await FirebaseFirestoreService()
                            .updateEvent(
                          EventModel(
                            id: widget.eventModel!.id,
                            title: titleController.text,
                            description: descriptionController.text,
                            date: dateController!,
                            endTime: endTimeController!,
                            programIds: programIdsController,
                          ),
                        )
                            .then(
                          (value) {
                            Navigator.pop(context);
                            _formKey.currentState!.reset();
                            Navigator.pop(context);
                          },
                        );
                      } else {
                        await FirebaseFirestoreService()
                            .addEvent(
                          EventModel(
                            id: const Uuid().v4(),
                            title: titleController.text,
                            description: descriptionController.text,
                            date: dateController!,
                            endTime: endTimeController!,
                            programIds: programIdsController,
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
                  text: widget.eventModel != null ? "Actualizar" : "Crear",
                ),
        ],
      ),
    );
  }
}
