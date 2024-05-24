import 'package:calendario_flutter/components/app_colors.dart';
import 'package:calendario_flutter/components/dialogs/error_dialog.dart';
import 'package:calendario_flutter/components/dialogs/event_dialog.dart';
import 'package:calendario_flutter/components/dialogs/loading_dialog.dart';
import 'package:calendario_flutter/components/dialogs/schedule_dialog.dart';
import 'package:calendario_flutter/components/dialogs/user_dialog.dart';
import 'package:calendario_flutter/models/error_model.dart';
import 'package:calendario_flutter/models/event_model.dart';
import 'package:calendario_flutter/models/professor_model.dart';
import 'package:calendario_flutter/models/schedule_model.dart';
import 'package:calendario_flutter/models/subject_model.dart';
import 'package:calendario_flutter/models/user_model.dart';
import 'package:calendario_flutter/services/firebase_auth_service.dart';
import 'package:calendario_flutter/services/firebase_firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HomePage extends StatefulWidget {
  static const String id = "/home";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoadingFuture = true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuthService().getUserModel(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            _isLoadingFuture = true;
            Future.delayed(
              Duration.zero,
              () => LoadingDialog.show(context: context),
            );

            return Scaffold(backgroundColor: AppColor.background);
          }

          if (snapshot.hasError) {
            Future.delayed(
              Duration.zero,
              () => ErrorDialog.show(
                context: context,
                errorModel: ErrorModel(),
              ),
            );

            return Scaffold(backgroundColor: AppColor.background);
          }

          if (!snapshot.hasData) {
            Future.delayed(
              Duration.zero,
              () => ErrorDialog.show(
                context: context,
                errorModel: ErrorModel(
                  message: "No se pudo obtener la información del usuario",
                ),
              ),
            );

            return Scaffold(backgroundColor: AppColor.background);
          }

          if (_isLoadingFuture) {
            _isLoadingFuture = false;
            Future.delayed(Duration.zero, () => Navigator.pop(context));
          }

          return _Stream(userModel: snapshot.data!);
        });
  }
}

class _Stream extends StatefulWidget {
  final UserModel userModel;
  const _Stream({required this.userModel});

  @override
  State<_Stream> createState() => _StreamState();
}

class _StreamState extends State<_Stream> {
  bool _isLoadingStream = true;

  Stream<List<QuerySnapshot>> getStream() {
    final subjectStream = FirebaseFirestoreService()
        .getSubjectsByProgramIdStreamQuery(widget.userModel.programId);
    final schedulesStream =
        FirebaseFirestoreService().getSchedulesStreamQuery();
    final eventsStream = FirebaseFirestoreService()
        .getEventsByProgramIdStreamQuery(widget.userModel.programId);
    final professorsStream =
        FirebaseFirestoreService().getProfessorsStreamQuery();

    return CombineLatestStream.list(
        [subjectStream, schedulesStream, eventsStream, professorsStream]);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getStream(),
      builder: (context, streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          _isLoadingStream = true;
          Future.delayed(
            Duration.zero,
            () => LoadingDialog.show(context: context),
          );

          return Scaffold(backgroundColor: AppColor.background);
        }

        if (streamSnapshot.hasError) {
          Future.delayed(
            Duration.zero,
            () => ErrorDialog.show(
              context: context,
              errorModel: ErrorModel(
                  message:
                      "No se pudo obtener la información de los horarios y eventos"),
            ),
          );

          return Scaffold(backgroundColor: AppColor.background);
        }

        if (!streamSnapshot.hasData) {
          Future.delayed(
            Duration.zero,
            () => ErrorDialog.show(
              context: context,
              errorModel: ErrorModel(
                  message:
                      "No se pudo obtener la información de los horarios y eventos"),
            ),
          );

          return Scaffold(backgroundColor: AppColor.background);
        }

        if (_isLoadingStream) {
          _isLoadingStream = false;
          Future.delayed(Duration.zero, () => Navigator.pop(context));
        }

        final subjects = streamSnapshot.data![0].docs
            .map((e) => SubjectModel.fromJson(e.data() as Map<String, dynamic>))
            .where((element) => element.semester == widget.userModel.semester)
            .toList();

        final schedules = streamSnapshot.data![1].docs
            .map(
                (e) => ScheduleModel.fromJson(e.data() as Map<String, dynamic>))
            .where((element) =>
                subjects.map((e) => e.id).toList().contains(element.subjectId))
            .toList();

        final events = streamSnapshot.data![2].docs
            .map((e) => EventModel.fromJson(e.data() as Map<String, dynamic>))
            .toList();

        final professors = streamSnapshot.data![3].docs
            .map((e) =>
                ProfessorModel.fromJson(e.data() as Map<String, dynamic>))
            .toList();

        return _CustomScaffold(
          userModel: widget.userModel,
          schedules: schedules,
          subjects: subjects,
          professors: professors,
          events: events,
          key: ValueKey(schedules.length + events.length),
        );
      },
    );
  }
}

