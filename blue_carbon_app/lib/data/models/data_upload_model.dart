import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'data_upload_model.g.dart';

enum UploadStatus { pending, pinned, failed }

@JsonSerializable()
class DataUploadModel extends Equatable {
  final String id;
  final String? userId;
  final String fileName;
  final String storagePath;
  final String sha256;
  final int size;
  final DateTime? capturedAt;
  final Map<String, dynamic>? metadata;
  final String? cid;
  final UploadStatus status;
  final DateTime createdAt;

  const DataUploadModel({
    required this.id,
    this.userId,
    required this.fileName,
    required this.storagePath,
    required this.sha256,
    required this.size,
    this.capturedAt,
    this.metadata,
    this.cid,
    required this.status,
    required this.createdAt,
  });

  factory DataUploadModel.fromJson(Map<String, dynamic> json) => _$DataUploadModelFromJson(json);

  Map<String, dynamic> toJson() => _$DataUploadModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    userId,
    fileName,
    storagePath,
    sha256,
    size,
    capturedAt,
    metadata,
    cid,
    status,
    createdAt,
  ];
}
