import 'package:calendario_flutter/components/app_colors.dart';
import 'package:calendario_flutter/components/buttons/primary_button.dart';
import 'package:calendario_flutter/components/buttons/secondary_button.dart';
import 'package:calendario_flutter/components/dialogs/error_dialog.dart';
import 'package:calendario_flutter/components/dialogs/loading_dialog.dart';
import 'package:calendario_flutter/components/text_fields/custom_text_field.dart';
import 'package:calendario_flutter/models/error_model.dart';
import 'package:calendario_flutter/models/professor_model.dart';
import 'package:calendario_flutter/services/firebase_firestore_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ProfessorDialog extends StatefulWidget {
  final ProfessorModel? professorModel;
  final bool isDelete;

  const ProfessorDialog(
      {super.key, this.professorModel, this.isDelete = false});

  @override
  State<ProfessorDialog> createState() => _ProfessorDialogState();

  static void show({
    required BuildContext context,
    ProfessorModel? professorModel,
    bool isDelete = false,
  }) {
    showDialog(
      context: context,
      builder: (context) => ProfessorDialog(
        professorModel: professorModel,
        isDelete: isDelete,
      ),
    );
  }
}

class _ProfessorDialogState extends State<ProfessorDialog> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final areaController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.professorModel != null) {
      nameController.text = widget.professorModel!.name;
      areaController.text = widget.professorModel!.area;
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
            widget.professorModel != null
                ? widget.isDelete
                    ? "¿Estás seguro de eliminar este profesor?"
                    : "Actualizar Profesor"
                : "Crear Profesor",
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
                return "Por favor ingrese el nombre del profesor";
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
            hintText: "Area",
            enabled: !widget.isDelete,
            controller: areaController,
            validator: (area) {
              if (area == null || area.isEmpty) {
                return "Por favor ingrese el area del profesor";
              }

              if (area.length < 3) {
                return "El area debe tener al menos 3 caracteres";
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
                          .deleteProfessor(widget.professorModel!.id)
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
                      if (widget.professorModel != null) {
                        await FirebaseFirestoreService()
                            .updateProfessor(
                          ProfessorModel(
                            id: widget.professorModel!.id,
                            name: nameController.text,
                            area: areaController.text,
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
                            .addProfessor(
                          ProfessorModel(
                            id: const Uuid().v4(),
                            name: nameController.text,
                            area: areaController.text,
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
                  text: widget.professorModel != null ? "Actualizar" : "Crear",
                ),
        ],
      ),
    );
  }
}
