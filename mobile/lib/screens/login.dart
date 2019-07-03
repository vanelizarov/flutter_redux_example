import 'package:flutter/cupertino.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:flutter_redux_example/redux/actions.dart';
import 'package:flutter_redux_example/redux/store.dart';

class LoginScreenViewModel {
  LoginScreenViewModel._({this.isLoading, this.error, this.onSubmit});

  final bool isLoading;
  final String error;

  final void Function(String username, String password) onSubmit;

  factory LoginScreenViewModel.fromStore(
    Store<AppState> store, {
    void Function(String username, String password) onSubmit,
  }) {
    return LoginScreenViewModel._(
      error: store.state.error,
      isLoading: store.state.isLoading,
      onSubmit: onSubmit,
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _username;
  TextEditingController _password;

  Widget _buildInput({
    TextEditingController controller,
    String placeholder,
    bool isSafe = false,
    bool isDisabled = false,
  }) {
    return Container(
      height: 48.0,
      margin: const EdgeInsets.only(bottom: 8.0),
      child: CupertinoTextField(
        autocorrect: false,
        autofocus: false,
        clearButtonMode: OverlayVisibilityMode.editing,
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
        ),
        placeholder: placeholder,
        obscureText: isSafe,
        controller: controller,
        enabled: !isDisabled,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Color(0xffdddddd),
            width: 0.0,
            style: BorderStyle.solid,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _username = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Log in'),
        backgroundColor: CupertinoColors.white,
      ),
      child: StoreConnector<AppState, LoginScreenViewModel>(
        converter: (store) {
          return LoginScreenViewModel.fromStore(
            store,
            onSubmit: (username, password) {
              store.dispatch(LoginAction(username: username, password: password));
            },
          );
        },
        builder: (context, vm) {
          return ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            children: <Widget>[
              _buildInput(
                placeholder: 'Username',
                controller: _username,
                isDisabled: vm.isLoading,
              ),
              _buildInput(
                placeholder: 'Password',
                controller: _password,
                isSafe: true,
                isDisabled: vm.isLoading,
              ),
              Container(
                margin: const EdgeInsets.only(
                  bottom: 16.0,
                  top: 8.0,
                  right: 2.0,
                  left: 2.0,
                ),
                child: Text(
                  vm.error ?? '',
                  style: TextStyle(
                    color: CupertinoColors.destructiveRed,
                    fontSize: 14.0,
                  ),
                ),
              ),
              CupertinoButton.filled(
                child: vm.isLoading ? CupertinoActivityIndicator() : Text('Log in'),
                pressedOpacity: 0.5,
                onPressed: vm.isLoading
                    ? null
                    : () {
                        vm.onSubmit(
                          _username.text.trim(),
                          _password.text.trim(),
                        );
                      },
              )
            ],
          );
        },
      ),
    );
  }
}
