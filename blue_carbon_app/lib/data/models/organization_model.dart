import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'organization_model.g.dart';

enum OrganizationMode { seller, buyer, both }

@JsonSerializable()
class OrganizationModel extends Equatable {
  final String id;
  final String name;
  final String type;
  final OrganizationMode mode;
  final String? walletAddress;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrganizationModel({
    required this.id,
    required this.name,
    required this.type,
    required this.mode,
    this.walletAddress,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) => _$OrganizationModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrganizationModelToJson(this);

  @override
  List<Object?> get props => [id, name, type, mode, walletAddress, createdAt, updatedAt];
}
