import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_redux_example/redux/actions.dart';
import 'package:flutter_redux_example/redux/store.dart';
import 'package:flutter_redux_example/keys.dart';
import 'package:flutter_redux_example/models.dart';
import 'package:flutter_redux_example/screens/profile.dart';

class LoginEpic implements EpicClass<AppState> {
  LoginEpic({this.httpClient});

  final http.Client httpClient;

  @override
  Stream call(Stream actions, EpicStore<AppState> store) {
    return Observable(actions).ofType(TypeToken<LoginAction>()).switchMap(_login);
  }

  Stream<dynamic> _login(LoginAction action) async* {
    yield LoginLoadingAction();

    try {
      final res = await httpClient.post(
        'http://localhost:1616/login',
        headers: {
          'Content-Type': 'application/json',
        },
        body: action.toJson(),
        encoding: utf8,
      );

      if (res.statusCode >= 400) {
        throw ApiException.fromJson(res.body);
      }

      yield LoginSuccessAction(user: User.fromJson(res.body));
    } on ApiException catch (err) {
      yield LoginErrorAction(error: err.message);
    } on Exception catch (err) {
      print(err);
      yield LoginErrorAction(error: 'Something went wrong, try again');
    }
  }
}

class NavigationMiddleware implements MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
    if (action is LoginSuccessAction) {
      kNavKey.currentState.pushReplacement(
        CupertinoPageRoute(builder: (context) => ProfileScreen()),
      );
    }

    next(action);
  }
}
