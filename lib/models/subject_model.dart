class SubjectModel {
  final String id;
  final String name;
  final int credits;
  final String programId;
  final int semester;
  final String professorId;

  SubjectModel(
      {required this.id,
      required this.name,
      required this.credits,
      required this.programId,
      required this.semester,
      required this.professorId});

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json["id"],
      name: json["name"],
      credits: json["credits"],
      programId: json["programId"],
      semester: json["semester"],
      professorId: json["professorId"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "credits": credits,
      "programId": programId,
      "semester": semester,
      "professorId": professorId,
    };
  }
}
