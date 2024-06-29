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

part 'my_profile_event.dart';
part 'my_profile_state.dart';

class MyProfileBloc extends Bloc<MyProfileEvent, MyProfileState> {
  final UserRepository userRepository = UserRepository();

  @override
  MyProfileState get initialState => MyProfileInittial(Map<String, dynamic>());

  @override
  Stream<MyProfileState> mapEventToState(
    MyProfileEvent event,
  ) async* {
    // if (event is ProfileEmailChanged) {
    //   yield* _mapEmailChangedToState(event.email);
    // }
    // if (event is ProfilePhoneChanged) {
    //   yield* _mapPhoneChangedToState(event.phoneNum);
    // }
    if (event is ProfileDataRetrive) {
      yield* _mapRetriveUserData();
    }
    if (event is ProfileWithUpdatePressed) {
      yield* _mapSignupWithPressedToState(
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        mobile: event.mobile,
        countryId: event.countryId,
        userId: event.userId,
        accessToken: event.accessToken,
        area: event.area,
        block: event.block,
        street: event.street,
        house: event.house,
        address: event.address,
      );
    }
  }

  Stream<MyProfileState> _mapRetriveUserData() async* {
    final userData = await userRepository.getUserData();
    if (userData['message'] == 'success') {
      yield MyProfileRetriveUserState(userData);
    } else {
      yield MyProfileError(userData['info']);
    }
  }

  Stream<MyProfileState> _mapEmailChangedToState(String email) async* {
    yield MyProfileEmailState(
      Validators.isValidEmail(email),
    );
  }

  Stream<MyProfileState> _mapPhoneChangedToState(String phoneNum) async* {
    yield MyProfilePhoneState(
      Validators.isvalidMobile(phoneNum),
    );
  }

  Stream<MyProfileState> _mapSignupWithPressedToState({
    String firstName,
    String lastName,
    String email,
    String mobile,
    int countryId,
    int userId,
    String accessToken,
    String area,
    String block,
    String street,
    String house,
    String address,
  }) async* {
    yield MyProfileLoading();
    try {
      await userRepository.updateUserProfile(
        firstName,
        lastName,
        email,
        int.parse(mobile),
        countryId,
        userId,
        accessToken,
        area,
        block,
        street,
        house,
        address,
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userData = json.decode(prefs.getString(Constants.aquaUserData)) ??
          Map<String, dynamic>();
      if (userData['message'] == 'success') {
        yield MyProfileLoaded(false, false, true, userData: userData);
      } else {
        yield MyProfileError(userData['info']);
      }
    } catch (_) {
      yield MyProfileError('Problem in connecting Server!');
    }
  }
}
