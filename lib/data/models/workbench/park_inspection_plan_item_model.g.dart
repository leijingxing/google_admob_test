// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'park_inspection_plan_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParkInspectionPlanItemModel _$ParkInspectionPlanItemModelFromJson(
  Map<String, dynamic> json,
) => ParkInspectionPlanItemModel(
  id: const NullableStringSafeConverter().fromJson(json['id']),
  planCode: const NullableStringSafeConverter().fromJson(json['planCode']),
  planName: const NullableStringSafeConverter().fromJson(json['planName']),
  configStatus: const NullableStringSafeConverter().fromJson(
    json['configStatus'],
  ),
  status: const NullableStringSafeConverter().fromJson(json['status']),
  typeCode: const NullableStringSafeConverter().fromJson(json['typeCode']),
  isMultiPerson: const NullableStringSafeConverter().fromJson(
    json['isMultiPerson'],
  ),
  multiPersonMode: const NullableStringSafeConverter().fromJson(
    json['multiPersonMode'],
  ),
  remark: const NullableStringSafeConverter().fromJson(json['remark']),
);

Map<String, dynamic> _$ParkInspectionPlanItemModelToJson(
  ParkInspectionPlanItemModel instance,
) => <String, dynamic>{
  'id': const NullableStringSafeConverter().toJson(instance.id),
  'planCode': const NullableStringSafeConverter().toJson(instance.planCode),
  'planName': const NullableStringSafeConverter().toJson(instance.planName),
  'configStatus': const NullableStringSafeConverter().toJson(
    instance.configStatus,
  ),
  'status': const NullableStringSafeConverter().toJson(instance.status),
  'typeCode': const NullableStringSafeConverter().toJson(instance.typeCode),
  'isMultiPerson': const NullableStringSafeConverter().toJson(
    instance.isMultiPerson,
  ),
  'multiPersonMode': const NullableStringSafeConverter().toJson(
    instance.multiPersonMode,
  ),
  'remark': const NullableStringSafeConverter().toJson(instance.remark),
};
