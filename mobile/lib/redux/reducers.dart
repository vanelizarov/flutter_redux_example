import 'package:redux/redux.dart';

import 'package:flutter_redux_example/redux/actions.dart';
import 'package:flutter_redux_example/redux/store.dart';

final appReducer = combineReducers<AppState>([
  TypedReducer<AppState, LoginLoadingAction>(_onLoad),
  TypedReducer<AppState, LoginErrorAction>(_onError),
  TypedReducer<AppState, LoginSuccessAction>(_onSuccess),
]);

AppState _onLoad(AppState state, LoginLoadingAction action) => AppState(isLoading: true);
AppState _onError(AppState state, LoginErrorAction action) => AppState(error: action.error);
AppState _onSuccess(AppState state, LoginSuccessAction action) => AppState(user: action.user);
