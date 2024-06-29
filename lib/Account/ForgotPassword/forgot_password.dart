// @dart=2.9
import 'package:aqua/Account/ForgotPassword/bloc/forgot_password_bloc.dart';
import 'package:aqua/translation/app_localizations.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:aqua/utils/progress_bar.dart';
import 'package:aqua/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({
    Key key,
  }) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  double globalMediaWidth = 0.0;
  double globalMediaHeight = 0.0;
  ForgotPasswordBloc _forgotPasswordBloc;

  @override
  void initState() {
    super.initState();
    _forgotPasswordBloc = BlocProvider.of<ForgotPasswordBloc>(context);
    //  newpasswordController.addListener(_onPasswordChanged);
    //  confirmPasswordController.addListener(_onConfirmPasswordChanged);
  }

  bool _isChangePwdButtonEnabled() {
    return newpasswordController.text == confirmPasswordController.text &&
        newpasswordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;
  }

  // void _onPasswordChanged() {
  //   _forgotPasswordBloc.add(ChangePwd(password: newpasswordController.text));
  // }

  void _onResetPwdSubmitted() {
    _forgotPasswordBloc.add(ResetButtonPressed(
      verificationCode: codeController.text,
      newpassword: newpasswordController.text,
    ));
  }

  void _onEmailSubmitted() {
    _forgotPasswordBloc.add(
      SentMailPressed(
        emailId: emailController.text,
      ),
    );
  }

  void _checkPassword(String msg) {
    Alert(
      context: context,
      title: AppLocalizations.of(context).translate('alert'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            msg,
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

  @override
  Widget build(BuildContext context) {
    globalMediaWidth = MediaQuery.of(context).size.width;
    globalMediaHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        elevation: 1.0,
        titleSpacing: 30.0,
        actionsIconTheme: Theme.of(context).iconTheme,
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: AppColors.WHITE_COLOR,
        title: Text(
          AppLocalizations.of(context)
              .translate('forgotPassword')
              .toUpperCase(),
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state is FPMailSentError) {
            print('Inside:${state.errorMessage}');
            Navigator.pop(context);
            Alert(
              context: context,
              title: AppLocalizations.of(context).translate('alert'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${state.errorMessage}'),
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
          if (state is FPMailSentLoading) {
            print('INside submitting:');
            Alert(
              context: context,
              title: AppLocalizations.of(context).translate('alert'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: AquaProgressIndicator()),
                  Text(state.loadMessage),
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
          if (state is FPMailSentLoaded) {
            print('I am in success');
            Navigator.pop(context);
            Alert(
              context: context,
              title: AppLocalizations.of(context).translate('alert'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)
                        .translate('mailSentSuccessfully'),
                  ),
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
                  },
                  width: 120,
                )
              ],
            ).show();
          }
          if (state is FPUpdateError) {
            Navigator.pop(context);
            Alert(
              context: context,
              title: AppLocalizations.of(context).translate('alert'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${state.errorMessage}'),
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
                  },
                  width: 120,
                )
              ],
            ).show();
          }
          if (state is FPUpdateLoading) {
            print('INside submitting:');
            Alert(
              context: context,
              title: "ALERT",
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: AquaProgressIndicator()),
                  Text(state.loadMessage),
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

          if (state is FPUpdateLoaded) {
            print('I am in success');
            Navigator.pop(context);
            Alert(
              context: context,
              title: AppLocalizations.of(context).translate('alert'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${state.userData['info']}'),
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
                    Navigator.pop(context);
                  },
                  width: 120,
                )
              ],
            ).show();
          }
        },
        child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
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
                        AppLocalizations.of(context).translate('enterEmail'),
                        AppLocalizations.of(context).translate('enterEmail'),
                        AppLocalizations.of(context).translate('email'),
                        FontAwesomeIcons.mailBulk,
                        emailController,
                        state,
                      ),
                      _mailSentButton(state),
                      Padding(padding: const EdgeInsets.all(10)),
                      Divider(
                        color: AppColors.WHITE_BACKGROUND,
                        thickness: 0.5,
                        indent: 10,
                        endIndent: 10,
                      ),
                      Padding(padding: const EdgeInsets.all(10)),
                      _buildEmailTextField(
                        AppLocalizations.of(context)
                            .translate('enterVerificationCode'),
                        AppLocalizations.of(context)
                            .translate('enterVerificationCode'),
                        AppLocalizations.of(context)
                            .translate('verificationCode'),
                        FontAwesomeIcons.telegram,
                        codeController,
                        state,
                      ),
                      _passwordTextField(
                        AppLocalizations.of(context)
                            .translate('enterNewPassword'),
                        AppLocalizations.of(context)
                            .translate('enterNewPassword'),
                        AppLocalizations.of(context).translate('newPassword'),
                        FontAwesomeIcons.eyeSlash,
                        newpasswordController,
                        state,
                      ),
                      _passwordTextField(
                        AppLocalizations.of(context)
                            .translate('confirmPassword'),
                        AppLocalizations.of(context)
                            .translate('confirmPassword'),
                        AppLocalizations.of(context)
                            .translate('confirmPassword'),
                        FontAwesomeIcons.eyeSlash,
                        confirmPasswordController,
                        state,
                      ),
                      _updateButton(state),
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

  Widget _mailSentButton(ForgotPasswordState state) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: InkWell(
        onTap: () => Validators.isValidEmail(emailController.text)
            ? _onEmailSubmitted()
            : _checkPassword(
                AppLocalizations.of(context).translate('mailIsNotValid'),
              ),
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
            AppLocalizations.of(context).translate('sent'),
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

  Widget _updateButton(ForgotPasswordState state) {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      child: InkWell(
        onTap: () => _isChangePwdButtonEnabled()
            ? _onResetPwdSubmitted()
            : _checkPassword(
                AppLocalizations.of(context).translate('passwordInvalid'),
              ),
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
            AppLocalizations.of(context).translate('reset'),
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

  Widget _passwordTextField(
    String validatorText,
    String hintText,
    String labelText,
    IconData icon,
    TextEditingController controller,
    ForgotPasswordState state,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 5, left: 10, right: 10),
      alignment: Alignment.center,
      height: 60,
      child: TextFormField(
        obscureText: true,
        controller: controller,
        validator: (value) {
          //   return !state.isPasswordValid ? 'Invalid Password' : null;
        },
        // onChanged: (value) {
        //   _formKey.currentState.validate();
        // },
        style: Theme.of(context).textTheme.headline1,
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

  Widget _buildEmailTextField(
      String validatorText,
      String hintText,
      String labelText,
      IconData icon,
      TextEditingController controller,
      ForgotPasswordState state) {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 5, left: 10, right: 10),
      alignment: Alignment.center,
      height: 60,
      child: TextFormField(
        controller: controller,
        // validator: (_) {
        //   return !state.isEmailValid ? 'Invalid Email' : null;
        // },
        // onChanged: (value) {
        //   _formKey.currentState.validate();
        // },
        //   style: Theme.of(context).textTheme.display4,
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
}
