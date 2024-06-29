// @dart=2.9
part of 'change_password_bloc.dart';

abstract class ChangePasswordState extends Equatable {
  const ChangePasswordState();
}

class ChangePasswordInitial extends ChangePasswordState {
  @override
  List<Object> get props => [];
}

class ValidatePassword extends ChangePasswordState {
  final bool isPasswordValid;

  ValidatePassword(this.isPasswordValid);
  @override
  List<Object> get props => [];
}

class ChangePasswordLoading extends ChangePasswordState {
  ChangePasswordLoading();
  @override
  List<Object> get props => [];
}

class ChangePasswordError extends ChangePasswordState {
  final String errorMessage;

  ChangePasswordError(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}

class ValidateConfirmPassword extends ChangePasswordState {
  final bool isPasswordValid;

  ValidateConfirmPassword(this.isPasswordValid);
  @override
  List<Object> get props => [];
}

class ChangePwdLoaded extends ChangePasswordState {
  final Map<String, dynamic> userData;

  ChangePwdLoaded({@required this.userData});

  List<Object> get props => [userData];
}
