// @dart=2.9
import 'dart:async';
import 'dart:convert';

import 'package:aqua/Account/SignIn/bloc/signin_bloc.dart';
import 'package:aqua/Account/SignIn/bloc/user_repository.dart';
import 'package:aqua/Api_Manager/api_response_manager.dart';
import 'package:aqua/utils/constants.dart';
import 'package:aqua/utils/validators.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final UserRepository userRepository;

  SignupBloc(this.userRepository);

  @override
  SignupState get initialState => SignupState.empty();

  @override
  Stream<Transition<SignupEvent, SignupState>> transformEvents(
    Stream<SignupEvent> events,
    TransitionFunction<SignupEvent, SignupState> transitionFn,
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
  Stream<SignupState> mapEventToState(
    SignupEvent event,
  ) async* {
    if (event is SignUpEmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is SignUpPasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    }
    if (event is SignUpPhoneChanged) {
      yield* _mapPhoneChangedToState(event.phoneNum);
    }
    if (event is SignupWithCredentialsPressed) {
      yield* _mapSignupWithPressedToState(
          firstName: event.firstname,
          lastName: event.lastname,
          email: event.email,
          password: event.password,
          mobile: event.mobile,
          countryId: event.countryId);
    }
  }

  Stream<SignupState> _mapEmailChangedToState(String email) async* {
    print(state.isEmailValid);
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<SignupState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<SignupState> _mapPhoneChangedToState(String phoneNum) async* {
    yield state.update(
      isPhoneValid: Validators.isvalidMobile(phoneNum),
    );
  }

  Stream<SignupState> _mapSignupWithPressedToState({
    String firstName,
    String lastName,
    String email,
    String password,
    String mobile,
    int countryId,
  }) async* {
    yield SignupState.loading('Creating Account..');
    try {
      await userRepository.signUpWith(
        firstName,
        lastName,
        email,
        password,
        mobile,
        countryId,
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userData = json.decode(prefs.getString(Constants.aquaUserData)) ??
          Map<String, dynamic>();
      if (userData['message'] == 'success') {
        yield SignupState.success(userData['info']);
      } else {
        print('inside yield faulure');
        yield SignupState.failure(userData['info']);
      }
    } catch (_) {
      yield SignupState.failure('Problem in connecting Server!');
    }
  }
}
