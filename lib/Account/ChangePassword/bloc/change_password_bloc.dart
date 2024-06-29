// @dart=2.9
import 'dart:async';
import 'dart:convert';

import 'package:aqua/Account/SignIn/bloc/user_repository.dart';
import 'package:aqua/utils/constants.dart';
import 'package:aqua/utils/validators.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final UserRepository _userRepository = UserRepository();

  @override
  ChangePasswordState get initialState => ChangePasswordInitial();

  @override
  Stream<ChangePasswordState> mapEventToState(
    ChangePasswordEvent event,
  ) async* {
    if (event is ChangePwd) {
      yield* _mapPasswordChangedToState(event.password);
    }
    if (event is ChangeConfirmPwd) {
      yield* _mapConfirmPasswordToState(event.password, event.confirmPassword);
    }
    if (event is PasswordUpdatepressed) {
      yield* _mappasswordUpdateToState(event.accessToken, event.oldpassword,
          event.newPassword, event.userId);
    }
  }

  Stream<ChangePasswordState> _mapPasswordChangedToState(
      String password) async* {
    yield ValidatePassword(
      Validators.isValidPassword(password),
    );
  }

  Stream<ChangePasswordState> _mapConfirmPasswordToState(
      String password, String confirmPassword) async* {
    yield ValidateConfirmPassword(
      (password == confirmPassword) && Validators.isValidPassword(password),
    );
  }

  Stream<ChangePasswordState> _mappasswordUpdateToState(
    String accessToken,
    String oldPassword,
    String newPassword,
    int userId,
  ) async* {
    try {
      yield ChangePasswordLoading();
      await _userRepository.changePassword(
        oldPassword,
        newPassword,
        accessToken,
        userId,
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userData = json.decode(prefs.getString(Constants.aquaUserData)) ??
          Map<String, dynamic>();
      if (userData['message'] == 'success') {
        yield ChangePwdLoaded(userData: userData);
      } else {
        yield ChangePasswordError(userData['info']);
      }
    } catch (_) {
      yield ChangePasswordError('Problem in connecting Server!');
    }
  }
}
