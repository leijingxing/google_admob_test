// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spot_inspection_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpotInspectionItemModel _$SpotInspectionItemModelFromJson(
  Map<String, dynamic> json,
) => SpotInspectionItemModel(
  id: const NullableStringSafeConverter().fromJson(json['id']),
  reservationId: const NullableStringSafeConverter().fromJson(
    json['reservationId'],
  ),
  carNumb: const NullableStringSafeConverter().fromJson(json['carNumb']),
  checkTemplateName: const NullableStringSafeConverter().fromJson(
    json['checkTemplateName'],
  ),
  securityCheckTime: const NullableStringSafeConverter().fromJson(
    json['securityCheckTime'],
  ),
  createBy: const NullableStringSafeConverter().fromJson(json['createBy']),
  securityCheckResults: const NullableStringSafeConverter().fromJson(
    json['securityCheckResults'],
  ),
  goodsTypeName: const NullableStringSafeConverter().fromJson(
    json['goodsTypeName'],
  ),
  goodsName: const NullableStringSafeConverter().fromJson(json['goodsName']),
  estimatedInTime: const NullableStringSafeConverter().fromJson(
    json['estimatedInTime'],
  ),
  reservationTime: const NullableStringSafeConverter().fromJson(
    json['reservationTime'],
  ),
  parkStatus: const NullableStringSafeConverter().fromJson(json['parkStatus']),
  parkStatusName: const NullableStringSafeConverter().fromJson(
    json['parkStatusName'],
  ),
);

Map<String, dynamic> _$SpotInspectionItemModelToJson(
  SpotInspectionItemModel instance,
) => <String, dynamic>{
  'id': const NullableStringSafeConverter().toJson(instance.id),
  'reservationId': const NullableStringSafeConverter().toJson(
    instance.reservationId,
  ),
  'carNumb': const NullableStringSafeConverter().toJson(instance.carNumb),
  'checkTemplateName': const NullableStringSafeConverter().toJson(
    instance.checkTemplateName,
  ),
  'securityCheckTime': const NullableStringSafeConverter().toJson(
    instance.securityCheckTime,
  ),
  'createBy': const NullableStringSafeConverter().toJson(instance.createBy),
  'securityCheckResults': const NullableStringSafeConverter().toJson(
    instance.securityCheckResults,
  ),
  'goodsTypeName': const NullableStringSafeConverter().toJson(
    instance.goodsTypeName,
  ),
  'goodsName': const NullableStringSafeConverter().toJson(instance.goodsName),
  'estimatedInTime': const NullableStringSafeConverter().toJson(
    instance.estimatedInTime,
  ),
  'reservationTime': const NullableStringSafeConverter().toJson(
    instance.reservationTime,
  ),
  'parkStatus': const NullableStringSafeConverter().toJson(instance.parkStatus),
  'parkStatusName': const NullableStringSafeConverter().toJson(
    instance.parkStatusName,
  ),
};
