// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_abnormal_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InspectionAbnormalItemModel _$InspectionAbnormalItemModelFromJson(
  Map<String, dynamic> json,
) => InspectionAbnormalItemModel(
  id: const NullableStringSafeConverter().fromJson(json['id']),
  pointId: const NullableStringSafeConverter().fromJson(json['pointId']),
  pointName: const NullableStringSafeConverter().fromJson(json['pointName']),
  ruleId: const NullableStringSafeConverter().fromJson(json['ruleId']),
  ruleName: const NullableStringSafeConverter().fromJson(json['ruleName']),
  reporterId: const NullableStringSafeConverter().fromJson(json['reporterId']),
  reporterName: const NullableStringSafeConverter().fromJson(
    json['reporterName'],
  ),
  abnormalDesc: const NullableStringSafeConverter().fromJson(
    json['abnormalDesc'],
  ),
  photoUrls: const NullableStringListSafeConverter().fromJson(
    json['photoUrls'],
  ),
  isUrgent: const NullableStringSafeConverter().fromJson(json['isUrgent']),
  abnormalStatus: const NullableStringSafeConverter().fromJson(
    json['abnormalStatus'],
  ),
  reportTime: const NullableStringSafeConverter().fromJson(json['reportTime']),
  responsibleType: const NullableStringSafeConverter().fromJson(
    json['responsibleType'],
  ),
  responsibleName: const NullableStringSafeConverter().fromJson(
    json['responsibleName'],
  ),
);

Map<String, dynamic> _$InspectionAbnormalItemModelToJson(
  InspectionAbnormalItemModel instance,
) => <String, dynamic>{
  'id': const NullableStringSafeConverter().toJson(instance.id),
  'pointId': const NullableStringSafeConverter().toJson(instance.pointId),
  'pointName': const NullableStringSafeConverter().toJson(instance.pointName),
  'ruleId': const NullableStringSafeConverter().toJson(instance.ruleId),
  'ruleName': const NullableStringSafeConverter().toJson(instance.ruleName),
  'reporterId': const NullableStringSafeConverter().toJson(instance.reporterId),
  'reporterName': const NullableStringSafeConverter().toJson(
    instance.reporterName,
  ),
  'abnormalDesc': const NullableStringSafeConverter().toJson(
    instance.abnormalDesc,
  ),
  'photoUrls': const NullableStringListSafeConverter().toJson(
    instance.photoUrls,
  ),
  'isUrgent': const NullableStringSafeConverter().toJson(instance.isUrgent),
  'abnormalStatus': const NullableStringSafeConverter().toJson(
    instance.abnormalStatus,
  ),
  'reportTime': const NullableStringSafeConverter().toJson(instance.reportTime),
  'responsibleType': const NullableStringSafeConverter().toJson(
    instance.responsibleType,
  ),
  'responsibleName': const NullableStringSafeConverter().toJson(
    instance.responsibleName,
  ),
};
