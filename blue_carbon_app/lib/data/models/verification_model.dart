import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verification_model.g.dart';

@JsonSerializable()
class VerificationModel extends Equatable {
  final String id;
  final String uploadId;
  final bool approved;
  final String? notes;
  final String? anchoredTx;
  final DateTime createdAt;

  const VerificationModel({
    required this.id,
    required this.uploadId,
    required this.approved,
    this.notes,
    this.anchoredTx,
    required this.createdAt,
  });

  factory VerificationModel.fromJson(Map<String, dynamic> json) => _$VerificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$VerificationModelToJson(this);

  @override
  List<Object?> get props => [id, uploadId, approved, notes, anchoredTx, createdAt];
}
