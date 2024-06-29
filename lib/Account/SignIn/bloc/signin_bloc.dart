// @dart=2.9
import 'dart:async';
import 'dart:convert';

import 'package:aqua/Account/SignIn/bloc/user_repository.dart';
import 'package:aqua/Api_Manager/api_response_manager.dart';
import 'package:aqua/utils/constants.dart';
import 'package:aqua/utils/validators.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  final UserRepository _userRepository;
  // final Map<String, dynamic> body;

  SigninBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  SigninState get initialState => SigninState.empty();

  @override
  Stream<Transition<SigninEvent, SigninState>> transformEvents(
    Stream<SigninEvent> events,
    TransitionFunction<SigninEvent, SigninState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final debounceStream = events.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<SigninState> mapEventToState(SigninEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is LoginWithGmail) {
      yield* _mapLoginWithGooglePressedState();
    } else if (event is LoginWithFacebook) {
      yield* _mapLoginWithFacebookPressedState();
    } else if (event is LoginWithApple) {
      yield* _mapLoginWithApplePressedState();
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
        email: event.email,
        password: event.password,
      );
    }
  }

  Stream<SigninState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<SigninState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<SigninState> _mapLoginWithCredentialsPressedToState({
    String email,
    String password,
  }) async* {
    yield SigninState.loading('Authenticating..');
    try {
      await _userRepository.logInWith(email, password);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      var userData = json.decode(prefs.getString(Constants.aquaUserData)) ??
          Map<String, dynamic>();
      if (userData['message'] == 'success') {
        yield SigninState.success(userData['info'], false);
      } else {
        print('inside yield faulure');
        yield SigninState.failure(userData['info']);
      }
    } catch (_) {
      yield SigninState.failure('Problem in connecting Server!');
    }
  }

  Stream<SigninState> _mapLoginWithGooglePressedState() async* {
    Constants.logInErrorMessage = '';
    yield SigninState.loading('Authenticating..');
    try {
      await _userRepository.signInWithGoogle();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userData = Map<String, dynamic>();

      if (Constants.logInErrorMessage == '') {
        userData = json.decode(prefs.getString(Constants.aquaUserData) ?? {}) ??
            Map<String, dynamic>();
      }
      if (userData['message'] == 'success') {
        yield SigninState.success(
          userData['info'],
          true,
        );
      } else {
        print('inside yield faulure');
        if (Constants.logInErrorMessage != '') {
          yield SigninState.failure(Constants.logInErrorMessage);
        } else {
          yield SigninState.failure(userData['info']);
        }
      }
    } catch (_) {
      yield SigninState.failure('Problem in connecting Server!');
    }
  }

  Stream<SigninState> _mapLoginWithFacebookPressedState() async* {
    Constants.logInErrorMessage = '';

    yield SigninState.loading('Authenticating..');
    try {
      await _userRepository.signInWithFacebook();

      var userData = Map<String, dynamic>();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (Constants.logInErrorMessage == '') {
        userData = json.decode(prefs.getString(Constants.aquaUserData) ?? {}) ??
            Map<String, dynamic>();
      }
      if (userData['message'] == 'success') {
        yield SigninState.success(userData['info'], true);
      } else {
        print('inside yield faulure');
        if (Constants.logInErrorMessage != '') {
          yield SigninState.failure(Constants.logInErrorMessage);
        } else {
          yield SigninState.failure(userData['info']);
        }
      }
    } catch (_) {
      yield SigninState.failure('Problem in connecting Server!');
    }
  }

  Stream<SigninState> _mapLoginWithApplePressedState() async* {
    Constants.logInErrorMessage = '';

    yield SigninState.loading('Authenticating..');
    try {
      await _userRepository.signInWithApple();

      var userData = Map<String, dynamic>();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (Constants.logInErrorMessage == '') {
        userData = json.decode(prefs.getString(Constants.aquaUserData) ?? {}) ??
            Map<String, dynamic>();
      }
      if (userData['message'] == 'success') {
        yield SigninState.success(userData['info'], true);
      } else {
        print('inside yield faulure');
        if (Constants.logInErrorMessage != '') {
          print(Constants.logInErrorMessage);

          yield SigninState.failure(Constants.logInErrorMessage);
        } else {
          print(Constants.logInErrorMessage);
          yield SigninState.failure(userData['info']);
        }
      }
    } catch (_) {
      yield SigninState.failure('Problem in connecting Server!');
    }
  }
}
