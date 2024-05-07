import 'package:calendario_flutter/components/app_colors.dart';
import 'package:calendario_flutter/components/buttons/primary_button.dart';
import 'package:calendario_flutter/components/buttons/secondary_button.dart';
import 'package:calendario_flutter/components/dialogs/error_dialog.dart';
import 'package:calendario_flutter/components/dialogs/loading_dialog.dart';
import 'package:calendario_flutter/components/text_fields/custom_dropdown_button.dart';
import 'package:calendario_flutter/components/text_fields/custom_text_field.dart';
import 'package:calendario_flutter/models/error_model.dart';
import 'package:calendario_flutter/models/professor_model.dart';
import 'package:calendario_flutter/models/program_model.dart';
import 'package:calendario_flutter/models/subject_model.dart';
import 'package:calendario_flutter/services/firebase_firestore_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class SubjectDialog extends StatefulWidget {
  final List<ProgramModel> programs;
  final List<ProfessorModel> professors;

  final SubjectModel? subjectModel;
  final bool isDelete;

  const SubjectDialog(
      {super.key,
      required this.programs,
      required this.professors,
      this.subjectModel,
      this.isDelete = false});

  @override
  State<SubjectDialog> createState() => _SubjectDialogState();

  static void show({
    required BuildContext context,
    required List<ProgramModel> programs,
    required List<ProfessorModel> professors,
    SubjectModel? subjectModel,
    bool isDelete = false,
  }) {
    showDialog(
      context: context,
      builder: (context) => SubjectDialog(
        programs: programs,
        professors: professors,
        subjectModel: subjectModel,
        isDelete: isDelete,
      ),
    );
  }
}

class _SubjectDialogState extends State<SubjectDialog> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final creditsController = TextEditingController();

  String? programIdController;
  String? semesterController;
  String? professorIdController;

  @override
  void initState() {
    super.initState();

    if (widget.subjectModel != null) {
      nameController.text = widget.subjectModel!.name;
      creditsController.text = widget.subjectModel!.credits.toString();

      programIdController = widget.subjectModel!.programId;
      semesterController = widget.subjectModel!.semester.toString();
      professorIdController = widget.subjectModel!.professorId;
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
            widget.subjectModel != null
                ? widget.isDelete
                    ? "¿Estás seguro de eliminar esta materia?"
                    : "Actualizar Materia"
                : "Crear Materia",
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
            hintText: "Nombre",
            enabled: !widget.isDelete,
            controller: nameController,
            validator: (name) {
              if (name == null || name.isEmpty) {
                return "Por favor ingrese el nombre de la materia";
              }

              if (name.length < 3) {
                return "El nombre debe tener al menos 3 caracteres";
              }

              return null;
            },
          ),
          const SizedBox(
            height: 16,
          ),
          CustomTextField(
            hintText: "Creditos",
            enabled: !widget.isDelete,
            controller: creditsController,
            keyboardType: TextInputType.number,
            validator: (credits) {
              if (credits == null || credits.isEmpty) {
                return "Por favor ingrese los creditos de la materia";
              }

              final numCredits = int.tryParse(credits);

              if (numCredits == null || numCredits <= 0) {
                return "Por favor ingrese un número válido";
              }

              return null;
            },
          ),
          const SizedBox(
            height: 16,
          ),
          widget.isDelete
              ? CustomTextField(
                  hintText: "Programa",
                  enabled: false,
                  controller: TextEditingController(
                      text: widget.programs
                          .where((programModel) =>
                              programModel.id == widget.subjectModel!.programId)
                          .firstOrNull
                          ?.name),
                )
              : CustomDropdownButton(
                  hintText: "Programa",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor seleccione un programa";
                    }

                    return null;
                  },
                  value: programIdController,
                  items: [
                    for (final programModel in widget.programs)
                      DropdownMenuItem(
                        value: programModel.id,
                        child: Text(
                          programModel.name,
                        ),
                      )
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      programIdController = newValue!;
                      semesterController = null;
                    });
                  },
                ),
          const SizedBox(
            height: 16,
          ),
          widget.isDelete
              ? CustomTextField(
                  hintText: "Semestre",
                  enabled: false,
                  controller: TextEditingController(
                      text: widget.subjectModel!.semester.toString()),
                )
              : CustomDropdownButton(
                  hintText: "Semestre",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor seleccione un semestre";
                    }

                    return null;
                  },
                  value: semesterController,
                  items: [
                    for (var i = 1;
                        i <=
                            (widget.programs
                                    .where((programModel) =>
                                        programModel.id == programIdController)
                                    .firstOrNull
                                    ?.semesters ??
                                0);
                        i++)
                      DropdownMenuItem(
                        value: i.toString(),
                        child: Text(
                          i.toString(),
                        ),
                      )
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      semesterController = newValue!;
                    });
                  },
                ),
          const SizedBox(
            height: 16,
          ),
          widget.isDelete
              ? CustomTextField(
                  hintText: "Profesor",
                  enabled: false,
                  controller: TextEditingController(
                      text: widget.professors
                          .where((professorModel) =>
                              professorModel.id ==
                              widget.subjectModel!.professorId)
                          .map((e) => "${e.name} - ${e.area}")
                          .firstOrNull),
                )
              : CustomDropdownButton(
                  isDense: false,
                  hintText: "Profesor",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor seleccione un profesor";
                    }

                    return null;
                  },
                  value: professorIdController,
                  items: [
                    for (final professorModel in widget.professors)
                      DropdownMenuItem(
                        value: professorModel.id,
                        child: Text(
                          "${professorModel.name} - ${professorModel.area}",
                        ),
                      )
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      professorIdController = newValue!;
                    });
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
                          .deleteSubject(widget.subjectModel!.id)
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
                      if (widget.subjectModel != null) {
                        await FirebaseFirestoreService()
                            .updateSubject(
                          SubjectModel(
                            id: widget.subjectModel!.id,
                            name: nameController.text,
                            credits: int.parse(creditsController.text),
                            programId: programIdController!,
                            semester: int.parse(semesterController!),
                            professorId: professorIdController!,
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
                            .addSubject(
                          SubjectModel(
                            id: const Uuid().v4(),
                            name: nameController.text,
                            credits: int.parse(creditsController.text),
                            programId: programIdController!,
                            semester: int.parse(semesterController!),
                            professorId: professorIdController!,
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
                  text: widget.subjectModel != null ? "Actualizar" : "Crear",
                ),
        ],
      ),
    );
  }
}
