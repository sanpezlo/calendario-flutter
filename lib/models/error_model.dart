class ErrorModel implements Exception {
  final String message;

  ErrorModel({
    this.message = 'Error desconocido',
  });

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
