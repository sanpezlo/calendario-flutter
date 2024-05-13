import 'package:calendario_flutter/models/event_model.dart';
import 'package:calendario_flutter/models/professor_model.dart';
import 'package:calendario_flutter/models/program_model.dart';
import 'package:calendario_flutter/models/schedule_model.dart';
import 'package:calendario_flutter/models/subject_model.dart';
import 'package:calendario_flutter/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreService {
  // User

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

  // Program

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

  Future<List<ProgramModel>> getPrograms() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("Program").get();

    return querySnapshot.docs
        .map((e) => ProgramModel.fromJson(e.data() as Map<String, dynamic>))
        .toList();
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

  // Professor

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

  // Subject

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

  Stream<QuerySnapshot> getSubjectsByProgramIdStreamQuery(String programId) {
    return FirebaseFirestore.instance
        .collection("Subject")
        .where("programId", isEqualTo: programId)
        .snapshots();
  }

  // Schedule

  Future<void> addSchedule(ScheduleModel schedule) {
    return FirebaseFirestore.instance
        .collection("Schedule")
        .doc(schedule.id)
        .set(schedule.toJson());
  }

  Future<void> updateSchedule(ScheduleModel schedule) {
    return FirebaseFirestore.instance
        .collection("Schedule")
        .doc(schedule.id)
        .update(schedule.toJson());
  }

  Future<void> deleteSchedule(String id) {
    return FirebaseFirestore.instance.collection("Schedule").doc(id).delete();
  }

  Stream<List<ScheduleModel>> getSchedulesStream() {
    return FirebaseFirestore.instance.collection("Schedule").snapshots().map(
        (querySnapshot) => querySnapshot.docs
            .map((e) => ScheduleModel.fromJson(e.data()))
            .toList());
  }

  Stream<QuerySnapshot> getSchedulesStreamQuery() {
    return FirebaseFirestore.instance.collection("Schedule").snapshots();
  }

  // Event

  Future<void> addEvent(EventModel eventModel) {
    return FirebaseFirestore.instance
        .collection("Event")
        .doc(eventModel.id)
        .set(eventModel.toJson());
  }

  Future<void> updateEvent(EventModel eventModel) {
    return FirebaseFirestore.instance
        .collection("Event")
        .doc(eventModel.id)
        .update(eventModel.toJson());
  }

  Future<void> deleteEvent(String id) {
    return FirebaseFirestore.instance.collection("Event").doc(id).delete();
  }

  Stream<List<EventModel>> getEventsStream() {
    return FirebaseFirestore.instance.collection("Event").snapshots().map(
        (querySnapshot) => querySnapshot.docs
            .map((e) => EventModel.fromJson(e.data()))
            .toList());
  }

  Stream<QuerySnapshot> getEventsStreamQuery() {
    return FirebaseFirestore.instance.collection("Event").snapshots();
  }

  Stream<QuerySnapshot> getEventsByProgramIdStreamQuery(String programId) {
    return FirebaseFirestore.instance
        .collection("Event")
        .where("programIds", arrayContains: programId)
        .snapshots();
  }
}
