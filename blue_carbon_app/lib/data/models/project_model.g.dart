// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectModel _$ProjectModelFromJson(Map<String, dynamic> json) => ProjectModel(
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      areaHa: (json['areaHa'] as num).toDouble(),
      status: $enumDecode(_$ProjectStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ProjectModelToJson(ProjectModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orgId': instance.orgId,
      'name': instance.name,
      'type': instance.type,
      'areaHa': instance.areaHa,
      'status': _$ProjectStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ProjectStatusEnumMap = {
  ProjectStatus.draft: 'draft',
  ProjectStatus.approved: 'approved',
};
