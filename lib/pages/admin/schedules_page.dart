import 'package:calendario_flutter/components/admin/custom_data_table.dart';
import 'package:calendario_flutter/components/admin/custom_scaffold.dart';
import 'package:calendario_flutter/components/admin/dialogs/schedule_dialog.dart';
import 'package:calendario_flutter/components/app_colors.dart';
import 'package:calendario_flutter/components/buttons/custom_button.dart';
import 'package:calendario_flutter/components/dialogs/error_dialog.dart';
import 'package:calendario_flutter/components/dialogs/loading_dialog.dart';
import 'package:calendario_flutter/components/text_fields/custom_dropdown_button.dart';
import 'package:calendario_flutter/components/text_fields/custom_text_field.dart';
import 'package:calendario_flutter/models/error_model.dart';
import 'package:calendario_flutter/models/program_model.dart';
import 'package:calendario_flutter/models/schedule_model.dart';
import 'package:calendario_flutter/models/subject_model.dart';
import 'package:calendario_flutter/services/firebase_firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class AdminSchedulesPage extends StatefulWidget {
  static const String id = "/admin-schedules";

  const AdminSchedulesPage({super.key});

  @override
  State<AdminSchedulesPage> createState() => _AdminSchedulesPageState();
}

class _AdminSchedulesPageState extends State<AdminSchedulesPage> {
  bool _isLoadingStream = true;

  Stream<List<QuerySnapshot>> getStream() {
    final schedulesStream =
        FirebaseFirestoreService().getSchedulesStreamQuery();
    final subjectsStream = FirebaseFirestoreService().getSubjectsStreamQuery();
    final programsStream = FirebaseFirestoreService().getProgramsStreamQuery();

    return CombineLatestStream.list(
        [schedulesStream, subjectsStream, programsStream]);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      textAppBar: "Horarios",
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
                          "No se pudo obtener la información de los horarios"),
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
                          "No se pudo obtener la información de los horarios"),
                ),
              );

              return const SizedBox.shrink();
            }

            if (_isLoadingStream) {
              _isLoadingStream = false;
              Future.delayed(Duration.zero, () => Navigator.pop(context));
            }

            final schedules = streamSnapshot.data![0].docs
                .map((e) =>
                    ScheduleModel.fromJson(e.data() as Map<String, dynamic>))
                .toList();

            final subjects = streamSnapshot.data![1].docs
                .map((e) =>
                    SubjectModel.fromJson(e.data() as Map<String, dynamic>))
                .toList();

            final programs = streamSnapshot.data![2].docs
                .map((e) =>
                    ProgramModel.fromJson(e.data() as Map<String, dynamic>))
                .toList();

            if (schedules.isEmpty) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No hay horarios registrados',
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
                    ScheduleDialog.show(
                        context: context,
                        subjects: subjects,
                        programs: programs,
                        schedules: schedules);
                  },
                  child: const Icon(Icons.add),
                ),
              );
            }

            return Scaffold(
              body: _FilterTable(
                key: ValueKey(schedules),
                schedules: schedules,
                subjects: subjects,
                programs: programs,
              ),
              floatingActionButton: FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: AppColor.primary,
                foregroundColor: AppColor.white,
                onPressed: () {
                  ScheduleDialog.show(
                      context: context,
                      subjects: subjects,
                      programs: programs,
                      schedules: schedules);
                },
                child: const Icon(Icons.add),
              ),
            );
          }),
    );
  }
}

class _FilterTable extends StatefulWidget {
  final List<ScheduleModel> schedules;
  final List<SubjectModel> subjects;
  final List<ProgramModel> programs;

  const _FilterTable({
    required this.schedules,
    required this.subjects,
    required this.programs,
    ValueKey? key,
  }) : super(key: key);

  @override
  State<_FilterTable> createState() => _FilterTableState();
}

class _FilterTableState extends State<_FilterTable> {
  List<ScheduleModel> schedulesFiltered = [];

  final nameController = TextEditingController();
  String? programIdController;
  String? semesterController;

  void _filter() {
    schedulesFiltered = widget.schedules.where((scheduleModel) {
      final subject = widget.subjects
          .where((element) => element.id == scheduleModel.subjectId)
          .firstOrNull;

      if (nameController.text.isNotEmpty &&
          subject?.name
                  .toLowerCase()
                  .contains(nameController.text.toLowerCase()) ==
              false) {
        return false;
      }

      if (programIdController != null &&
          subject?.programId != programIdController) {
        return false;
      }

      if (semesterController != null &&
          subject?.semester != int.parse(semesterController!)) {
        return false;
      }

      return true;
    }).toList();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    schedulesFiltered = widget.schedules;
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
                  schedulesFiltered = widget.schedules;
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
            label: Text('Materia'),
            size: ColumnSize.L,
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
            label: Text('Hora de inicio'),
            size: ColumnSize.M,
          ),
          DataColumn2(
            label: Text('Hora de fin'),
            size: ColumnSize.M,
          ),
          DataColumn2(
            label: Text('Día'),
            size: ColumnSize.M,
          ),
          DataColumn2(
            label: Text('Aula'),
            size: ColumnSize.M,
          ),
          DataColumn2(
            label: Text('Acciones'),
            size: ColumnSize.S,
          ),
        ],
        rows: [
          for (ScheduleModel scheduleModel in schedulesFiltered)
            DataRow(
              cells: [
                DataCell(Text(widget.subjects
                        .where(
                            (element) => element.id == scheduleModel.subjectId)
                        .map((e) => e.name)
                        .firstOrNull ??
                    "No encontrado")),
                DataCell(Text(widget.programs
                        .where((element) =>
                            element.id ==
                            widget.subjects
                                .where((element) =>
                                    element.id == scheduleModel.subjectId)
                                .firstOrNull
                                ?.programId)
                        .map((e) => e.name)
                        .firstOrNull ??
                    "No encontrado")),
                DataCell(Text(widget.subjects
                        .where(
                            (element) => element.id == scheduleModel.subjectId)
                        .map((e) => e.semester.toString())
                        .firstOrNull ??
                    "No encontrado")),
                DataCell(
                  Text(
                    DateFormat("h:mm a").format(
                      DateTime(0, 0, 0, scheduleModel.startTime.hour,
                          scheduleModel.startTime.minute),
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    DateFormat("h:mm a").format(
                      DateTime(0, 0, 0, scheduleModel.endTime.hour,
                          scheduleModel.endTime.minute),
                    ),
                  ),
                ),
                DataCell(Text(scheduleModel.day.format())),
                DataCell(Text(scheduleModel.classroom)),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: AppColor.secondary),
                        onPressed: () {
                          ScheduleDialog.show(
                              context: context,
                              subjects: widget.subjects,
                              programs: widget.programs,
                              schedules: widget.schedules,
                              scheduleModel: scheduleModel);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: AppColor.secondary),
                        onPressed: () {
                          ScheduleDialog.show(
                            context: context,
                            subjects: widget.subjects,
                            programs: widget.programs,
                            schedules: widget.schedules,
                            scheduleModel: scheduleModel,
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
