// @dart=2.9
part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final Map<String, dynamic> userData;

  const Authenticated(this.userData);

  @override
  List<Object> get props => [userData];

  @override
  String toString() => 'Authenticated { displayName: $userData }';
}

class Unauthenticated extends AuthenticationState {
  final String name;

  const Unauthenticated(this.name);

  @override
  List<Object> get props => [name];
}
