import 'package:calendario_flutter/components/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay endTime;
  final List<String> programIds;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.endTime,
    required this.programIds,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      date: DateTime.parse(json["date"]),
      endTime: TimeOfDay(
        hour: json["endTime"]["hour"],
        minute: json["endTime"]["minute"],
      ),
      programIds: List<String>.from(json["programIds"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "date": date.toIso8601String(),
      "endTime": {
        "hour": endTime.hour,
        "minute": endTime.minute,
      },
      "programIds": programIds,
    };
  }
}

class EventDataSource extends CalendarDataSource {
  int indexColor = 0;

  EventDataSource({required List<EventModel> source}) {
    appointments = source
        .map((event) => Appointment(
              startTime: event.date,
              endTime: DateTime(
                event.date.year,
                event.date.month,
                event.date.day,
                event.endTime.hour,
                event.endTime.minute,
              ),
              subject: event.title,
              color: getEventColor(),
            ))
        .toList();
  }

  Color getEventColor() {
    final color = AppColor.colors[indexColor];
    indexColor = (indexColor + 1) % AppColor.colors.length;
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
}
