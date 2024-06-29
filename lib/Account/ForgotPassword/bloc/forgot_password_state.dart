// @dart=2.9
part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();
}

class ForgotPasswordInitial extends ForgotPasswordState {
  @override
  List<Object> get props => [];
}

class FPMailSentError extends ForgotPasswordState {
  final String errorMessage;

  FPMailSentError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class FPMailSentLoading extends ForgotPasswordState {
  final String loadMessage;

  FPMailSentLoading(this.loadMessage);
  @override
  List<Object> get props => [loadMessage];
}

class FPMailSentLoaded extends ForgotPasswordState {
  final Map<String, dynamic> mailSentData;

  FPMailSentLoaded(this.mailSentData);
  @override
  List<Object> get props => [mailSentData];
}

class FPUpdateLoading extends ForgotPasswordState {
  final String loadMessage;

  FPUpdateLoading(this.loadMessage);
  @override
  List<Object> get props => [loadMessage];
}

class FPUpdateLoaded extends ForgotPasswordState {
  final Map<String, dynamic> userData;

  FPUpdateLoaded(this.userData);

  @override
  List<Object> get props => [userData];
}

class FPUpdateError extends ForgotPasswordState {
  final String errorMessage;

  FPUpdateError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
