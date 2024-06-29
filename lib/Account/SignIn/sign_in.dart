// @dart=2.9
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:aqua/Account/ForgotPassword/bloc/forgot_password_bloc.dart';
import 'package:aqua/Account/ForgotPassword/forgot_password.dart';
import 'package:aqua/Account/SignIn/bloc/user_repository.dart';
import 'package:aqua/Account/authentication_bloc/authentication_bloc.dart';
import 'package:aqua/translation/app_localizations.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:aqua/utils/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'bloc/signin_bloc.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  double globalMediaWidth = 0.0;
  double globalMediaHeight = 0.0;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final UserRepository _userRepository = UserRepository();
  SigninBloc _signinBloc;
  bool isAppleSignInAvailable = false;

  bool isLoginButtonEnabled(SigninState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  bool get isPopulated =>
      emailController.text.isNotEmpty && passwordController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _signinBloc = BlocProvider.of<SigninBloc>(context);
    emailController.addListener(_onEmailChanged);
    passwordController.addListener(_onPasswordChanged);

    checkSign();
  }

  Future<void> checkSign() async {
    await AppleSignIn.isAvailable().then((value) {
      setState(() {
        isAppleSignInAvailable = value;
      });
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _signinBloc.drain();
    super.dispose();
  }

  void _onEmailChanged() {
    _signinBloc.add(
      EmailChanged(email: emailController.text),
    );
  }

  void _onPasswordChanged() {
    _signinBloc.add(
      PasswordChanged(password: passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _signinBloc.add(
      LoginWithCredentialsPressed(
        email: emailController.text.replaceAll(" ", ''),
        password: passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    globalMediaWidth = MediaQuery.of(context).size.width;
    globalMediaHeight = MediaQuery.of(context).size.height;
    return BlocListener<SigninBloc, SigninState>(
      listener: (context, state) {
        if (state.isFailure) {
          print('Inside:${state.infoMessage}');
          Navigator.pop(context);
          Alert(
            context: context,
            title: AppLocalizations.of(context).translate('alert'),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${state.infoMessage}'),
              ],
            ),
            buttons: [
              DialogButton(
                child: Text(
                  AppLocalizations.of(context).translate('ok'),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                width: 120,
              )
            ],
          ).show();
        }
        if (state.isSubmitting) {
          print('INside submitting: ${state.infoMessage}');

          Alert(
            context: context,
            title: AppLocalizations.of(context).translate('alert'),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: AquaProgressIndicator(),
                ),
                Text('${state.infoMessage}'),
              ],
            ),
            buttons: [
              DialogButton(
                child: Text(
                  AppLocalizations.of(context).translate('ok'),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                width: 120,
              )
            ],
          ).show();
        }
        if (state.isSuccess) {
          print('I am in success');
          Navigator.pop(context);

          Alert(
            context: context,
            title: AppLocalizations.of(context).translate('alert'),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${state.infoMessage}'),
              ],
            ),
            buttons: [
              DialogButton(
                child: Text(
                  AppLocalizations.of(context).translate('ok'),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
                },
                width: 120,
              )
            ],
          ).show();
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: BlocBuilder<SigninBloc, SigninState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: AppColors.SIGN_GRAYCOLOR,
              body: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(padding: const EdgeInsets.all(20)),
                      _buildEmailTextField(
                        AppLocalizations.of(context).translate('enterEmailId'),
                        AppLocalizations.of(context).translate('enterEmailId'),
                        AppLocalizations.of(context).translate('emailId'),
                        FontAwesomeIcons.portrait,
                        emailController,
                        state,
                      ),
                      _buildPasswordTextField(
                        AppLocalizations.of(context).translate('password'),
                        AppLocalizations.of(context).translate('password'),
                        AppLocalizations.of(context).translate('password'),
                        FontAwesomeIcons.eyeSlash,
                        passwordController,
                        state,
                      ),
                      _signInButton(state),
                      _forgotPwd(),
                      //     Padding(padding: const EdgeInsets.all(10)),
                      _orText(),
                      //      Padding(padding: const EdgeInsets.all(10)),
                      _createSocialLogIn()
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmailTextField(
      String validatorText,
      String hintText,
      String labelText,
      IconData icon,
      TextEditingController controller,
      SigninState state) {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 5, left: 10, right: 10),
      alignment: Alignment.center,
      height: 60,
      child: TextFormField(
        controller: controller,
        validator: (_) {
          return !state.isEmailValid
              ? AppLocalizations.of(context).translate('invalidEmail')
              : null;
        },
        // onChanged: (value) {
        //   _formKey.currentState.validate();
        // },
        style: Theme.of(context).textTheme.headline4,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: AppColors.WHITE_COLOR,
            size: 15,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.WHITE_COLOR,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.WHITE_COLOR,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.WHITE_COLOR,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            fontFamily: 'Montserrat',
            color: AppColors.WHITE_BACKGROUND,
          ),
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: 'Montserrat',
            color: AppColors.WHITE_BACKGROUND,
          ),
        ),
      ),
    );
  }

  bool _obscureTextLogin = true;
  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  Widget _buildPasswordTextField(
      String validatorText,
      String hintText,
      String labelText,
      IconData icon,
      TextEditingController controller,
      SigninState state) {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 5, left: 10, right: 10),
      alignment: Alignment.center,
      height: 60,
      child: TextFormField(
        obscureText: _obscureTextLogin,
        controller: controller,
        validator: (value) {
          return !state.isPasswordValid
              ? AppLocalizations.of(context).translate('invalidPassword')
              : null;
        },
        // onChanged: (value) {
        //   _formKey.currentState.validate();
        // },
        style: Theme.of(context).textTheme.headline4,
        decoration: InputDecoration(
          prefixIcon: GestureDetector(
            onTap: _toggleLogin,
            child: Icon(
              _obscureTextLogin
                  ? FontAwesomeIcons.eyeSlash
                  : FontAwesomeIcons.eye,
              size: 15.0,
              color: Colors.white,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.WHITE_COLOR,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.WHITE_COLOR,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.WHITE_COLOR,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            fontFamily: 'Montserrat',
            color: AppColors.WHITE_BACKGROUND,
          ),
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: 'Montserrat',
            color: AppColors.WHITE_BACKGROUND,
          ),
        ),
      ),
    );
  }

  Widget _signInButton(SigninState state) {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      child: InkWell(
        //  customBorder: CircleBorder(),
        onTap: () => isLoginButtonEnabled(state)
            ? _onFormSubmitted()
            : _checkUsernamePwd(),
        child: Container(
          width: 200,
          height: 45,
          alignment: Alignment.center,
          // padding: const EdgeInsets.only(top: 60),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: AppColors.WHITE_COLOR,
            border: Border.all(
              color: AppColors.WHITE_COLOR,
              width: 2,
            ),
          ),
          child: Text(
            AppLocalizations.of(context).translate('signIn'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: AppColors.BLACK_COLOR,
            ),
            maxLines: 2,
          ),
        ),
      ),
    );
  }

  void _checkUsernamePwd() {
    Alert(
      context: context,
      title: AppLocalizations.of(context).translate('alert'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context).translate('invalidUserNameorPassword'),
          ),
        ],
      ),
      buttons: [
        DialogButton(
          child: Text(
            AppLocalizations.of(context).translate('ok'),
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  Widget _forgotPwd() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: TextButton(
          onPressed: () {
            //  _showDialog();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => ForgotPasswordBloc(),
                  child: ForgotPassword(),
                ),
                fullscreenDialog: true,
              ),
            );
          },
          child: Text(
            AppLocalizations.of(context).translate('forgotPassword'),
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.white,
              fontSize: 16.0,
              fontFamily: 'Montserrat',
            ),
          )),
    );
  }

  Widget _createSocialLogIn() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Visibility(
            visible: isAppleSignInAvailable,
            child: InkWell(
              customBorder: CircleBorder(),
              onTap: () {
                _signinBloc.add(LoginWithApple());
              },
              child: Container(
                padding: const EdgeInsets.all(15.0),
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: new Icon(
                  FontAwesomeIcons.apple,
                  size: 30,
                  color: AppColors.BLACK_COLOR,
                ),
              ),
            ),
          ),
          Padding(padding: const EdgeInsets.all(15)),
          // InkWell(
          //   customBorder: CircleBorder(),
          //   onTap: () {
          //     print("Called");
          //     _signinBloc.add(LoginWithFacebook());
          //   },
          //   child: Container(
          //     padding: const EdgeInsets.all(15.0),
          //     decoration: new BoxDecoration(
          //       shape: BoxShape.circle,
          //       color: Colors.white,
          //     ),
          //     child: new Icon(
          //       FontAwesomeIcons.facebookF,
          //       size: 30,
          //       color: AppColors.BLACK_COLOR,
          //     ),
          //   ),
          // ),
          // Padding(padding: const EdgeInsets.all(15)),
          InkWell(
            customBorder: CircleBorder(),
            onTap: () {
              _signinBloc.add(LoginWithGmail());
            },
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: new Icon(
                FontAwesomeIcons.google,
                size: 30,
                color: AppColors.BLACK_COLOR,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orText() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: new LinearGradient(
                colors: [
                  Colors.white10,
                  Colors.white,
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 1.0),
              ),
            ),
            width: 100.0,
            height: 1.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            child: Text(
              AppLocalizations.of(context).translate('or'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: new LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white10,
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 1.0),
                // stops: [0.0, 1.0],
                // tileMode: TileMode.clamp
              ),
            ),
            width: 100.0,
            height: 1.0,
          ),
        ],
      ),
    );
  }
}
