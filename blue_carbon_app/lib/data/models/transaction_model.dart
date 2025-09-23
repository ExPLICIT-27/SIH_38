import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_model.g.dart';

@JsonEnum(alwaysCreate: true)
enum TransactionType {
  @JsonValue('CREDIT')
  credit,
  @JsonValue('DEBIT')
  debit,
}

@JsonSerializable()
class TransactionModel extends Equatable {
  final String id;
  final String orgId;
  final double amount;
  final TransactionType type;
  final String description;
  final String? referenceId;
  final DateTime timestamp;

  const TransactionModel({
    required this.id,
    required this.orgId,
    required this.amount,
    required this.type,
    required this.description,
    this.referenceId,
    required this.timestamp,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);

  @override
  List<Object?> get props => [id, orgId, amount, type, description, referenceId, timestamp];
}
