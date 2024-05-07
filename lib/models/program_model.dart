class ProgramModel {
  String id;
  String name;
  int semesters;

  ProgramModel({
    required this.id,
    required this.name,
    required this.semesters,
  });

  factory ProgramModel.fromJson(Map<String, dynamic> json) => ProgramModel(
        id: json['id'],
        name: json['name'],
        semesters: json['semesters'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'semesters': semesters,
      };
}
