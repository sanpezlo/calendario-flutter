import 'package:calendario_flutter/components/admin/custom_data_table.dart';
import 'package:calendario_flutter/components/admin/custom_scaffold.dart';
import 'package:calendario_flutter/components/admin/dialogs/event_dialog.dart';
import 'package:calendario_flutter/components/app_colors.dart';
import 'package:calendario_flutter/components/dialogs/error_dialog.dart';
import 'package:calendario_flutter/components/dialogs/loading_dialog.dart';
import 'package:calendario_flutter/models/error_model.dart';
import 'package:calendario_flutter/models/event_model.dart';
import 'package:calendario_flutter/models/program_model.dart';
import 'package:calendario_flutter/services/firebase_firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class AdminEventsPage extends StatefulWidget {
  static const String id = "/admin-evenets";

  const AdminEventsPage({super.key});

  @override
  State<AdminEventsPage> createState() => _AdminEventsPageState();
}

class _AdminEventsPageState extends State<AdminEventsPage> {
  bool _isLoadingStream = true;

  Stream<List<QuerySnapshot>> getStream() {
    final eventsStream = FirebaseFirestoreService().getEventsStreamQuery();
    final programsStream = FirebaseFirestoreService().getProgramsStreamQuery();

    return CombineLatestStream.list([eventsStream, programsStream]);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      textAppBar: "Eventos",
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

            final events = streamSnapshot.data![0].docs
                .map((e) =>
                    EventModel.fromJson(e.data() as Map<String, dynamic>))
                .toList();

            final programs = streamSnapshot.data![1].docs
                .map((e) =>
                    ProgramModel.fromJson(e.data() as Map<String, dynamic>))
                .toList();

            if (events.isEmpty) {
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
                    EventDialog.show(context: context, programs: programs);
                  },
                  child: const Icon(Icons.add),
                ),
              );
            }

            return Scaffold(
              body: CustomDataTable(
                columns: const [
                  DataColumn2(
                    label: Text('Título'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Descripción'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Fecha y hora'),
                    size: ColumnSize.M,
                  ),
                  DataColumn2(
                    label: Text('Hora de finalización'),
                    size: ColumnSize.M,
                  ),
                  DataColumn2(
                    label: Text('Programas'),
                    size: ColumnSize.M,
                  ),
                  DataColumn2(
                    label: Text('Acciones'),
                    size: ColumnSize.S,
                  ),
                ],
                rows: [
                  for (EventModel eventModel in events)
                    DataRow(
                      cells: [
                        DataCell(Text(eventModel.title)),
                        DataCell(Text(eventModel.description)),
                        DataCell(Text(DateFormat("dd/MM/yyyy h:mm a")
                            .format(eventModel.date))),
                        DataCell(
                          Text(
                            DateFormat("h:mm a").format(
                              DateTime(0, 0, 0, eventModel.endTime.hour,
                                  eventModel.endTime.minute),
                            ),
                          ),
                        ),
                        DataCell(Text(programs
                            .where((element) =>
                                eventModel.programIds.contains(element.id))
                            .map((e) => e.name)
                            .join(", "))),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon:
                                    Icon(Icons.edit, color: AppColor.secondary),
                                onPressed: () {
                                  EventDialog.show(
                                      context: context,
                                      programs: programs,
                                      eventModel: eventModel);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete,
                                    color: AppColor.secondary),
                                onPressed: () {
                                  EventDialog.show(
                                    context: context,
                                    programs: programs,
                                    eventModel: eventModel,
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
                  EventDialog.show(context: context, programs: programs);
                },
                child: const Icon(Icons.add),
              ),
            );
          }),
    );
  }
}
