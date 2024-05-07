import 'package:flutter/material.dart';

class NavigationModel {
  final String id;
  final IconData icon;
  final String title;

  NavigationModel({
    required this.id,
    required this.icon,
    required this.title,
  });

  factory NavigationModel.fromJson(Map<String, dynamic> json) {
    return NavigationModel(
      id: json['id'],
      icon: json['icon'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'icon': icon,
      'title': title,
    };
  }
}
