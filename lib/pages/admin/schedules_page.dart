import 'package:calendario_flutter/components/admin/custom_data_table.dart';
import 'package:calendario_flutter/components/admin/custom_scaffold.dart';
import 'package:calendario_flutter/components/admin/dialogs/schedule_dialog.dart';
import 'package:calendario_flutter/components/app_colors.dart';
import 'package:calendario_flutter/components/dialogs/error_dialog.dart';
import 'package:calendario_flutter/components/dialogs/loading_dialog.dart';
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
                        programs: programs);
                  },
                  child: const Icon(Icons.add),
                ),
              );
            }

            return Scaffold(
              body: CustomDataTable(
                columns: const [
                  DataColumn2(
                    label: Text('Materia'),
                    size: ColumnSize.L,
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
                    label: Text('Acciones'),
                    size: ColumnSize.S,
                  ),
                ],
                rows: [
                  for (ScheduleModel scheduleModel in schedules)
                    DataRow(
                      cells: [
                        DataCell(Text(subjects
                                .where((element) =>
                                    element.id == scheduleModel.subjectId)
                                .map((e) =>
                                    "${e.name} - ${programs.where((element) => element.id == e.programId).firstOrNull?.name ?? "No encontrado"}")
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
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon:
                                    Icon(Icons.edit, color: AppColor.secondary),
                                onPressed: () {
                                  ScheduleDialog.show(
                                      context: context,
                                      subjects: subjects,
                                      programs: programs,
                                      scheduleModel: scheduleModel);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete,
                                    color: AppColor.secondary),
                                onPressed: () {
                                  ScheduleDialog.show(
                                    context: context,
                                    subjects: subjects,
                                    programs: programs,
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
              floatingActionButton: FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: AppColor.primary,
                foregroundColor: AppColor.white,
                onPressed: () {
                  ScheduleDialog.show(
                      context: context, subjects: subjects, programs: programs);
                },
                child: const Icon(Icons.add),
              ),
            );
          }),
    );
  }
}
