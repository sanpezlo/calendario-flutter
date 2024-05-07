import 'package:calendario_flutter/components/app_colors.dart';
import 'package:calendario_flutter/components/buttons/primary_button.dart';
import 'package:calendario_flutter/components/buttons/secondary_button.dart';
import 'package:calendario_flutter/components/dialogs/error_dialog.dart';
import 'package:calendario_flutter/components/dialogs/loading_dialog.dart';
import 'package:calendario_flutter/components/text_fields/custom_text_field.dart';
import 'package:calendario_flutter/models/error_model.dart';
import 'package:calendario_flutter/models/program_model.dart';
import 'package:calendario_flutter/services/firebase_firestore_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ProgramDialog extends StatefulWidget {
  final ProgramModel? programModel;
  final bool isDelete;

  const ProgramDialog({super.key, this.programModel, this.isDelete = false});

  @override
  State<ProgramDialog> createState() => _ProgramDialogState();

  static void show({
    required BuildContext context,
    ProgramModel? programModel,
    bool isDelete = false,
  }) {
    showDialog(
      context: context,
      builder: (context) => ProgramDialog(
        programModel: programModel,
        isDelete: isDelete,
      ),
    );
  }
}

class _ProgramDialogState extends State<ProgramDialog> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final semestersController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.programModel != null) {
      nameController.text = widget.programModel!.name;
      semestersController.text = widget.programModel!.semesters.toString();
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
            widget.programModel != null
                ? widget.isDelete
                    ? "¿Estás seguro de eliminar este programa?"
                    : "Actualizar Programa"
                : "Crear Programa",
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
                return "Por favor ingrese el nombre del programa";
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
            hintText: "Semestres",
            enabled: !widget.isDelete,
            controller: semestersController,
            keyboardType: TextInputType.number,
            validator: (semesters) {
              if (semesters == null || semesters.isEmpty) {
                return "Por favor ingrese el número de semestres";
              }

              int? numSemesters = int.tryParse(semesters);

              if (numSemesters == null ||
                  numSemesters <= 0 ||
                  numSemesters >= 20) {
                return "Por favor ingrese un número válido";
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
                          .deleteProgram(widget.programModel!.id)
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
                      if (widget.programModel != null) {
                        await FirebaseFirestoreService()
                            .updateProgram(
                          ProgramModel(
                            id: widget.programModel!.id,
                            name: nameController.text,
                            semesters: int.parse(semestersController.text),
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
                            .addProgram(
                          ProgramModel(
                            id: const Uuid().v4(),
                            name: nameController.text,
                            semesters: int.parse(semestersController.text),
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
                  text: widget.programModel != null ? "Actualizar" : "Crear",
                ),
        ],
      ),
    );
  }
}
