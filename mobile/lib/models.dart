import 'dart:convert';

class User {
  User({
    this.username,
    this.id,
  });

  final String username;
  final String id;

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        username: json["username"],
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "username": username,
        "id": id,
      };
}

class ApiException {
  ApiException({this.message});

  final String message;

  factory ApiException.fromJson(String str) => ApiException.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ApiException.fromMap(Map<String, dynamic> json) => ApiException(
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
        "message": message,
      };
}
