class UserModel {
  String id;
  String name;
  String email;
  String programId;
  int semester;
  String token;
  bool isAdmin;

  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.programId,
      required this.semester,
      this.token = '',
      this.isAdmin = false});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        programId: json['programId'],
        semester: json['semester'],
        token: json['token'],
        isAdmin: json['isAdmin'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'programId': programId,
        'semester': semester,
        'token': token,
        'isAdmin': isAdmin,
      };
}