class _CustomScaffold extends StatefulWidget {
  final UserModel userModel;
  final List<ScheduleModel> schedules;
  final List<SubjectModel> subjects;
  final List<ProfessorModel> professors;
  final List<EventModel> events;

  const _CustomScaffold(
      {required this.userModel,
      required this.schedules,
      required this.subjects,
      required this.professors,
      required this.events,
      ValueKey? key})
      : super(key: key);

  @override
  State<_CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<_CustomScaffold> {
  String _selected = "schedule";

  final CalendarController _calendarController = CalendarController();

  @override
  void initState() {
    super.initState();
    _calendarController.view = CalendarView.workWeek;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selected == "schedule" ? "Horarios" : "Eventos"),
        actions: [
          IconButton(
            onPressed: () {
              UserDialog.show(context: context, userModel: widget.userModel);
            },
            icon: CircleAvatar(
              backgroundColor: AppColor.primary,
              foregroundColor: AppColor.white,
              child: Text(widget.userModel.name[0]),
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppColor.primary,
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Image.asset(
                    "assets/logo_blanco_unicesmag.png",
                    scale: 1.5,
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Horarios',
                style: TextStyle(
                    color: _selected == "schedule"
                        ? AppColor.secondary
                        : AppColor.text),
              ),
              onTap: () {
                setState(() {
                  _selected = "schedule";
                  _calendarController.view = CalendarView.workWeek;
                  _calendarController.displayDate = DateTime.now();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Eventos',
                style: TextStyle(
                    color: _selected == "events"
                        ? AppColor.secondary
                        : AppColor.text),
              ),
              onTap: () {
                setState(() {
                  _selected = "events";
                  _calendarController.view = CalendarView.month;
                  _calendarController.displayDate = DateTime.now();
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SfCalendar(
        controller: _calendarController,
        dataSource: _selected == "schedule"
            ? ScheduleDataSource(
                source: widget.schedules,
                subjects: widget.subjects,
                calendarView: _calendarController.view!,
              )
            : EventDataSource(
                source: widget.events,
              ),
        timeSlotViewSettings: const TimeSlotViewSettings(
          startHour: 7,
          endHour: 22,
          nonWorkingDays: <int>[DateTime.sunday],
        ),
        headerStyle: CalendarHeaderStyle(
          backgroundColor: AppColor.alternative,
          textStyle: TextStyle(color: AppColor.primary),
        ),
        todayHighlightColor: AppColor.secondary,
        monthViewSettings: const MonthViewSettings(
          showAgenda: true,
          showTrailingAndLeadingDates: false,
        ),
        onTap: (calendarTapDetails) {
          if (calendarTapDetails.appointments == null) return;

          if (calendarTapDetails.appointments!.length > 1) return;

          for (Appointment appointment in calendarTapDetails.appointments!) {
            final [type, id] = (appointment.id as String).split("_");

            if (type == "schedule") {
              final schedule = widget.schedules
                  .where((element) => element.id == id)
                  .firstOrNull;

              if (schedule == null) return;

              final subject = widget.subjects
                  .where((element) => element.id == schedule.subjectId)
                  .firstOrNull;

              if (subject == null) return;

              final professor = widget.professors
                  .where((element) => element.id == subject.professorId)
                  .firstOrNull;

              if (professor == null) return;

              ScheduleDialog.show(
                  context: context,
                  scheduleModel: schedule,
                  subjectModel: subject,
                  professorModel: professor);
            } else {
              final event = widget.events
                  .where((element) => element.id == id)
                  .firstOrNull;

              if (event == null) return;

              EventDialog.show(context: context, eventModel: event);
            }
          }
        },
        allowViewNavigation: true,
        allowedViews: _selected == "schedule"
            ? <CalendarView>[CalendarView.day, CalendarView.workWeek]
            : <CalendarView>[
                CalendarView.day,
                CalendarView.workWeek,
                CalendarView.month
              ],
        showTodayButton: true,
        viewNavigationMode: _selected == "schedule"
            ? _calendarController.view == CalendarView.day
                ? ViewNavigationMode.snap
                : ViewNavigationMode.snap
            : ViewNavigationMode.snap,
      ),
    );
  }
}
