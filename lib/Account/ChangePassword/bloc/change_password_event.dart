// @dart=2.9
part of 'change_password_bloc.dart';

abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();
}

class ChangePwd extends ChangePasswordEvent {
  final String password;

  const ChangePwd({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'EmailChanged { email :$password }';
}

class ChangeConfirmPwd extends ChangePasswordEvent {
  final String password;
  final String confirmPassword;

  const ChangeConfirmPwd(
      {@required this.password, @required this.confirmPassword});

  @override
  List<Object> get props => [confirmPassword];

  @override
  String toString() => 'EmailChanged { email :$confirmPassword }';
}

class PasswordUpdatepressed extends ChangePasswordEvent {
  final String accessToken;
  final int userId;
  final String oldpassword;
  final String newPassword;

  const PasswordUpdatepressed({
    @required this.accessToken,
    @required this.userId,
    @required this.oldpassword,
    @required this.newPassword,
  });

  @override
  List<Object> get props => [accessToken, userId, oldpassword, newPassword];

  @override
  String toString() => 'EmailChanged { email : }';
}
