import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonEnum(alwaysCreate: true)
enum UserRole {
  @JsonValue('ADMIN')
  admin,
  @JsonValue('ORG_ADMIN')
  orgAdmin,
  @JsonValue('MEMBER')
  member,
  @JsonValue('VERIFIER')
  verifier,
}

@JsonSerializable()
class UserModel extends Equatable {
  final String id;
  final String email;
  final UserRole role;
  final String? orgId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.role,
    this.orgId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List<Object?> get props => [id, email, role, orgId, createdAt, updatedAt];
}
