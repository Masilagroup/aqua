// @dart=2.9
import 'dart:async';
import 'dart:convert';

import 'package:aqua/Account/SignIn/bloc/user_repository.dart';
import 'package:aqua/utils/constants.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  UserRepository _userRepository = UserRepository();
  @override
  ForgotPasswordState get initialState => ForgotPasswordInitial();

  @override
  Stream<ForgotPasswordState> mapEventToState(
    ForgotPasswordEvent event,
  ) async* {
    if (event is SentMailPressed) {
      yield FPMailSentLoading('Loading..');
      try {
        final emailSentData = await _userRepository.mailSent(event.emailId);

        if (emailSentData['message'] == 'success') {
          yield FPMailSentLoaded(emailSentData);
        } else {
          yield FPMailSentError(emailSentData['info']);
        }
      } catch (e) {
        yield FPMailSentError(e.toString());
      }
    }
    if (event is ResetButtonPressed) {
      yield FPUpdateLoading('Loading..');
      try {
        final pwdUpdResult = await _userRepository.resetPassword(
          event.verificationCode,
          event.newpassword,
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        // var userData = json.decode(prefs.getString(Constants.aquaUserData)) ??
        //     Map<String, dynamic>();
        prefs.setString(Constants.aquaUserData, '');
        if (pwdUpdResult['message'] == 'success') {
          yield FPUpdateLoaded(pwdUpdResult);
        } else {
          yield FPUpdateError(pwdUpdResult['info']);
        }
      } catch (e) {
        yield FPMailSentError(e.toString());
      }
    }
  }
}
