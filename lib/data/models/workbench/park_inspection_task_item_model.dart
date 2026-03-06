import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'park_inspection_task_item_model.g.dart';

/// 园区巡检任务列表项模型。
@JsonSerializable()
class ParkInspectionTaskItemModel {
  @NullableStringSafeConverter()
  final String? id;

  @NullableStringSafeConverter()
  final String? taskCode;

  @NullableStringSafeConverter()
  final String? planId;

  @NullableStringSafeConverter()
  final String? planName;

  @NullableStringSafeConverter()
  final String? dispatchType;

  @NullableStringSafeConverter()
  final String? typeCode;

  @NullableStringSafeConverter()
  final String? executorId;

  @NullableStringSafeConverter()
  final String? executorName;

  @NullableStringSafeConverter()
  final String? executorNames;

  @NullableStringSafeConverter()
  final String? taskDate;

  @NullableStringSafeConverter()
  final String? taskStatus;

  @NullableStringSafeConverter()
  final String? resultStatus;

  @IntSafeConverter()
  final int totalPoints;

  @IntSafeConverter()
  final int completedPoints;

  @IntSafeConverter()
  final int abnormalCount;

  @NullableStringSafeConverter()
  final String? remark;

  @NullableStringSafeConverter()
  final String? isMultiPerson;

  @NullableStringSafeConverter()
  final String? multiPersonMode;

  const ParkInspectionTaskItemModel({
    this.id,
    this.taskCode,
    this.planId,
    this.planName,
    this.dispatchType,
    this.typeCode,
    this.executorId,
    this.executorName,
    this.executorNames,
    this.taskDate,
    this.taskStatus,
    this.resultStatus,
    this.totalPoints = 0,
    this.completedPoints = 0,
    this.abnormalCount = 0,
    this.remark,
    this.isMultiPerson,
    this.multiPersonMode,
  });

  factory ParkInspectionTaskItemModel.fromJson(Map<String, dynamic> json) =>
      _$ParkInspectionTaskItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ParkInspectionTaskItemModelToJson(this);
}
