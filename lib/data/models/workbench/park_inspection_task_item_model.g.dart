// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'park_inspection_task_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParkInspectionTaskItemModel _$ParkInspectionTaskItemModelFromJson(
  Map<String, dynamic> json,
) => ParkInspectionTaskItemModel(
  id: const NullableStringSafeConverter().fromJson(json['id']),
  taskCode: const NullableStringSafeConverter().fromJson(json['taskCode']),
  planId: const NullableStringSafeConverter().fromJson(json['planId']),
  planName: const NullableStringSafeConverter().fromJson(json['planName']),
  dispatchType: const NullableStringSafeConverter().fromJson(
    json['dispatchType'],
  ),
  typeCode: const NullableStringSafeConverter().fromJson(json['typeCode']),
  executorId: const NullableStringSafeConverter().fromJson(json['executorId']),
  executorName: const NullableStringSafeConverter().fromJson(
    json['executorName'],
  ),
  executorNames: const NullableStringSafeConverter().fromJson(
    json['executorNames'],
  ),
  taskDate: const NullableStringSafeConverter().fromJson(json['taskDate']),
  taskStatus: const NullableStringSafeConverter().fromJson(json['taskStatus']),
  resultStatus: const NullableStringSafeConverter().fromJson(
    json['resultStatus'],
  ),
  totalPoints: json['totalPoints'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['totalPoints']),
  completedPoints: json['completedPoints'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['completedPoints']),
  abnormalCount: json['abnormalCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['abnormalCount']),
  remark: const NullableStringSafeConverter().fromJson(json['remark']),
  isMultiPerson: const NullableStringSafeConverter().fromJson(
    json['isMultiPerson'],
  ),
  multiPersonMode: const NullableStringSafeConverter().fromJson(
    json['multiPersonMode'],
  ),
);

Map<String, dynamic> _$ParkInspectionTaskItemModelToJson(
  ParkInspectionTaskItemModel instance,
) => <String, dynamic>{
  'id': const NullableStringSafeConverter().toJson(instance.id),
  'taskCode': const NullableStringSafeConverter().toJson(instance.taskCode),
  'planId': const NullableStringSafeConverter().toJson(instance.planId),
  'planName': const NullableStringSafeConverter().toJson(instance.planName),
  'dispatchType': const NullableStringSafeConverter().toJson(
    instance.dispatchType,
  ),
  'typeCode': const NullableStringSafeConverter().toJson(instance.typeCode),
  'executorId': const NullableStringSafeConverter().toJson(instance.executorId),
  'executorName': const NullableStringSafeConverter().toJson(
    instance.executorName,
  ),
  'executorNames': const NullableStringSafeConverter().toJson(
    instance.executorNames,
  ),
  'taskDate': const NullableStringSafeConverter().toJson(instance.taskDate),
  'taskStatus': const NullableStringSafeConverter().toJson(instance.taskStatus),
  'resultStatus': const NullableStringSafeConverter().toJson(
    instance.resultStatus,
  ),
  'totalPoints': const IntSafeConverter().toJson(instance.totalPoints),
  'completedPoints': const IntSafeConverter().toJson(instance.completedPoints),
  'abnormalCount': const IntSafeConverter().toJson(instance.abnormalCount),
  'remark': const NullableStringSafeConverter().toJson(instance.remark),
  'isMultiPerson': const NullableStringSafeConverter().toJson(
    instance.isMultiPerson,
  ),
  'multiPersonMode': const NullableStringSafeConverter().toJson(
    instance.multiPersonMode,
  ),
};
