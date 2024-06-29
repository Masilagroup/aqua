// @dart=2.9
part of 'signin_bloc.dart';

abstract class SigninEvent extends Equatable {
  const SigninEvent();
}

class EmailChanged extends SigninEvent {
  final String email;

  const EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged { email :$email }';
}

class PasswordChanged extends SigninEvent {
  final String password;

  const PasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class Submitted extends SigninEvent {
  final String email;
  final String password;

  const Submitted({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() {
    return 'Submitted { email: $email, password: $password }';
  }
}

class LoginWithCredentialsPressed extends SigninEvent {
  final String email;
  final String password;

  const LoginWithCredentialsPressed({
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

class LoginWithGmail extends SigninEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'Gmail { email : }';
}

class LoginWithFacebook extends SigninEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'Facebook { email : }';
}

class LoginWithApple extends SigninEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'Apple { email : }';
}
