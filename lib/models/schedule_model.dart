import 'package:calendario_flutter/components/app_colors.dart';
import 'package:calendario_flutter/models/subject_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

enum Day { monday, tuesday, wednesday, thursday, friday, saturday }

extension DayExtension on Day {
  String format() {
    switch (this) {
      case Day.monday:
        return "Lunes";
      case Day.tuesday:
        return "Martes";
      case Day.wednesday:
        return "Miércoles";
      case Day.thursday:
        return "Jueves";
      case Day.friday:
        return "Viernes";
      case Day.saturday:
        return "Sábado";
    }
  }
}

extension TimeOfDayExtension on TimeOfDay {
  bool isBefore(TimeOfDay other) {
    if (hour < other.hour) {
      return true;
    } else if (hour == other.hour) {
      return minute < other.minute;
    } else {
      return false;
    }
  }

  bool isAfter(TimeOfDay other) {
    if (hour > other.hour) {
      return true;
    } else if (hour == other.hour) {
      return minute > other.minute;
    } else {
      return false;
    }
  }
}

class ScheduleModel {
  final String id;
  final String subjectId;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final Day day;

  ScheduleModel({
    required this.id,
    required this.subjectId,
    required this.startTime,
    required this.endTime,
    required this.day,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json["id"],
      subjectId: json["subjectId"],
      startTime: TimeOfDay(
        hour: json["startTime"]["hour"],
        minute: json["startTime"]["minute"],
      ),
      endTime: TimeOfDay(
        hour: json["endTime"]["hour"],
        minute: json["endTime"]["minute"],
      ),
      day: Day.values.firstWhere((element) => element.name == json["day"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "subjectId": subjectId,
      "startTime": {
        "hour": startTime.hour,
        "minute": startTime.minute,
      },
      "endTime": {
        "hour": endTime.hour,
        "minute": endTime.minute,
      },
      "day": day.name
    };
  }
}

class ScheduleDataSource extends CalendarDataSource {
  final List<SubjectModel> subjects;
  final CalendarView calendarView;
  Map<String, Color> mapColors = {};

  ScheduleDataSource(
      {required List<ScheduleModel> source,
      required this.subjects,
      required this.calendarView}) {
    final now = DateTime.now();

    appointments = source
        .map((e) => Appointment(
            subject: calendarView == CalendarView.workWeek
                ? subjects
                    .firstWhere((element) => element.id == e.subjectId)
                    .name
                    .split(" ")
                    .map((e) => _take(e, 4))
                    .join(" ")
                : subjects
                    .firstWhere((element) => element.id == e.subjectId)
                    .name,
            startTime:
                DateTime(now.year, 1, 1, e.startTime.hour, e.startTime.minute),
            endTime: DateTime(now.year, 1, 1, e.endTime.hour, e.endTime.minute),
            color: getScheduleColor(e.subjectId),
            recurrenceRule:
                "FREQ=WEEKLY;INTERVAL=1;BYDAY=${e.day.name.toUpperCase().substring(0, 2)};COUNT=53"))
        .toList();
  }

  String _take(String value, int length) {
    return value.length <= length ? value : "${value.substring(0, length)}.";
  }

  Color getScheduleColor(String subjectId) {
    if (mapColors.containsKey(subjectId)) {
      return mapColors[subjectId]!;
    }

    final color = AppColor.colors[mapColors.length % AppColor.colors.length];
    mapColors[subjectId] = color;

    return color;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  String getRecurrenceRule(int index) {
    return appointments![index].recurrenceRule;
  }
}
