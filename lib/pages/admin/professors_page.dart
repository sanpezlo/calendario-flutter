import 'package:calendario_flutter/components/admin/custom_data_table.dart';
import 'package:calendario_flutter/components/admin/custom_scaffold.dart';
import 'package:calendario_flutter/components/admin/dialogs/professor_dialog.dart';
import 'package:calendario_flutter/components/app_colors.dart';
import 'package:calendario_flutter/components/dialogs/error_dialog.dart';
import 'package:calendario_flutter/components/dialogs/loading_dialog.dart';
import 'package:calendario_flutter/components/text_fields/custom_text_field.dart';

import 'package:calendario_flutter/models/error_model.dart';
import 'package:calendario_flutter/models/professor_model.dart';
import 'package:calendario_flutter/services/firebase_firestore_service.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class AdminProfessorsPage extends StatefulWidget {
  static const String id = "/admin-professors";

  const AdminProfessorsPage({super.key});

  @override
  State<AdminProfessorsPage> createState() => _AdminProfessorsPageState();
}

class _AdminProfessorsPageState extends State<AdminProfessorsPage> {
  bool _isLoadingStream = true;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      textAppBar: "Profesores",
      body: StreamBuilder(
          stream: FirebaseFirestoreService().getProfessorsStream(),
          builder: (context, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              Future.delayed(
                Duration.zero,
                () => LoadingDialog.show(context: context),
              );

              return const SizedBox.shrink();
            }

            if (streamSnapshot.hasError) {
              Future.delayed(
                Duration.zero,
                () => ErrorDialog.show(
                  context: context,
                  errorModel: ErrorModel(
                      message:
                          "No se pudo obtener la información de los profesores"),
                ),
              );

              return const SizedBox.shrink();
            }

            if (!streamSnapshot.hasData) {
              Future.delayed(
                Duration.zero,
                () => ErrorDialog.show(
                  context: context,
                  errorModel: ErrorModel(
                      message:
                          "No se pudo obtener la información de los profesores"),
                ),
              );

              return const SizedBox.shrink();
            }

            if (_isLoadingStream) {
              _isLoadingStream = false;
              Future.delayed(Duration.zero, () => Navigator.pop(context));
            }

            if (streamSnapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No hay profesores registrados',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                        color: AppColor.text,
                      ),
                    ),
                  ],
                ),
              );
            }

            return _FilterTable(
                key: ValueKey(streamSnapshot.data!),
                professors: streamSnapshot.data!);
          }),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.white,
        onPressed: () {
          ProfessorDialog.show(context: context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _FilterTable extends StatefulWidget {
  final List<ProfessorModel> professors;

  const _FilterTable({required this.professors, ValueKey? key})
      : super(key: key);

  @override
  State<_FilterTable> createState() => _FilterTableState();
}

class _FilterTableState extends State<_FilterTable> {
  final nameController = TextEditingController();
  final areaController = TextEditingController();

  List<ProfessorModel> professorsFiltered = [];

  @override
  void initState() {
    super.initState();

    professorsFiltered = widget.professors;
  }

  void _filter() {
    setState(() {
      professorsFiltered = widget.professors.where((professor) {
        final name = professor.name.toLowerCase();
        final area = professor.area.toLowerCase();
        final nameFilter = nameController.text.toLowerCase();
        final areaFilter = areaController.text.toLowerCase();

        return name.contains(nameFilter) && area.contains(areaFilter);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: AppColor.secondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: AppColor.white),
                  const SizedBox(width: 4),
                  Text(
                    "Buscar",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      color: AppColor.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: CustomTextField(
                hintText: "Nombre",
                controller: nameController,
                onChanged: (value) {
                  _filter();
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: CustomTextField(
                hintText: "Área",
                controller: areaController,
                onChanged: (value) {
                  _filter();
                },
              ),
            ),
          ],
        ),
      ),
      body: CustomDataTable(
        columns: const [
          DataColumn2(
            label: Text('Nombre'),
            size: ColumnSize.L,
          ),
          DataColumn2(
            label: Text('Área'),
            size: ColumnSize.S,
            numeric: true,
          ),
          DataColumn2(
            label: Text('Acciones'),
            size: ColumnSize.S,
          ),
        ],
        rows: [
          for (ProfessorModel professorModel in professorsFiltered)
            DataRow(
              cells: [
                DataCell(Text(professorModel.name)),
                DataCell(Text(professorModel.area)),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: AppColor.secondary),
                        onPressed: () {
                          ProfessorDialog.show(
                            context: context,
                            professorModel: professorModel,
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: AppColor.secondary),
                        onPressed: () {
                          ProfessorDialog.show(
                            context: context,
                            professorModel: professorModel,
                            isDelete: true,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
