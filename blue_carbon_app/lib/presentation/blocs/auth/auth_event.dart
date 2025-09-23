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
  final Map<String, dynamic>? organizationData;
  final OrganizationModel? selectedOrganization;
  final UserRole selectedRole;

  const SignupEvent(
    this.email,
    this.code,
    this.name, {
    this.organizationData,
    this.selectedOrganization,
    this.selectedRole = UserRole.member,
  });

  @override
  List<Object?> get props => [email, code, name, organizationData, selectedOrganization, selectedRole];
}

class LogoutEvent extends AuthEvent {}
