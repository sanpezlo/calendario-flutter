import 'package:calendario_flutter/models/professor_model.dart';
import 'package:calendario_flutter/models/program_model.dart';
import 'package:calendario_flutter/models/subject_model.dart';
import 'package:calendario_flutter/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreService {
  Future addUser(UserModel userModel) {
    return FirebaseFirestore.instance
        .collection("User")
        .doc(userModel.id)
        .set(userModel.toJson());
  }

  Future<UserModel?> getUser(String id) async {
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection("User").doc(id).get();

    if (documentSnapshot.exists) {
      return UserModel.fromJson(
          documentSnapshot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<void> addProgram(ProgramModel programModel) {
    return FirebaseFirestore.instance
        .collection("Program")
        .doc(programModel.id)
        .set(programModel.toJson());
  }

  Future<void> updateProgram(ProgramModel programModel) {
    return FirebaseFirestore.instance
        .collection("Program")
        .doc(programModel.id)
        .update(programModel.toJson());
  }

  Future<void> deleteProgram(String id) {
    return FirebaseFirestore.instance.collection("Program").doc(id).delete();
  }

  Stream<List<ProgramModel>> getProgramsStream() {
    return FirebaseFirestore.instance.collection("Program").snapshots().map(
        (querySnapshot) => querySnapshot.docs
            .map((e) => ProgramModel.fromJson(e.data()))
            .toList());
  }

  Stream<QuerySnapshot> getProgramsStreamQuery() {
    return FirebaseFirestore.instance.collection("Program").snapshots();
  }

  Future<void> addProfessor(ProfessorModel professorModel) {
    return FirebaseFirestore.instance
        .collection("Professor")
        .doc(professorModel.id)
        .set(professorModel.toJson());
  }

  Future<void> updateProfessor(ProfessorModel professorModel) {
    return FirebaseFirestore.instance
        .collection("Professor")
        .doc(professorModel.id)
        .update(professorModel.toJson());
  }

  Future<void> deleteProfessor(String id) {
    return FirebaseFirestore.instance.collection("Professor").doc(id).delete();
  }

  Stream<List<ProfessorModel>> getProfessorsStream() {
    return FirebaseFirestore.instance.collection("Professor").snapshots().map(
        (querySnapshot) => querySnapshot.docs
            .map((e) => ProfessorModel.fromJson(e.data()))
            .toList());
  }

  Stream<QuerySnapshot> getProfessorsStreamQuery() {
    return FirebaseFirestore.instance.collection("Professor").snapshots();
  }

  // SUBJECTS

  Future<void> addSubject(SubjectModel subjectModel) {
    return FirebaseFirestore.instance
        .collection("Subject")
        .doc(subjectModel.id)
        .set(subjectModel.toJson());
  }

  Future<void> updateSubject(SubjectModel subjectModel) {
    return FirebaseFirestore.instance
        .collection("Subject")
        .doc(subjectModel.id)
        .update(subjectModel.toJson());
  }

  Future<void> deleteSubject(String id) {
    return FirebaseFirestore.instance.collection("Subject").doc(id).delete();
  }

  Stream<List<SubjectModel>> getSubjectsStream() {
    return FirebaseFirestore.instance.collection("Subject").snapshots().map(
        (querySnapshot) => querySnapshot.docs
            .map((e) => SubjectModel.fromJson(e.data()))
            .toList());
  }

  Stream<QuerySnapshot> getSubjectsStreamQuery() {
    return FirebaseFirestore.instance.collection("Subject").snapshots();
  }
}
