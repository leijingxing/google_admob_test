import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'park_inspection_task_record_model.g.dart';

/// 园区巡检任务下的巡检记录模型。
@JsonSerializable()
class ParkInspectionTaskRecordModel {
  @NullableStringSafeConverter()
  final String? id;

  @NullableStringSafeConverter()
  final String? taskId;

  @NullableStringSafeConverter()
  final String? pointId;

  @NullableStringSafeConverter()
  final String? pointName;

  @NullableStringSafeConverter()
  final String? executorId;

  @NullableStringSafeConverter()
  final String? executorName;

  @NullableStringSafeConverter()
  final String? checkTime;

  @NullableStringSafeConverter()
  final String? position;

  @NullableStringSafeConverter()
  final String? resultStatus;

  @NullableStringSafeConverter()
  final String? remark;

  const ParkInspectionTaskRecordModel({
    this.id,
    this.taskId,
    this.pointId,
    this.pointName,
    this.executorId,
    this.executorName,
    this.checkTime,
    this.position,
    this.resultStatus,
    this.remark,
  });

  factory ParkInspectionTaskRecordModel.fromJson(Map<String, dynamic> json) =>
      _$ParkInspectionTaskRecordModelFromJson(json);

  Map<String, dynamic> toJson() => _$ParkInspectionTaskRecordModelToJson(this);
}
