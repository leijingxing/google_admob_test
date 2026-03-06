// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'park_inspection_rule_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParkInspectionRuleItemModel _$ParkInspectionRuleItemModelFromJson(
  Map<String, dynamic> json,
) => ParkInspectionRuleItemModel(
  id: const NullableStringSafeConverter().fromJson(json['id']),
  ruleId: const NullableStringSafeConverter().fromJson(json['ruleId']),
  ruleName: const NullableStringSafeConverter().fromJson(json['ruleName']),
  checkStandard: const NullableStringSafeConverter().fromJson(
    json['checkStandard'],
  ),
  checkMethod: const NullableStringSafeConverter().fromJson(
    json['checkMethod'],
  ),
);

Map<String, dynamic> _$ParkInspectionRuleItemModelToJson(
  ParkInspectionRuleItemModel instance,
) => <String, dynamic>{
  'id': const NullableStringSafeConverter().toJson(instance.id),
  'ruleId': const NullableStringSafeConverter().toJson(instance.ruleId),
  'ruleName': const NullableStringSafeConverter().toJson(instance.ruleName),
  'checkStandard': const NullableStringSafeConverter().toJson(
    instance.checkStandard,
  ),
  'checkMethod': const NullableStringSafeConverter().toJson(
    instance.checkMethod,
  ),
};
