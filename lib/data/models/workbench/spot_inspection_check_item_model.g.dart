// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spot_inspection_check_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpotInspectionCheckItemModel _$SpotInspectionCheckItemModelFromJson(
  Map<String, dynamic> json,
) => SpotInspectionCheckItemModel(
  id: const NullableStringSafeConverter().fromJson(json['id']),
  companyId: const NullableStringSafeConverter().fromJson(json['companyId']),
  companyName: const NullableStringSafeConverter().fromJson(
    json['companyName'],
  ),
  securityTemplateId: const NullableStringSafeConverter().fromJson(
    json['securityTemplateId'],
  ),
  checkItemId: const NullableStringSafeConverter().fromJson(
    json['checkItemId'],
  ),
  checkItemName: const NullableStringSafeConverter().fromJson(
    json['checkItemName'],
  ),
  checkItem: const NullableStringSafeConverter().fromJson(json['checkItem']),
  checkDescribe: const NullableStringSafeConverter().fromJson(
    json['checkDescribe'],
  ),
  checkMethod: const NullableStringSafeConverter().fromJson(
    json['checkMethod'],
  ),
  selfCheckingStatus: const NullableStringSafeConverter().fromJson(
    json['selfCheckingStatus'],
  ),
  spotCheckStatus: const NullableStringSafeConverter().fromJson(
    json['spotCheckStatus'],
  ),
  checkItemStatus: const NullableStringSafeConverter().fromJson(
    json['checkItemStatus'],
  ),
  createDate: const NullableStringSafeConverter().fromJson(json['createDate']),
  checkFile: const NullableStringSafeConverter().fromJson(json['checkFile']),
  checkResult: const NullableStringSafeConverter().fromJson(
    json['checkResult'],
  ),
  remark: const NullableStringSafeConverter().fromJson(json['remark']),
  remarks: const NullableStringSafeConverter().fromJson(json['remarks']),
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
  'companyId': const NullableStringSafeConverter().toJson(instance.companyId),
  'companyName': const NullableStringSafeConverter().toJson(
    instance.companyName,
  ),
  'securityTemplateId': const NullableStringSafeConverter().toJson(
    instance.securityTemplateId,
  ),
  'checkItemId': const NullableStringSafeConverter().toJson(
    instance.checkItemId,
  ),
  'checkItemName': const NullableStringSafeConverter().toJson(
    instance.checkItemName,
  ),
  'checkItem': const NullableStringSafeConverter().toJson(instance.checkItem),
  'checkDescribe': const NullableStringSafeConverter().toJson(
    instance.checkDescribe,
  ),
  'checkMethod': const NullableStringSafeConverter().toJson(
    instance.checkMethod,
  ),
  'selfCheckingStatus': const NullableStringSafeConverter().toJson(
    instance.selfCheckingStatus,
  ),
  'spotCheckStatus': const NullableStringSafeConverter().toJson(
    instance.spotCheckStatus,
  ),
  'checkItemStatus': const NullableStringSafeConverter().toJson(
    instance.checkItemStatus,
  ),
  'createDate': const NullableStringSafeConverter().toJson(instance.createDate),
  'checkFile': const NullableStringSafeConverter().toJson(instance.checkFile),
  'checkResult': const NullableStringSafeConverter().toJson(
    instance.checkResult,
  ),
  'remark': const NullableStringSafeConverter().toJson(instance.remark),
  'remarks': const NullableStringSafeConverter().toJson(instance.remarks),
  'checkStatus': const NullableStringSafeConverter().toJson(
    instance.checkStatus,
  ),
  'isConformity': const NullableStringSafeConverter().toJson(
    instance.isConformity,
  ),
};
