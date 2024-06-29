// @dart=2.9
import 'dart:convert';
import 'dart:io';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:aqua/Api_Manager/api_helper.dart';
import 'package:aqua/Api_Manager/api_response_manager.dart';
import 'package:aqua/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();

  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn();

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    String accessToken = googleAuth.accessToken.toString();
    await _firebaseAuth.signInWithCredential(credential).then((value) async {
      print(value.additionalUserInfo.profile['email']);
      await logInWithSocial(
        value.user.uid,
        value.user.displayName,
        value.additionalUserInfo.profile['email'],
        'google',
        accessToken,
      );

      await logInWithSocial(
        value.user.uid,
        value.user.displayName,
        value.additionalUserInfo.profile['email'],
        'google',
        accessToken,
      );
    });
  }

  Future<void> signInWithFacebook() async {
    FacebookLoginResult facebookLoginResult = await _handleFBSignIn();
    if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
      final accessToken = facebookLoginResult.accessToken.token;

      final facebookAuthCred =
          FacebookAuthProvider.getCredential(accessToken: accessToken);
      print(accessToken);
      // final result = await _firebaseAuth.signInWithCredential(facebookAuthCred);
      // print(result.additionalUserInfo.profile['email']);

      await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCred)
          .then((value) async {
        await FirebaseAuth.instance.currentUser().then((val) async {
          //   print(value.user.email);
          print(value.additionalUserInfo.profile['email']);
          //     print(val.email);
          await logInWithSocial(
            value.user.uid,
            value.user.displayName,
            value.additionalUserInfo.profile['email'],
            'facebook',
            accessToken,
          );

          await logInWithSocial(
            value.user.uid,
            value.user.displayName,
            value.additionalUserInfo.profile['email'],
            'facebook',
            accessToken,
          );
        });
      });
    } else if (facebookLoginResult.status ==
        FacebookLoginStatus.cancelledByUser) {
      Constants.logInErrorMessage = "Cancelled";
    } else {
      Constants.logInErrorMessage = FacebookLoginStatus.error.toString();
    }
  }

  Future<FacebookLoginResult> _handleFBSignIn() async {
    FacebookLogin facebookLogin = FacebookLogin();
    FacebookLoginResult facebookLoginResult =
        await facebookLogin.logIn(['email', 'public_profile']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        break;
      case FacebookLoginStatus.loggedIn:
        break;
    }

    return facebookLoginResult;
  }

  Future<void> signInWithApple() async {
    try {
      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      switch (result.status) {
        case AuthorizationStatus.authorized:
          try {
            print("successfull sign in");
            final AppleIdCredential appleIdCredential = result.credential;

            OAuthProvider oAuthProvider =
                new OAuthProvider(providerId: "apple.com");
            final AuthCredential credential = oAuthProvider.getCredential(
              idToken: String.fromCharCodes(appleIdCredential.identityToken),
              accessToken:
                  String.fromCharCodes(appleIdCredential.authorizationCode),
            );

            print(appleIdCredential.fullName.givenName);

            // final AuthResult _res =
            await FirebaseAuth.instance
                .signInWithCredential(credential)
                .then((value) async {
              await FirebaseAuth.instance.currentUser().then((val) async {
                UserUpdateInfo updateUser = UserUpdateInfo();
                updateUser.displayName =
                    "${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}";
                updateUser.photoUrl = "define an url";
                await val.updateProfile(updateUser);
                await logInWithSocial(
                  value.user.uid,
                  appleIdCredential.fullName.givenName ?? "Apple User",
                  value.additionalUserInfo.profile['email'],
                  'apple',
                  String.fromCharCodes(appleIdCredential.authorizationCode),
                );
                await logInWithSocial(
                  value.user.uid,
                  appleIdCredential.fullName.givenName ?? "Apple User",
                  value.additionalUserInfo.profile['email'],
                  'apple',
                  String.fromCharCodes(appleIdCredential.authorizationCode),
                );
              });
            });
          } catch (e) {
            print("error");
          }
          break;
        case AuthorizationStatus.error:
          Constants.logInErrorMessage = AuthorizationStatus.error.toString();
          break;

        case AuthorizationStatus.cancelled:
          Constants.logInErrorMessage = "Cancelled";
          break;
      }
    } catch (error) {
      print("error with apple sign in");
    }
  }

  Future<void> logInWithSocial(
    String providerId,
    String providerName,
    String providerMail,
    String providerType,
    String providerToken,
  ) async {
    LogInUser tmplogInUser = LogInUser();
    await apiBaseHelper.post(Constants.BASE_URL + Constants.SOCIAL_LOGIN_URL, {
      'provider_id': providerId,
      'provider_type': providerType,
      'provider_token': providerToken,
      'provider_name': providerName,
      'provider_email': providerMail,
      'lang': Constants.selectedLang,
      'device_type': Platform.isIOS ? 'ios' : 'android',
      'device_token': Constants.deviceUUID,
    }).then((logInUser) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(
          Constants.aquaUserData, json.encode(LogInUser.fromJson(logInUser)));
      if (LogInUser.fromJson(logInUser).message == 'success') {
        prefs.setBool(Constants.isLogIn, true);
        Constants.isSignIN = true;
      } else {
        prefs.setBool(Constants.isLogIn, false);
      }
      return LogInUser.fromJson(logInUser);
    }).catchError((onError) {
      return tmplogInUser;
    });
  }

  Future<LogInUser> deleteMyAccount(String accessToken, int userId) async {
    try {
      var x =
          await apiBaseHelper.post(Constants.BASE_URL + Constants.USER_DELETE, {
        'access_token': accessToken,
        'user_id': userId,
        'lang': Constants.selectedLang,
        'device_type': Platform.isIOS ? 'ios' : 'android',
        'device_token': Constants.deviceUUID,
      });
      return LogInUser.fromJson(x);
    } catch (exc) {
      throw exc;
    }
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Constants.deviceToken, Constants.deviceUUID);
    var check = prefs.getBool(Constants.isLogIn);
    if (check == null) {
      prefs.setBool(Constants.isLogIn, false);
      return false;
    } else if (check == false) {
      return false;
    } else {
      return true;
    }
  }

  Future<String> getUser() async {
    return (await _firebaseAuth.currentUser()).displayName;
  }

  // Login User
  Future<void> logInWith(String email, String password) async {
    LogInUser tmplogInUser = LogInUser();
    await apiBaseHelper.post(Constants.BASE_URL + Constants.LOGIN_URL, {
      'email': '$email',
      'password': '$password',
      'lang': Constants.selectedLang,
      'device_type': Platform.isIOS ? 'ios' : 'android',
      'device_token': Constants.deviceUUID,
    }).then((logInUser) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(
          Constants.aquaUserData, json.encode(LogInUser.fromJson(logInUser)));
      if (LogInUser.fromJson(logInUser).message == 'success') {
        prefs.setBool(Constants.isLogIn, true);
        Constants.isSignIN = true;
      } else {
        prefs.setBool(Constants.isLogIn, false);
      }
      return LogInUser.fromJson(logInUser);
    }).catchError((onError) {
      return tmplogInUser;
    });
  }

  // Login User
  Future<void> signUpWith(
    String firstName,
    String lastName,
    String email,
    String password,
    String mobile,
    int countryId,
  ) async {
    LogInUser tmplogInUser = LogInUser();
    await apiBaseHelper.post(Constants.BASE_URL + Constants.REGISTER_URL, {
      'first_name': '$firstName',
      'last_name': '$lastName',
      'email': '$email',
      'password': '$password',
      'phone': '$mobile',
      'country_id': '$countryId',
      'lang': Constants.selectedLang,
      'device_type': Platform.isIOS ? 'ios' : 'android',
      'device_token': Constants.deviceUUID,
    }).then((logInUser) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(
          Constants.aquaUserData, json.encode(LogInUser.fromJson(logInUser)));
      if (LogInUser.fromJson(logInUser).message == 'success') {
        prefs.setBool(Constants.isLogIn, true);
        Constants.isSignIN = true;
      } else {
        prefs.setBool(Constants.isLogIn, false);
      }
      return LogInUser.fromJson(logInUser);
    }).catchError((onError) {
      return tmplogInUser;
    });
  }

  Future<Map<String, dynamic>> getAquaUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(Constants.isLogIn)) {
      var userData = json.decode(prefs.getString(Constants.aquaUserData)) ??
          Map<String, dynamic>();
      if (userData['data']['user_name'] != null) {
        return userData;
      } else {
        return Map<String, dynamic>();
      }
    } else {
      return Map<String, dynamic>();
    }
  }

  Future<String> getAquaUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(Constants.isLogIn)) {
      var userData = json.decode(prefs.getString(Constants.aquaUserData)) ??
          Map<String, dynamic>();
      if (userData['data']['user_id'] != null) {
        return userData['data']['user_id'];
      } else {
        return '';
      }
    } else {
      return '';
    }
  }

  Future<String> aqariSignOut() async {
    Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(Constants.isLogIn, false);
    prefs.setString(Constants.aquaUserData, null);
    Constants.isSignIN = false;

    return 'NAME';
  }

  List searchCountryFromList(List<Country> list, int countryId) {
    Country selectedCountry;
    var newSearchItemList = list.where((item) => item.countryId == countryId);
    if (newSearchItemList.length > 0) {
      selectedCountry = newSearchItemList.first;
      return [newSearchItemList.first.countryName, selectedCountry];
    } else {
      return ['', null];
    }
  }

  Future<dynamic> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(Constants.isLogIn)) {
      var userData = json.decode(prefs.getString(Constants.aquaUserData)) ??
          Map<String, dynamic>();
      if (userData['data']['user_api_access_token'] != null) {
        return userData;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  // Update User profile
  Future<void> updateUserProfile(
    String firstName,
    String lastName,
    String email,
    int mobile,
    int countryId,
    int userId,
    String accessToken,
    String area,
    String block,
    String street,
    String house,
    String address,
  ) async {
    LogInUser tmplogInUser = LogInUser();
    await apiBaseHelper.post(Constants.BASE_URL + Constants.USER_PROFILE, {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'mobile': mobile,
      'country_id': countryId,
      'user_id': userId,
      'access_token': accessToken,
      'area': area,
      'block': block,
      'street': street,
      'house': house,
      'address': address,
      'lang': Constants.selectedLang,
      'device_type': Platform.isIOS ? 'ios' : 'android',
      'device_token': Constants.deviceUUID,
    }).then((logInUser) async {
      print(logInUser.toString());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(
          Constants.aquaUserData, json.encode(LogInUser.fromJson(logInUser)));
      if (LogInUser.fromJson(logInUser).message == 'success') {
        prefs.setBool(Constants.isLogIn, true);
        Constants.isSignIN = true;
      } else {
        prefs.setBool(Constants.isLogIn, false);
      }
      return LogInUser.fromJson(logInUser);
    }).catchError((onError) {
      return tmplogInUser;
    });
  }

  // Update User profile
  Future<void> changePassword(
    String oldPassword,
    String newPassword,
    String accessToken,
    int userId,
  ) async {
    LogInUser tmplogInUser = LogInUser();
    await apiBaseHelper.post(Constants.BASE_URL + Constants.CHANGE_PASSWORD, {
      'user_id': userId,
      'access_token': accessToken,
      'old_password': oldPassword,
      'new_password': newPassword,
      'lang': Constants.selectedLang,
      'device_type': Platform.isIOS ? 'ios' : 'android',
      'device_token': Constants.deviceUUID,
    }).then((logInUser) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(
          Constants.aquaUserData, json.encode(LogInUser.fromJson(logInUser)));
      if (LogInUser.fromJson(logInUser).message == 'success') {
        prefs.setBool(Constants.isLogIn, true);
        Constants.isSignIN = true;
      } else {
        prefs.setBool(Constants.isLogIn, false);
      }
      return LogInUser.fromJson(logInUser);
    }).catchError((onError) {
      return tmplogInUser;
    });
  }

  // Sending email
  Future<Map<String, dynamic>> mailSent(
    String emailId,
  ) async {
    final emailsentData = await apiBaseHelper
        .post(Constants.BASE_URL + Constants.VERIFY_SENT_EMAIL, {
      'email': emailId,
      'lang': Constants.selectedLang,
      'device_type': Platform.isIOS ? 'ios' : 'android',
      'device_token': Constants.deviceUUID,
    });
    return emailsentData;
  }

  // Sending email
  Future<Map<String, dynamic>> resetPassword(
    String verifyCode,
    String newPassword,
  ) async {
    final result = await apiBaseHelper
        .post(Constants.BASE_URL + Constants.RESET_PASSWORD, {
      'verify_code': verifyCode,
      'new_password': newPassword,
      'lang': Constants.selectedLang,
      'device_type': Platform.isIOS ? 'ios' : 'android',
      'device_token': Constants.deviceUUID,
    });

    // }).then((logInUser) async {
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   prefs.setString(
    //       Constants.aquaUserData, json.encode(LogInUser.fromJson(logInUser)));
    //   if (LogInUser.fromJson(logInUser).message == 'success') {
    //     prefs.setBool(Constants.isLogIn, true);
    //     Constants.isSignIN = true;
    //   } else {
    //     prefs.setBool(Constants.isLogIn, false);
    //   }
    //   return LogInUser.fromJson(logInUser);
    // }).catchError((onError) {
    //   return tmplogInUser;
    // });
    return result;
  }
}

class AppleSignInAvailable {
  AppleSignInAvailable(this.isAvailable);
  final bool isAvailable;

  static Future<AppleSignInAvailable> check() async {
    return AppleSignInAvailable(await AppleSignIn.isAvailable());
  }
}
