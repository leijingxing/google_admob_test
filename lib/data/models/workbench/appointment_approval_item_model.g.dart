// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_approval_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentApprovalItemModel _$AppointmentApprovalItemModelFromJson(
  Map<String, dynamic> json,
) => AppointmentApprovalItemModel(
  id: const NullableStringSafeConverter().fromJson(json['id']),
  reservationType: json['reservationType'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['reservationType']),
  carNumb: const NullableStringSafeConverter().fromJson(json['carNumb']),
  realName: const NullableStringSafeConverter().fromJson(json['realName']),
  parkCheckStatus: json['parkCheckStatus'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['parkCheckStatus']),
  createDate: const NullableStringSafeConverter().fromJson(json['createDate']),
  parkCheckTime: const NullableStringSafeConverter().fromJson(
    json['parkCheckTime'],
  ),
);

Map<String, dynamic> _$AppointmentApprovalItemModelToJson(
  AppointmentApprovalItemModel instance,
) => <String, dynamic>{
  'id': const NullableStringSafeConverter().toJson(instance.id),
  'reservationType': const IntSafeConverter().toJson(instance.reservationType),
  'carNumb': const NullableStringSafeConverter().toJson(instance.carNumb),
  'realName': const NullableStringSafeConverter().toJson(instance.realName),
  'parkCheckStatus': const IntSafeConverter().toJson(instance.parkCheckStatus),
  'createDate': const NullableStringSafeConverter().toJson(instance.createDate),
  'parkCheckTime': const NullableStringSafeConverter().toJson(
    instance.parkCheckTime,
  ),
};
