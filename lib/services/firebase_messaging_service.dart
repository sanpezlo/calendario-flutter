import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FirebaseMessagingService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    await _firebaseMessaging.requestPermission();

    final fcmToken = await _firebaseMessaging.getToken();

    if (kDebugMode) {
      print('FCM Token: $fcmToken');
    }

    subscribeProgramTopic();
  }

  Future<void> subscribeProgramTopic(
      {String? programTopic, String? semesterTopic}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (programTopic != null) {
      await subscribeToTopic(programTopic);
      await prefs.setString('programTopic', programTopic);
    } else {
      programTopic = prefs.getString('programTopic');

      if (programTopic != null) {
        await subscribeToTopic(programTopic);
      }
    }

    if (semesterTopic != null) {
      await subscribeToTopic(semesterTopic);
      await prefs.setString('semesterTopic', semesterTopic);
    } else {
      semesterTopic = prefs.getString('semesterTopic');

      if (semesterTopic != null) {
        await subscribeToTopic(semesterTopic);
      }
    }
  }

  Future<void> unsubscribePrgoramTopic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? semesterTopic = prefs.getString('semesterTopic');
    String? programTopic = prefs.getString('programTopic');

    if (semesterTopic != null) {
      await unsubscribeFromTopic(semesterTopic);
      await prefs.remove('semesterTopic');
    }

    if (programTopic != null) {
      await unsubscribeFromTopic(programTopic);
      await prefs.remove('programTopic');
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  Future<void> sendNotification(
      {required String topic,
      required String title,
      required String body}) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'key=${"AAAAUqBqkoA:APA91bH9orJ1pJCwb-aPjOKmyI1RSOHwYiSLdqslkX4j6IT57Q65TrS-xl6bzxD2FB4wtvxacGAlXeHGi44RlC7maPYgn4kbuZzsXIS0rQgjXZ-wffoQtOsoO3vz0R2fK_FgddWRvsvf"}',
        },
        body: jsonEncode({
          'to': '/topics/$topic',
          'notification': {
            'title': title,
            'body': body,
          },
        }),
      );
    } catch (e) {
      if (kDebugMode) {
        print("sendNotification error: $e");
      }
    }
  }

  Future<String?> fcmToken() => _firebaseMessaging.getToken();
}
