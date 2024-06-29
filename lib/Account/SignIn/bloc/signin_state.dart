// @dart=2.9
part of 'signin_bloc.dart';

@immutable
class SigninState {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final LogInUser logInUser;
  final String infoMessage;
  final bool isSocial;
//  final List<String> socialData;

  bool get isFormValid => isEmailValid && isPasswordValid;

  SigninState({
    @required this.logInUser,
    @required this.isEmailValid,
    @required this.isPasswordValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
    @required this.infoMessage,
    @required this.isSocial,
    //   @required this.socialData,
  });

  factory SigninState.empty() {
    return SigninState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      logInUser: LogInUser(),
      infoMessage: '',
      isSocial: false,
      //     socialData: <String>[],
    );
  }

  factory SigninState.loading(String infoMsg) {
    return SigninState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
      logInUser: LogInUser(),
      infoMessage: infoMsg,
      isSocial: false,
      //     socialData: <String>[],
    );
  }

  factory SigninState.failure(String infoMsg) {
    return SigninState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      logInUser: null,
      infoMessage: infoMsg,
      isSocial: false,
      //    socialData: <String>[],
    );
  }

  factory SigninState.success(String infoMsg, bool isSocial) {
    return SigninState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
      logInUser: LogInUser(),
      infoMessage: infoMsg,
      isSocial: isSocial,
      //    socialData: socialData,
    );
  }

  SigninState update({
    bool isEmailValid,
    bool isPasswordValid,
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      logInUser: LogInUser(),
      infoMessage: '',
    );
  }

  SigninState copyWith({
    bool isEmailValid,
    bool isPasswordValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
    LogInUser logInUser,
    String infoMessage,
    bool isSocial,
    //   List<String> socialData,
  }) {
    return SigninState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      infoMessage: this.infoMessage ?? '',
      logInUser: this.logInUser ?? LogInUser(),
      isSocial: isSocial,
      //   socialData: socialData,
    );
  }

  @override
  String toString() {
    return '''LoginState {
      isEmailValid: $isEmailValid,
      isPasswordValid: $isPasswordValid,      
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}
