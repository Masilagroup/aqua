// @dart=2.9
import 'package:aqua/Account/ChangePassword/bloc/change_password_bloc.dart';
import 'package:aqua/translation/app_localizations.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:aqua/utils/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ChangePassword extends StatefulWidget {
  final Map<String, dynamic> userData;
  ChangePassword({Key key, this.userData}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  double globalMediaWidth = 0.0;
  double globalMediaHeight = 0.0;
  ChangePasswordBloc _changePasswordBloc;

  @override
  void initState() {
    super.initState();
    _changePasswordBloc = BlocProvider.of<ChangePasswordBloc>(context);
    newpasswordController.addListener(_onPasswordChanged);
    confirmPasswordController.addListener(_onConfirmPasswordChanged);
  }

  bool _isChangePwdButtonEnabled() {
    return newpasswordController.text == confirmPasswordController.text &&
        newpasswordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;
  }

  void _onPasswordChanged() {
    _changePasswordBloc.add(ChangePwd(password: newpasswordController.text));
  }

  void _onConfirmPasswordChanged() {
    _changePasswordBloc.add(
      ChangeConfirmPwd(
        password: newpasswordController.text,
        confirmPassword: confirmPasswordController.text,
      ),
    );
  }

  void _onFormSubmitted() {
    _changePasswordBloc.add(
      PasswordUpdatepressed(
        accessToken: widget.userData['data']['user_api_access_token'],
        userId: widget.userData['data']['user_id'],
        oldpassword: oldPasswordController.text,
        newPassword: newpasswordController.text,
      ),
    );
  }

  void _checkPassword() {
    Alert(
      context: context,
      title: AppLocalizations.of(context).translate('alert'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context)
                .translate('checkNewPasswordandConfirmPassword'),
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
        elevation: 1.0,
        titleSpacing: 30.0,
        actionsIconTheme: Theme.of(context).iconTheme,
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: AppColors.WHITE_COLOR,
        title: Text(
          AppLocalizations.of(context).translate('changePassword'),
          style: Theme.of(context).textTheme.headline1,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: BlocListener<ChangePasswordBloc, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordError) {
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
          if (state is ChangePasswordLoading) {
            print('INside submitting:');

            Alert(
              context: context,
              title: AppLocalizations.of(context).translate('alert'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: AquaProgressIndicator()),
                  Text(
                    AppLocalizations.of(context)
                        .translate('updatingNewPassword'),
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
          if (state is ChangePwdLoaded) {
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
        child: BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
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
                      _passwordTextField(
                          AppLocalizations.of(context)
                              .translate('enterOldPassword'),
                          AppLocalizations.of(context)
                              .translate('enterOldPassword'),
                          AppLocalizations.of(context).translate('oldPassword'),
                          FontAwesomeIcons.eyeSlash,
                          oldPasswordController,
                          state),
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

  Widget _updateButton(ChangePasswordState state) {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      child: InkWell(
        onTap: () =>
            _isChangePwdButtonEnabled() ? _onFormSubmitted() : _checkPassword(),
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
            AppLocalizations.of(context).translate('update'),
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
    ChangePasswordState state,
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
}
