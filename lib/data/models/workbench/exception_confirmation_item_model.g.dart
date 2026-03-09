// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exception_confirmation_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExceptionConfirmationItemModel _$ExceptionConfirmationItemModelFromJson(
  Map<String, dynamic> json,
) => ExceptionConfirmationItemModel(
  id: const NullableStringSafeConverter().fromJson(json['id']),
  reportUserName: const NullableStringSafeConverter().fromJson(
    json['reportUserName'],
  ),
  reportTime: const NullableStringSafeConverter().fromJson(json['reportTime']),
  exceptionLocation: const NullableStringSafeConverter().fromJson(
    json['exceptionLocation'],
  ),
  locationData: const NullableStringSafeConverter().fromJson(
    json['locationData'],
  ),
  exceptionDesc: const NullableStringSafeConverter().fromJson(
    json['exceptionDesc'],
  ),
  exceptionImage: const NullableStringListSafeConverter().fromJson(
    json['exceptionImage'],
  ),
  confirmerId: const NullableStringSafeConverter().fromJson(
    json['confirmerId'],
  ),
  confirmerName: const NullableStringSafeConverter().fromJson(
    json['confirmerName'],
  ),
  confirmerTime: const NullableStringSafeConverter().fromJson(
    json['confirmerTime'],
  ),
  isValid: json['isValid'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['isValid']),
  confirmStatus: json['confirmStatus'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['confirmStatus']),
  remark: const NullableStringSafeConverter().fromJson(json['remark']),
);

Map<String, dynamic> _$ExceptionConfirmationItemModelToJson(
  ExceptionConfirmationItemModel instance,
) => <String, dynamic>{
  'id': const NullableStringSafeConverter().toJson(instance.id),
  'reportUserName': const NullableStringSafeConverter().toJson(
    instance.reportUserName,
  ),
  'reportTime': const NullableStringSafeConverter().toJson(instance.reportTime),
  'exceptionLocation': const NullableStringSafeConverter().toJson(
    instance.exceptionLocation,
  ),
  'locationData': const NullableStringSafeConverter().toJson(
    instance.locationData,
  ),
  'exceptionDesc': const NullableStringSafeConverter().toJson(
    instance.exceptionDesc,
  ),
  'exceptionImage': const NullableStringListSafeConverter().toJson(
    instance.exceptionImage,
  ),
  'confirmerId': const NullableStringSafeConverter().toJson(
    instance.confirmerId,
  ),
  'confirmerName': const NullableStringSafeConverter().toJson(
    instance.confirmerName,
  ),
  'confirmerTime': const NullableStringSafeConverter().toJson(
    instance.confirmerTime,
  ),
  'isValid': const IntSafeConverter().toJson(instance.isValid),
  'confirmStatus': const IntSafeConverter().toJson(instance.confirmStatus),
  'remark': const NullableStringSafeConverter().toJson(instance.remark),
};
