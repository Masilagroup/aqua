// @dart=2.9
import 'package:aqua/Account/SignIn/bloc/user_repository.dart';
import 'package:aqua/Account/SignIn/sign_in.dart';
import 'package:aqua/Account/SignUp/signup.dart';
import 'package:aqua/translation/app_localizations.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'SignIn/bloc/signin_bloc.dart';
import 'SignUp/bloc/signup_bloc.dart';

class SignInSignUp extends StatefulWidget {
  const SignInSignUp({Key key}) : super(key: key);

  @override
  _SignInSignUpState createState() => _SignInSignUpState();
}

class _SignInSignUpState extends State<SignInSignUp> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.WHITE_BACKGROUND,
        appBar: AppBar(
          centerTitle: true,
          iconTheme: Theme.of(context).iconTheme,
          backgroundColor: AppColors.WHITE_COLOR,
          title: Image.asset(
            'assets/images/aqua-big_medium.png',
            height: 30,
            fit: BoxFit.contain,
            color: Colors.black,
          ),
          bottom: TabBar(
            labelColor: AppColors.BLACK_COLOR,
            labelStyle: TextStyle(
              color: AppColors.BLACK_COLOR,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
            ),
            indicatorColor: AppColors.BLACK_COLOR,
            tabs: [
              Tab(
                text: AppLocalizations.of(context).translate('signIn'),
              ),
              Tab(
                text: AppLocalizations.of(context).translate('signUp'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BlocProvider<SigninBloc>(
              create: (context) => SigninBloc(userRepository: UserRepository()),
              child: SignInPage(),
            ),
            BlocProvider<SignupBloc>(
              create: (context) => SignupBloc(UserRepository()),
              child: SignUpPage(),
            ),
          ],
        ),
      ),
    );
  }
}
