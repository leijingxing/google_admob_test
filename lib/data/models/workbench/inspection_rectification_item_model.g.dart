// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_rectification_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InspectionRectificationItemModel _$InspectionRectificationItemModelFromJson(
  Map<String, dynamic> json,
) => InspectionRectificationItemModel(
  id: const NullableStringSafeConverter().fromJson(json['id']),
  abnormalId: const NullableStringSafeConverter().fromJson(json['abnormalId']),
  rectifyType: const NullableStringSafeConverter().fromJson(
    json['rectifyType'],
  ),
  rectifyUserId: const NullableStringSafeConverter().fromJson(
    json['rectifyUserId'],
  ),
  rectifyUserName: const NullableStringSafeConverter().fromJson(
    json['rectifyUserName'],
  ),
  rectifyDesc: const NullableStringSafeConverter().fromJson(
    json['rectifyDesc'],
  ),
  photoUrls: const NullableStringListSafeConverter().fromJson(
    json['photoUrls'],
  ),
  rectifyTime: const NullableStringSafeConverter().fromJson(
    json['rectifyTime'],
  ),
  verifyResult: const NullableStringSafeConverter().fromJson(
    json['verifyResult'],
  ),
  status: const NullableStringSafeConverter().fromJson(json['status']),
);

Map<String, dynamic> _$InspectionRectificationItemModelToJson(
  InspectionRectificationItemModel instance,
) => <String, dynamic>{
  'id': const NullableStringSafeConverter().toJson(instance.id),
  'abnormalId': const NullableStringSafeConverter().toJson(instance.abnormalId),
  'rectifyType': const NullableStringSafeConverter().toJson(
    instance.rectifyType,
  ),
  'rectifyUserId': const NullableStringSafeConverter().toJson(
    instance.rectifyUserId,
  ),
  'rectifyUserName': const NullableStringSafeConverter().toJson(
    instance.rectifyUserName,
  ),
  'rectifyDesc': const NullableStringSafeConverter().toJson(
    instance.rectifyDesc,
  ),
  'photoUrls': const NullableStringListSafeConverter().toJson(
    instance.photoUrls,
  ),
  'rectifyTime': const NullableStringSafeConverter().toJson(
    instance.rectifyTime,
  ),
  'verifyResult': const NullableStringSafeConverter().toJson(
    instance.verifyResult,
  ),
  'status': const NullableStringSafeConverter().toJson(instance.status),
};
