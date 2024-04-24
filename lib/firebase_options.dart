// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBQ-Of-M4Q6cDvnZMWVSvGJ5qk9BHM6z9M',
    appId: '1:354878657152:web:3ce4095bf0b924ae724c65',
    messagingSenderId: '354878657152',
    projectId: 'calendario-35a0e',
    authDomain: 'calendario-35a0e.firebaseapp.com',
    storageBucket: 'calendario-35a0e.appspot.com',
    measurementId: 'G-RFVJDHFT3S',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyByOncHJvBKlxc1KPrIEYsqjob2aOSZsFk',
    appId: '1:354878657152:android:0085585b0efd1897724c65',
    messagingSenderId: '354878657152',
    projectId: 'calendario-35a0e',
    storageBucket: 'calendario-35a0e.appspot.com',
  );

}