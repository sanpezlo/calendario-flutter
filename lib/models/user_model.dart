class UserModel {
  String id;
  String name;
  String email;
  bool isAdmin;

  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      this.isAdmin = false});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        isAdmin: json['isAdmin'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'isAdmin': isAdmin,
      };
}
