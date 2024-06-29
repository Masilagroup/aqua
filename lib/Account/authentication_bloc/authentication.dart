// @dart=2.9
import 'package:aqua/Account/SignIn/bloc/user_repository.dart';
import 'package:aqua/Account/authentication_bloc/authentication_bloc.dart';
import 'package:aqua/Account/my_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../signup_signin.dart';

class Authentication extends StatelessWidget {
  const Authentication({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return AuthenticationBloc(userRepository: UserRepository())
          ..add(
            AppStarted(),
          );
      },
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Unauthenticated) {
            return SignInSignUp();
          }
          if (state is Authenticated) {
            print(state.userData);
            return MyAccount(userData: state.userData);
          } else {
            return Scaffold();
          }
        },
      ),
    );
  }
}
