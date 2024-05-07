class ProfessorModel {
  String id;
  String name;
  String area;

  ProfessorModel({
    required this.id,
    required this.name,
    required this.area,
  });

  factory ProfessorModel.fromJson(Map<String, dynamic> json) => ProfessorModel(
        id: json["id"],
        name: json["name"],
        area: json["area"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "area": area,
      };
}
