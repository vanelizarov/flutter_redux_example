import 'dart:convert';

import 'package:flutter_redux_example/models.dart';

class LoginAction {
  LoginAction({
    this.username,
    this.password,
  });

  final String username;
  final String password;

  String toJson() => json.encode({
        "username": username,
        "password": password,
      });
}

class LoginLoadingAction {}

class LoginErrorAction {
  LoginErrorAction({this.error});

  final String error;
}

class LoginSuccessAction {
  LoginSuccessAction({this.user});

  final User user;
}
