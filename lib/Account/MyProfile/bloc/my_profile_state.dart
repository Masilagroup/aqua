// @dart=2.9
part of 'my_profile_bloc.dart';

// @immutable
// class MyProfileState {
//   final bool isEmailValid;
//   final bool isPhoneValid;
//   final bool isSubmitting;
//   final bool isSuccess;
//   final bool isFailure;
//   final LogInUser logInUser;
//   final String infoMessage;
//   final Map<String, dynamic> userData;

//   bool get isFormValid => isEmailValid && isPhoneValid;

//   MyProfileState({
//     @required this.logInUser,
//     @required this.isEmailValid,
//     @required this.isPhoneValid,
//     @required this.isSubmitting,
//     @required this.isSuccess,
//     @required this.isFailure,
//     @required this.infoMessage,
//     @required this.userData,
//   });

//   factory MyProfileState.empty() {
//     return MyProfileState(
//       isEmailValid: true,
//       isSubmitting: false,
//       isSuccess: false,
//       isFailure: false,
//       logInUser: LogInUser(),
//       infoMessage: '',
//       isPhoneValid: true,
//       userData: null,
//     );
//   }

//   factory MyProfileState.loading(String infoMsg) {
//     return MyProfileState(
//       isEmailValid: true,
//       isSubmitting: true,
//       isSuccess: false,
//       isFailure: false,
//       logInUser: LogInUser(),
//       infoMessage: infoMsg,
//       isPhoneValid: true,
//       userData: null,
//     );
//   }

//   factory MyProfileState.failure(String infoMsg) {
//     return MyProfileState(
//       isEmailValid: true,
//       isSubmitting: false,
//       isSuccess: false,
//       isFailure: true,
//       logInUser: null,
//       infoMessage: infoMsg,
//       isPhoneValid: true,
//       userData: null,
//     );
//   }

//   factory MyProfileState.success(String infoMsg) {
//     return MyProfileState(
//       isEmailValid: true,
//       isSubmitting: false,
//       isSuccess: true,
//       isFailure: false,
//       logInUser: LogInUser(),
//       infoMessage: infoMsg,
//       isPhoneValid: true,
//       userData: null,
//     );
//   }

//   MyProfileState update({
//     bool isEmailValid,
//     bool isPhoneValid,
//     Map<String, dynamic> userData,
//   }) {
//     return copyWith(
//       isEmailValid: isEmailValid,
//       isPhoneValid: isPhoneValid,
//       isSubmitting: false,
//       isSuccess: false,
//       isFailure: false,
//       userData: userData,
//       infoMessage: '',
//     );
//   }

//   MyProfileState copyWith({
//     bool isEmailValid,
//     bool isPasswordValid,
//     bool isSubmitEnabled,
//     bool isSubmitting,
//     bool isSuccess,
//     bool isFailure,
//     bool isPhoneValid,
//     LogInUser logInUser,
//     String infoMessage,
//     Map<String, dynamic> userData,
//   }) {
//     return MyProfileState(
//       isEmailValid: isEmailValid ?? this.isEmailValid,
//       isSubmitting: isSubmitting ?? this.isSubmitting,
//       isSuccess: isSuccess ?? this.isSuccess,
//       isFailure: isFailure ?? this.isFailure,
//       infoMessage: this.infoMessage ?? '',
//       logInUser: this.logInUser ?? LogInUser(),
//       isPhoneValid: this.isPhoneValid,
//       userData: this.userData,
//     );
//   }

//   @override
//   String toString() {
//     return '''SignupState {
//       isEmailValid: $isEmailValid,
//       isSubmitting: $isSubmitting,
//       isSuccess: $isSuccess,
//       isFailure: $isFailure,
//     }''';
//   }
// }

abstract class MyProfileState extends Equatable {
  const MyProfileState();

  @override
  List<Object> get props => [];
}

class MyProfileInittial extends MyProfileState {
  final Map<String, dynamic> userData;

  const MyProfileInittial(this.userData);

  @override
  List<Object> get props => [userData];

  @override
  String toString() => 'Authenticated { displayName: }';
}

class MyProfileRetriveUserState extends MyProfileState {
  final Map<String, dynamic> userData;

  const MyProfileRetriveUserState(this.userData);

  @override
  List<Object> get props => [userData];

  @override
  String toString() => 'UserData { displayName: $userData }';
}

class MyProfileError extends MyProfileState {
  final String errorMessage;

  MyProfileError(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}

class MyProfileEmailState extends MyProfileState {
  final bool isEmailValid;

  MyProfileEmailState(this.isEmailValid);
  @override
  List<Object> get props => [isEmailValid];
}

class MyProfilePhoneState extends MyProfileState {
  final bool isPhoneValid;

  MyProfilePhoneState(this.isPhoneValid);
  @override
  List<Object> get props => [isPhoneValid];
}

class MyProfileLoading extends MyProfileState {
  MyProfileLoading();
  @override
  List<Object> get props => [];
}

class MyProfileLoaded extends MyProfileState {
  final Map<String, dynamic> userData;
  final bool isFailure;
  final bool isSubmitting;
  final bool isSuccess;

  MyProfileLoaded(this.isFailure, this.isSubmitting, this.isSuccess,
      {@required this.userData});

  List<Object> get props => [userData];
}
