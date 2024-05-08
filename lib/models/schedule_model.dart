import 'package:flutter/material.dart';

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
