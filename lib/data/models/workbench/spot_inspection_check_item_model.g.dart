// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spot_inspection_check_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpotInspectionCheckItemModel _$SpotInspectionCheckItemModelFromJson(
  Map<String, dynamic> json,
) => SpotInspectionCheckItemModel(
  id: const NullableStringSafeConverter().fromJson(json['id']),
  checkItemId: const NullableStringSafeConverter().fromJson(
    json['checkItemId'],
  ),
  checkItemName: const NullableStringSafeConverter().fromJson(
    json['checkItemName'],
  ),
  checkDescribe: const NullableStringSafeConverter().fromJson(
    json['checkDescribe'],
  ),
  createDate: const NullableStringSafeConverter().fromJson(json['createDate']),
  checkFile: const NullableStringSafeConverter().fromJson(json['checkFile']),
  remark: const NullableStringSafeConverter().fromJson(json['remark']),
  checkStatus: const NullableStringSafeConverter().fromJson(
    json['checkStatus'],
  ),
  isConformity: const NullableStringSafeConverter().fromJson(
    json['isConformity'],
  ),
);

Map<String, dynamic> _$SpotInspectionCheckItemModelToJson(
  SpotInspectionCheckItemModel instance,
) => <String, dynamic>{
  'id': const NullableStringSafeConverter().toJson(instance.id),
  'checkItemId': const NullableStringSafeConverter().toJson(
    instance.checkItemId,
  ),
  'checkItemName': const NullableStringSafeConverter().toJson(
    instance.checkItemName,
  ),
  'checkDescribe': const NullableStringSafeConverter().toJson(
    instance.checkDescribe,
  ),
  'createDate': const NullableStringSafeConverter().toJson(instance.createDate),
  'checkFile': const NullableStringSafeConverter().toJson(instance.checkFile),
  'remark': const NullableStringSafeConverter().toJson(instance.remark),
  'checkStatus': const NullableStringSafeConverter().toJson(
    instance.checkStatus,
  ),
  'isConformity': const NullableStringSafeConverter().toJson(
    instance.isConformity,
  ),
};
