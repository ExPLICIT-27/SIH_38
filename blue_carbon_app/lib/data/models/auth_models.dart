import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:blue_carbon_app/data/models/user_model.dart';

part 'auth_models.g.dart';

@JsonSerializable()
class LoginRequest extends Equatable {
  final String email;
  final String code;

  const LoginRequest({required this.email, required this.code});

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);

  @override
  List<Object?> get props => [email, code];
}

@JsonSerializable()
class SignupRequest extends Equatable {
  final String email;
  final String code;
  final String name;

  const SignupRequest({required this.email, required this.code, required this.name});

  factory SignupRequest.fromJson(Map<String, dynamic> json) => _$SignupRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SignupRequestToJson(this);

  @override
  List<Object?> get props => [email, code, name];
}

@JsonSerializable()
class RequestOtpRequest extends Equatable {
  final String email;

  const RequestOtpRequest({required this.email});

  factory RequestOtpRequest.fromJson(Map<String, dynamic> json) => _$RequestOtpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RequestOtpRequestToJson(this);

  @override
  List<Object?> get props => [email];
}

@JsonSerializable()
class AuthResponse extends Equatable {
  final String accessToken;
  final UserModel user;

  const AuthResponse({required this.accessToken, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);

  @override
  List<Object?> get props => [accessToken, user];
}
