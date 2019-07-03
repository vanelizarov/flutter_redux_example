import 'package:flutter_redux_example/models.dart';

class AppState {
  AppState({
    this.user,
    this.error,
    this.isLoading = false,
  });

  final User user;
  final String error;
  final bool isLoading;

  factory AppState.initial() => AppState();
}
