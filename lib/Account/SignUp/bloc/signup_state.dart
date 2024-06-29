// @dart=2.9
part of 'signup_bloc.dart';

@immutable
class SignupState {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isPhoneValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final LogInUser logInUser;
  final String infoMessage;

  bool get isFormValid => isEmailValid && isPasswordValid && isPhoneValid;

  SignupState({
    @required this.logInUser,
    @required this.isEmailValid,
    @required this.isPasswordValid,
    @required this.isPhoneValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
    @required this.infoMessage,
  });

  factory SignupState.empty() {
    return SignupState(
      isEmailValid: false,
      isPasswordValid: false,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      logInUser: LogInUser(),
      infoMessage: '',
      isPhoneValid: true,
    );
  }

  factory SignupState.loading(String infoMsg) {
    return SignupState(
      isEmailValid: false,
      isPasswordValid: false,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
      logInUser: LogInUser(),
      infoMessage: infoMsg,
      isPhoneValid: true,
    );
  }

  factory SignupState.failure(String infoMsg) {
    return SignupState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      logInUser: null,
      infoMessage: infoMsg,
      isPhoneValid: true,
    );
  }

  factory SignupState.success(String infoMsg) {
    return SignupState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
      logInUser: LogInUser(),
      infoMessage: infoMsg,
      isPhoneValid: true,
    );
  }

  SignupState update(
      {bool isEmailValid,
      bool isPasswordValid,
      bool isPhoneValid,
      String infoMessage}) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isPhoneValid: isPhoneValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      logInUser: LogInUser(),
      infoMessage: infoMessage,
    );
  }

  SignupState copyWith({
    bool isEmailValid,
    bool isPasswordValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
    bool isPhoneValid,
    LogInUser logInUser,
    String infoMessage,
  }) {
    return SignupState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      infoMessage: this.infoMessage ?? '',
      logInUser: this.logInUser ?? LogInUser(),
      isPhoneValid: this.isPhoneValid,
    );
  }

  @override
  String toString() {
    return '''SignupState {
      isEmailValid: $isEmailValid,
      isPasswordValid: $isPasswordValid,      
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}
