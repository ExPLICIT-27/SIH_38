// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrganizationModel _$OrganizationModelFromJson(Map<String, dynamic> json) => OrganizationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      mode: $enumDecode(_$OrganizationModeEnumMap, json['mode']),
      walletAddress: json['walletAddress'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$OrganizationModelToJson(OrganizationModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'mode': _$OrganizationModeEnumMap[instance.mode]!,
      'walletAddress': instance.walletAddress,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$OrganizationModeEnumMap = {
  OrganizationMode.seller: 'SELLER',
  OrganizationMode.buyer: 'BUYER',
  OrganizationMode.both: 'BOTH',
};
