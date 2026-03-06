// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'whitelist_approval_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WhitelistApprovalItemModel _$WhitelistApprovalItemModelFromJson(
  Map<String, dynamic> json,
) => WhitelistApprovalItemModel(
  id: const NullableStringSafeConverter().fromJson(json['id']),
  type: json['type'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['type']),
  carNumb: const NullableStringSafeConverter().fromJson(json['carNumb']),
  realName: const NullableStringSafeConverter().fromJson(json['realName']),
  userPhone: const NullableStringSafeConverter().fromJson(json['userPhone']),
  companyName: const NullableStringSafeConverter().fromJson(
    json['companyName'],
  ),
  submitBy: const NullableStringSafeConverter().fromJson(json['submitBy']),
  submitDate: const NullableStringSafeConverter().fromJson(json['submitDate']),
  parkCheckTime: const NullableStringSafeConverter().fromJson(
    json['parkCheckTime'],
  ),
  validityBeginTime: const NullableStringSafeConverter().fromJson(
    json['validityBeginTime'],
  ),
  validityEndTime: const NullableStringSafeConverter().fromJson(
    json['validityEndTime'],
  ),
  parkCheckDesc: const NullableStringSafeConverter().fromJson(
    json['parkCheckDesc'],
  ),
  parkCheckStatus: json['parkCheckStatus'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['parkCheckStatus']),
);

Map<String, dynamic> _$WhitelistApprovalItemModelToJson(
  WhitelistApprovalItemModel instance,
) => <String, dynamic>{
  'id': const NullableStringSafeConverter().toJson(instance.id),
  'type': const IntSafeConverter().toJson(instance.type),
  'carNumb': const NullableStringSafeConverter().toJson(instance.carNumb),
  'realName': const NullableStringSafeConverter().toJson(instance.realName),
  'userPhone': const NullableStringSafeConverter().toJson(instance.userPhone),
  'companyName': const NullableStringSafeConverter().toJson(
    instance.companyName,
  ),
  'submitBy': const NullableStringSafeConverter().toJson(instance.submitBy),
  'submitDate': const NullableStringSafeConverter().toJson(instance.submitDate),
  'parkCheckTime': const NullableStringSafeConverter().toJson(
    instance.parkCheckTime,
  ),
  'validityBeginTime': const NullableStringSafeConverter().toJson(
    instance.validityBeginTime,
  ),
  'validityEndTime': const NullableStringSafeConverter().toJson(
    instance.validityEndTime,
  ),
  'parkCheckDesc': const NullableStringSafeConverter().toJson(
    instance.parkCheckDesc,
  ),
  'parkCheckStatus': const IntSafeConverter().toJson(instance.parkCheckStatus),
};
