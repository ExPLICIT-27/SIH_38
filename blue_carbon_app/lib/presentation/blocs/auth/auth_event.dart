part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class RequestOtpEvent extends AuthEvent {
  final String email;

  const RequestOtpEvent(this.email);

  @override
  List<Object?> get props => [email];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String code;

  const LoginEvent(this.email, this.code);

  @override
  List<Object?> get props => [email, code];
}

class SignupEvent extends AuthEvent {
  final String email;
  final String code;
  final String name;

  const SignupEvent(this.email, this.code, this.name);

  @override
  List<Object?> get props => [email, code, name];
}

class LogoutEvent extends AuthEvent {}
