// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerificationModel _$VerificationModelFromJson(Map<String, dynamic> json) =>
    VerificationModel(
      id: json['id'] as String,
      uploadId: json['uploadId'] as String,
      approved: json['approved'] as bool,
      notes: json['notes'] as String?,
      anchoredTx: json['anchoredTx'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$VerificationModelToJson(VerificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uploadId': instance.uploadId,
      'approved': instance.approved,
      'notes': instance.notes,
      'anchoredTx': instance.anchoredTx,
      'createdAt': instance.createdAt.toIso8601String(),
    };
