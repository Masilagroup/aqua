// @dart=2.9
part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();
}

class SentMailPressed extends ForgotPasswordEvent {
  final String emailId;

  const SentMailPressed({
    @required this.emailId,
  });

  @override
  List<Object> get props => [emailId];
}

class ResetButtonPressed extends ForgotPasswordEvent {
  final String verificationCode;
  final String newpassword;

  const ResetButtonPressed({
    @required this.verificationCode,
    @required this.newpassword,
  });

  @override
  List<Object> get props => [verificationCode, newpassword];
}
