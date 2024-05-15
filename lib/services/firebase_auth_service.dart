import 'package:calendario_flutter/models/error_model.dart';
import 'package:calendario_flutter/models/user_model.dart';
import 'package:calendario_flutter/services/firebase_firestore_service.dart';
import 'package:calendario_flutter/services/firebase_messaging_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserModel?> getUserModel() async {
    if (currentUser == null) return null;

    return await FirebaseFirestoreService().getUser(currentUser!.uid);
  }

  Future<User?> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
    required String programId,
    required int semester,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      String? token = await FirebaseMessagingService().fcmToken();

      if (userCredential.user != null) {
        await FirebaseFirestoreService().addUser(UserModel(
            id: userCredential.user!.uid,
            name: name,
            email: email,
            programId: programId,
            semester: semester,
            token: token ?? ""));

        final userModel =
            await FirebaseFirestoreService().getUser(userCredential.user!.uid);

        if (userModel == null) return userCredential.user;

        FirebaseMessagingService().subscribeProgramTopic(
            programTopic: userModel.programId,
            semesterTopic: "${userModel.programId}_${userModel.semester}");
      }

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        if (kDebugMode) {
          print('The password provided is too weak.');
        }

        throw ErrorModel(message: 'La contraseña es muy débil');
      } else if (e.code == 'email-already-in-use') {
        if (kDebugMode) {
          print('The account already exists for that email.');
        }

        throw ErrorModel(message: 'El correo ya está en uso');
      } else if (e.code == 'operation-not-allowed') {
        if (kDebugMode) {
          print('The email/password sign-in method is disabled.');
        }

        throw ErrorModel(
            message: 'El método de inicio de sesión está deshabilitado');
      } else {
        if (kDebugMode) {
          print('Failed with error code: ${e.code}');
          print(e.message);
        }

        throw ErrorModel();
      }
    }
  }

  Future<User?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      if (kIsWeb) return userCredential.user;

      final userModel =
          await FirebaseFirestoreService().getUser(userCredential.user!.uid);

      if (userModel == null) return userCredential.user;

      FirebaseMessagingService().subscribeProgramTopic(
          programTopic: userModel.programId,
          semesterTopic: "${userModel.programId}_${userModel.semester}");

      String? token = await FirebaseMessagingService().fcmToken();

      if (userCredential.user != null) {
        FirebaseFirestoreService()
            .updateUserToken(userCredential.user!.uid, token ?? "");
      }

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        if (kDebugMode) {
          print('No user found for that email.');
        }

        throw ErrorModel(message: 'Usuario no encontrado');
      } else if (e.code == 'wrong-password') {
        if (kDebugMode) {
          print('Wrong password provided for that user.');
        }

        throw ErrorModel(
            message: 'Correo electrónico o contraseña incorrectos');
      } else if (e.code == 'invalid-credential') {
        if (kDebugMode) {
          print('Invalid credential provided.');
        }

        throw ErrorModel(
            message: 'Correo electrónico o contraseña incorrectos');
      } else if (e.code == 'user-disabled') {
        if (kDebugMode) {
          print('The user account has been disabled by an administrator.');
        }

        throw ErrorModel(message: 'La cuenta ha sido deshabilitada');
      } else {
        if (kDebugMode) {
          print('Failed with error code: ${e.code}');
          print(e.message);
        }

        throw ErrorModel();
      }
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await FirebaseMessagingService().unsubscribePrgoramTopic();
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
