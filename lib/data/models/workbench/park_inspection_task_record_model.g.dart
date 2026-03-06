// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'park_inspection_task_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParkInspectionTaskRecordModel _$ParkInspectionTaskRecordModelFromJson(
  Map<String, dynamic> json,
) => ParkInspectionTaskRecordModel(
  id: const NullableStringSafeConverter().fromJson(json['id']),
  taskId: const NullableStringSafeConverter().fromJson(json['taskId']),
  pointId: const NullableStringSafeConverter().fromJson(json['pointId']),
  pointName: const NullableStringSafeConverter().fromJson(json['pointName']),
  executorId: const NullableStringSafeConverter().fromJson(json['executorId']),
  executorName: const NullableStringSafeConverter().fromJson(
    json['executorName'],
  ),
  checkTime: const NullableStringSafeConverter().fromJson(json['checkTime']),
  position: const NullableStringSafeConverter().fromJson(json['position']),
  resultStatus: const NullableStringSafeConverter().fromJson(
    json['resultStatus'],
  ),
  remark: const NullableStringSafeConverter().fromJson(json['remark']),
);

Map<String, dynamic> _$ParkInspectionTaskRecordModelToJson(
  ParkInspectionTaskRecordModel instance,
) => <String, dynamic>{
  'id': const NullableStringSafeConverter().toJson(instance.id),
  'taskId': const NullableStringSafeConverter().toJson(instance.taskId),
  'pointId': const NullableStringSafeConverter().toJson(instance.pointId),
  'pointName': const NullableStringSafeConverter().toJson(instance.pointName),
  'executorId': const NullableStringSafeConverter().toJson(instance.executorId),
  'executorName': const NullableStringSafeConverter().toJson(
    instance.executorName,
  ),
  'checkTime': const NullableStringSafeConverter().toJson(instance.checkTime),
  'position': const NullableStringSafeConverter().toJson(instance.position),
  'resultStatus': const NullableStringSafeConverter().toJson(
    instance.resultStatus,
  ),
  'remark': const NullableStringSafeConverter().toJson(instance.remark),
};
