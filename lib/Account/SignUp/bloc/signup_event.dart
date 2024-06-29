// @dart=2.9
part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();
}

class SignUpEmailChanged extends SignupEvent {
  final String email;

  const SignUpEmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged { email :$email }';
}

class SignUpPasswordChanged extends SignupEvent {
  final String password;

  const SignUpPasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class SignUpNameChanged extends SignupEvent {
  final String name;

  const SignUpNameChanged({@required this.name});

  @override
  List<Object> get props => [name];

  @override
  String toString() => 'NameChanged { Name: $name }';
}

class SignUpConfirmChanged extends SignupEvent {
  final String cPassword;

  const SignUpConfirmChanged({@required this.cPassword});

  @override
  List<Object> get props => [cPassword];

  @override
  String toString() => 'cPassword { confirm password: $cPassword }';
}

class SignUpPhoneChanged extends SignupEvent {
  final String phoneNum;

  const SignUpPhoneChanged({@required this.phoneNum});

  @override
  List<Object> get props => [phoneNum];

  @override
  String toString() => 'PhoneChanged { Name: $phoneNum }';
}

class SignUpCountryChanged extends SignupEvent {
  final int countryId;

  const SignUpCountryChanged({@required this.countryId});

  @override
  List<Object> get props => [countryId];

  @override
  String toString() => 'PhoneChanged { Name: $countryId }';
}

class SignupWithCredentialsPressed extends SignupEvent {
  final String firstname;
  final String lastname;
  final String email;
  final String password;
  final String mobile;
  final int countryId;

  const SignupWithCredentialsPressed({
    @required this.firstname,
    @required this.lastname,
    @required this.mobile,
    @required this.countryId,
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() {
    return 'LoginWithCredentialsPressed { email: $email, password: $password }';
  }
}
