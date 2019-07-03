import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_example/models.dart';
import 'package:flutter_redux_example/redux/store.dart';

class ProfileScreenViewModel {
  ProfileScreenViewModel._({this.user});

  final User user;

  factory ProfileScreenViewModel.fromStore(Store<AppState> store) {
    return ProfileScreenViewModel._(user: store.state.user);
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Profile'),
        backgroundColor: CupertinoColors.white,
      ),
      child: StoreConnector<AppState, ProfileScreenViewModel>(
        converter: (store) {
          return ProfileScreenViewModel.fromStore(store);
        },
        builder: (context, vm) {
          return ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            children: <Widget>[Text('id: ${vm.user.id}'), Text('username: ${vm.user.username}')],
          );
        },
      ),
    );
  }
}
