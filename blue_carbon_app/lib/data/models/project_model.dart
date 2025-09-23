import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'project_model.g.dart';

enum ProjectStatus { draft, approved }

@JsonSerializable()
class ProjectModel extends Equatable {
  final String id;
  final String orgId;
  final String name;
  final String type;
  final double areaHa;
  final ProjectStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProjectModel({
    required this.id,
    required this.orgId,
    required this.name,
    required this.type,
    required this.areaHa,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) => _$ProjectModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectModelToJson(this);

  @override
  List<Object?> get props => [id, orgId, name, type, areaHa, status, createdAt, updatedAt];
}
