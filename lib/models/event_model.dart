import 'package:flutter/material.dart';

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
