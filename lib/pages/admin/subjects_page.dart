import 'package:calendario_flutter/components/admin/custom_data_table.dart';
import 'package:calendario_flutter/components/admin/custom_scaffold.dart';
import 'package:calendario_flutter/components/admin/dialogs/subject_dialog.dart';
import 'package:calendario_flutter/components/app_colors.dart';
import 'package:calendario_flutter/components/buttons/custom_button.dart';
import 'package:calendario_flutter/components/dialogs/error_dialog.dart';
import 'package:calendario_flutter/components/dialogs/loading_dialog.dart';
import 'package:calendario_flutter/components/text_fields/custom_dropdown_button.dart';
import 'package:calendario_flutter/components/text_fields/custom_text_field.dart';
import 'package:calendario_flutter/models/error_model.dart';
import 'package:calendario_flutter/models/professor_model.dart';
import 'package:calendario_flutter/models/program_model.dart';
import 'package:calendario_flutter/models/subject_model.dart';
import 'package:calendario_flutter/services/firebase_firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class AdminSubjectsPage extends StatefulWidget {
  static const String id = "/admin-subjects";

  const AdminSubjectsPage({super.key});

  @override
  State<AdminSubjectsPage> createState() => _AdminSubjectsPageState();
}

class _AdminSubjectsPageState extends State<AdminSubjectsPage> {
  bool _isLoadingStream = true;

  Stream<List<QuerySnapshot>> getStream() {
    final programsStream = FirebaseFirestoreService().getProgramsStreamQuery();
    final professorsStream =
        FirebaseFirestoreService().getProfessorsStreamQuery();
    final subjectsStream = FirebaseFirestoreService().getSubjectsStreamQuery();

    return CombineLatestStream.list(
        [subjectsStream, programsStream, professorsStream]);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      textAppBar: "Materias",
      body: StreamBuilder(
          stream: getStream(),
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
                          "No se pudo obtener la información de las materias"),
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
                          "No se pudo obtener la información de las materias"),
                ),
              );

              return const SizedBox.shrink();
            }

            if (_isLoadingStream) {
              _isLoadingStream = false;
              Future.delayed(Duration.zero, () => Navigator.pop(context));
            }

            final subjects = streamSnapshot.data![0].docs
                .map((e) =>
                    SubjectModel.fromJson(e.data() as Map<String, dynamic>))
                .toList();

            final programs = streamSnapshot.data![1].docs
                .map((e) =>
                    ProgramModel.fromJson(e.data() as Map<String, dynamic>))
                .toList();

            final professors = streamSnapshot.data![2].docs
                .map((e) =>
                    ProfessorModel.fromJson(e.data() as Map<String, dynamic>))
                .toList();

            if (subjects.isEmpty) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No hay materias registrads',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                          color: AppColor.text,
                        ),
                      ),
                    ],
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: AppColor.primary,
                  foregroundColor: AppColor.white,
                  onPressed: () {
                    SubjectDialog.show(
                        context: context,
                        programs: programs,
                        professors: professors);
                  },
                  child: const Icon(Icons.add),
                ),
              );
            }

            return Scaffold(
              body: _FilterTable(
                  key: ValueKey(subjects),
                  subjects: subjects,
                  programs: programs,
                  professors: professors),
              floatingActionButton: FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: AppColor.primary,
                foregroundColor: AppColor.white,
                onPressed: () {
                  SubjectDialog.show(
                      context: context,
                      programs: programs,
                      professors: professors);
                },
                child: const Icon(Icons.add),
              ),
            );
          }),
    );
  }
}

class _FilterTable extends StatefulWidget {
  final List<SubjectModel> subjects;
  final List<ProgramModel> programs;
  final List<ProfessorModel> professors;

  const _FilterTable({
    required this.subjects,
    required this.programs,
    required this.professors,
    ValueKey? key,
  }) : super(key: key);

  @override
  State<_FilterTable> createState() => _FilterTableState();
}

class _FilterTableState extends State<_FilterTable> {
  List<SubjectModel> subjectsFiltered = [];

  final nameController = TextEditingController();
  String? programIdController;
  String? semesterController;

  void _filter() {
    setState(() {
      subjectsFiltered = widget.subjects.where((subject) {
        final name = subject.name.toLowerCase();
        final programId = subject.programId;
        final semester = subject.semester.toString();
        final nameFilter = nameController.text.toLowerCase();
        final programIdFilter = programIdController;
        final semesterFilter = semesterController;

        return name.contains(nameFilter) &&
            (programIdFilter == null || programId == programIdFilter) &&
            (semesterFilter == null || semester == semesterFilter);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();

    subjectsFiltered = widget.subjects;
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
              child: CustomDropdownButton(
                hintText: "Programa",
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
                  _filter();
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: CustomDropdownButton(
                hintText: "Semestre",
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
                  _filter();
                },
              ),
            ),
            const SizedBox(width: 16),
            CustomButton(
              color: AppColor.alternative,
              textColor: AppColor.secondary,
              onPressed: () {
                setState(() {
                  nameController.clear();
                  programIdController = null;
                  semesterController = null;
                  subjectsFiltered = widget.subjects;
                });
              },
              icon: const Icon(Icons.refresh),
              text: "Restablecer",
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
            label: Text('Créditos'),
            size: ColumnSize.S,
            numeric: true,
          ),
          DataColumn2(
            label: Text('Programa'),
            size: ColumnSize.M,
          ),
          DataColumn2(
            label: Text('Semestre'),
            size: ColumnSize.S,
            numeric: true,
          ),
          DataColumn2(
            label: Text('Profesor'),
            size: ColumnSize.M,
          ),
          DataColumn2(
            label: Text('Acciones'),
            size: ColumnSize.S,
          ),
        ],
        rows: [
          for (SubjectModel subjectModel in subjectsFiltered)
            DataRow(
              cells: [
                DataCell(Text(subjectModel.name)),
                DataCell(Text(subjectModel.credits.toString())),
                DataCell(Text(
                  widget.programs
                          .where(
                              (element) => element.id == subjectModel.programId)
                          .firstOrNull
                          ?.name ??
                      "No encontrado",
                )),
                DataCell(Text(subjectModel.semester.toString())),
                DataCell(Text(
                  widget.professors
                          .where((element) =>
                              element.id == subjectModel.professorId)
                          .map((e) => "${e.name} - ${e.area}")
                          .firstOrNull ??
                      "No encontrado",
                )),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: AppColor.secondary),
                        onPressed: () {
                          SubjectDialog.show(
                              context: context,
                              programs: widget.programs,
                              professors: widget.professors,
                              subjectModel: subjectModel);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: AppColor.secondary),
                        onPressed: () {
                          SubjectDialog.show(
                            context: context,
                            programs: widget.programs,
                            professors: widget.professors,
                            subjectModel: subjectModel,
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
