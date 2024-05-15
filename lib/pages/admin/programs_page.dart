import 'package:calendario_flutter/components/admin/custom_data_table.dart';
import 'package:calendario_flutter/components/admin/custom_scaffold.dart';
import 'package:calendario_flutter/components/admin/dialogs/program_dialog.dart';
import 'package:calendario_flutter/components/app_colors.dart';
import 'package:calendario_flutter/components/dialogs/error_dialog.dart';
import 'package:calendario_flutter/components/dialogs/loading_dialog.dart';
import 'package:calendario_flutter/components/text_fields/custom_text_field.dart';
import 'package:calendario_flutter/models/error_model.dart';
import 'package:calendario_flutter/models/program_model.dart';
import 'package:calendario_flutter/services/firebase_firestore_service.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class AdminProgramsPage extends StatefulWidget {
  static const String id = "/admin-programs";

  const AdminProgramsPage({super.key});

  @override
  State<AdminProgramsPage> createState() => _AdminProgramsPageState();
}

class _AdminProgramsPageState extends State<AdminProgramsPage> {
  bool _isLoadingStream = true;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      textAppBar: "Programas",
      body: StreamBuilder(
        stream: FirebaseFirestoreService().getProgramsStream(),
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
                        "No se pudo obtener la información de los programas"),
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
                        "No se pudo obtener la información de los programas"),
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
                    'No hay programas registrados',
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
            programs: streamSnapshot.data!,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.white,
        onPressed: () {
          ProgramDialog.show(context: context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _FilterTable extends StatefulWidget {
  final List<ProgramModel> programs;

  const _FilterTable({required this.programs, ValueKey? key}) : super(key: key);

  @override
  State<_FilterTable> createState() => _FilterTableState();
}

class _FilterTableState extends State<_FilterTable> {
  List<ProgramModel> programsFiltered = [];

  final nameController = TextEditingController();

  void _filter() {
    setState(() {
      programsFiltered = widget.programs
          .where((element) => element.name
              .toLowerCase()
              .contains(nameController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();

    programsFiltered = widget.programs;
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
            label: Text('Semestres'),
            size: ColumnSize.S,
            numeric: true,
          ),
          DataColumn2(
            label: Text('Acciones'),
            size: ColumnSize.S,
          ),
        ],
        rows: [
          for (ProgramModel programModel in programsFiltered)
            DataRow(
              cells: [
                DataCell(Text(programModel.name)),
                DataCell(Text(programModel.semesters.toString())),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: AppColor.secondary),
                        onPressed: () {
                          ProgramDialog.show(
                            context: context,
                            programModel: programModel,
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: AppColor.secondary),
                        onPressed: () {
                          ProgramDialog.show(
                            context: context,
                            programModel: programModel,
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
