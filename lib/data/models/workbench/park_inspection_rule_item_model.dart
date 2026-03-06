import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'park_inspection_rule_item_model.g.dart';

/// 园区巡检细则模型。
@JsonSerializable()
class ParkInspectionRuleItemModel {
  @NullableStringSafeConverter()
  final String? id;

  @NullableStringSafeConverter()
  final String? ruleId;

  @NullableStringSafeConverter()
  final String? ruleName;

  @NullableStringSafeConverter()
  final String? checkStandard;

  @NullableStringSafeConverter()
  final String? checkMethod;

  const ParkInspectionRuleItemModel({
    this.id,
    this.ruleId,
    this.ruleName,
    this.checkStandard,
    this.checkMethod,
  });

  factory ParkInspectionRuleItemModel.fromJson(Map<String, dynamic> json) =>
      _$ParkInspectionRuleItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ParkInspectionRuleItemModelToJson(this);
}
