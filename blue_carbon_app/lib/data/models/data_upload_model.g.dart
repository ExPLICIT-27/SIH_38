// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_upload_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataUploadModel _$DataUploadModelFromJson(Map<String, dynamic> json) => DataUploadModel(
      id: json['id'] as String,
      userId: json['userId'] as String?,
      fileName: json['fileName'] as String,
      storagePath: json['storagePath'] as String,
      sha256: json['sha256'] as String,
      size: (json['size'] as num).toInt(),
      capturedAt: json['capturedAt'] == null ? null : DateTime.parse(json['capturedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
      cid: json['cid'] as String?,
      status: $enumDecode(_$UploadStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$DataUploadModelToJson(DataUploadModel instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'fileName': instance.fileName,
      'storagePath': instance.storagePath,
      'sha256': instance.sha256,
      'size': instance.size,
      'capturedAt': instance.capturedAt?.toIso8601String(),
      'metadata': instance.metadata,
      'cid': instance.cid,
      'status': _$UploadStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$UploadStatusEnumMap = {
  UploadStatus.pending: 'PENDING',
  UploadStatus.pinned: 'PINNED',
  UploadStatus.failed: 'FAILED',
};
