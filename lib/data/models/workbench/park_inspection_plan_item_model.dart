import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'park_inspection_plan_item_model.g.dart';

/// 园区巡检计划模型。
@JsonSerializable()
class ParkInspectionPlanItemModel {
  @NullableStringSafeConverter()
  final String? id;

  @NullableStringSafeConverter()
  final String? planCode;

  @NullableStringSafeConverter()
  final String? planName;

  @NullableStringSafeConverter()
  final String? configStatus;

  @NullableStringSafeConverter()
  final String? status;

  @NullableStringSafeConverter()
  final String? typeCode;

  @NullableStringSafeConverter()
  final String? isMultiPerson;

  @NullableStringSafeConverter()
  final String? multiPersonMode;

  @NullableStringSafeConverter()
  final String? remark;

  const ParkInspectionPlanItemModel({
    this.id,
    this.planCode,
    this.planName,
    this.configStatus,
    this.status,
    this.typeCode,
    this.isMultiPerson,
    this.multiPersonMode,
    this.remark,
  });

  factory ParkInspectionPlanItemModel.fromJson(Map<String, dynamic> json) =>
      _$ParkInspectionPlanItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ParkInspectionPlanItemModelToJson(this);
}
