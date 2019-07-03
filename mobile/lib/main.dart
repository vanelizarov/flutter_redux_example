import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_epics/redux_epics.dart';

import 'package:flutter_redux_example/keys.dart';
import 'package:flutter_redux_example/redux/store.dart';
import 'package:flutter_redux_example/redux/reducers.dart';
import 'package:flutter_redux_example/redux/middleware.dart';
import 'package:flutter_redux_example/screens/login.dart';

class App extends StatelessWidget {
  App({this.store});

  final Store<AppState> store;

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: CupertinoApp(
        navigatorKey: kNavKey,
        home: LoginScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

void main() {
  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initial(),
    middleware: [
      EpicMiddleware<AppState>(
        LoginEpic(
          httpClient: http.Client(),
        ),
      ),
      NavigationMiddleware(),
    ],
  );

  runApp(App(store: store));
}
