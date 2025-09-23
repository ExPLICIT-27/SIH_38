// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      description: json['description'] as String,
      referenceId: json['referenceId'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orgId': instance.orgId,
      'amount': instance.amount,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'description': instance.description,
      'referenceId': instance.referenceId,
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$TransactionTypeEnumMap = {
  TransactionType.credit: 'CREDIT',
  TransactionType.debit: 'DEBIT',
};
