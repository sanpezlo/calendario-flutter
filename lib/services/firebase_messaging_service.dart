import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseMessagingService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    await _firebaseMessaging.requestPermission();

    final fcmToken = await _firebaseMessaging.getToken();

    if (kDebugMode) {
      print('FCM Token: $fcmToken');
    }

    FirebaseMessaging.onBackgroundMessage(handleBackgroudMessage);
  }

  Future<void> handleBackgroudMessage(RemoteMessage message) async {}

  Future<String?> fcmToken() => _firebaseMessaging.getToken();
}
