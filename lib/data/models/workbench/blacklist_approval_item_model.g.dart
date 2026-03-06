// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blacklist_approval_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlacklistApprovalItemModel _$BlacklistApprovalItemModelFromJson(
  Map<String, dynamic> json,
) => BlacklistApprovalItemModel(
  id: const NullableStringSafeConverter().fromJson(json['id']),
  type: json['type'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['type']),
  carNumb: const NullableStringSafeConverter().fromJson(json['carNumb']),
  realName: const NullableStringSafeConverter().fromJson(json['realName']),
  userPhone: const NullableStringSafeConverter().fromJson(json['userPhone']),
  createBy: const NullableStringSafeConverter().fromJson(json['createBy']),
  createDate: const NullableStringSafeConverter().fromJson(json['createDate']),
  submitUserPhone: const NullableStringSafeConverter().fromJson(
    json['submitUserPhone'],
  ),
  remark: const NullableStringSafeConverter().fromJson(json['remark']),
  attachment: const NullableStringSafeConverter().fromJson(json['attachment']),
  parkCheckUserName: const NullableStringSafeConverter().fromJson(
    json['parkCheckUserName'],
  ),
  parkCheckUserPhone: const NullableStringSafeConverter().fromJson(
    json['parkCheckUserPhone'],
  ),
  parkCheckTime: const NullableStringSafeConverter().fromJson(
    json['parkCheckTime'],
  ),
  parkCheckDesc: const NullableStringSafeConverter().fromJson(
    json['parkCheckDesc'],
  ),
  validityBeginTime: const NullableStringSafeConverter().fromJson(
    json['validityBeginTime'],
  ),
  validityEndTime: const NullableStringSafeConverter().fromJson(
    json['validityEndTime'],
  ),
  parkCheckStatus: json['parkCheckStatus'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['parkCheckStatus']),
  status: json['status'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['status']),
  state: json['state'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['state']),
  carCategory: json['carCategory'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['carCategory']),
  carNumbColour: json['carNumbColour'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['carNumbColour']),
  roadTransportPermitNumber: const NullableStringSafeConverter().fromJson(
    json['roadTransportPermitNumber'],
  ),
  drivingLicenseEnd: const NullableStringSafeConverter().fromJson(
    json['drivingLicenseEnd'],
  ),
  drivingLicensePic: const NullableStringSafeConverter().fromJson(
    json['drivingLicensePic'],
  ),
  trailer: json['trailer'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['trailer']),
  trailerLicensePlate: const NullableStringSafeConverter().fromJson(
    json['trailerLicensePlate'],
  ),
  trailerRoadTransportPermitNumber: const NullableStringSafeConverter()
      .fromJson(json['trailerRoadTransportPermitNumber']),
  trailerTrailerDrivingLicense: const NullableStringSafeConverter().fromJson(
    json['trailerTrailerDrivingLicense'],
  ),
  sex: json['sex'] == null ? 0 : const IntSafeConverter().fromJson(json['sex']),
  idCard: const NullableStringSafeConverter().fromJson(json['idCard']),
  faceUrl: const NullableStringSafeConverter().fromJson(json['faceUrl']),
);

Map<String, dynamic> _$BlacklistApprovalItemModelToJson(
  BlacklistApprovalItemModel instance,
) => <String, dynamic>{
  'id': const NullableStringSafeConverter().toJson(instance.id),
  'type': const IntSafeConverter().toJson(instance.type),
  'carNumb': const NullableStringSafeConverter().toJson(instance.carNumb),
  'realName': const NullableStringSafeConverter().toJson(instance.realName),
  'userPhone': const NullableStringSafeConverter().toJson(instance.userPhone),
  'createBy': const NullableStringSafeConverter().toJson(instance.createBy),
  'createDate': const NullableStringSafeConverter().toJson(instance.createDate),
  'submitUserPhone': const NullableStringSafeConverter().toJson(
    instance.submitUserPhone,
  ),
  'remark': const NullableStringSafeConverter().toJson(instance.remark),
  'attachment': const NullableStringSafeConverter().toJson(instance.attachment),
  'parkCheckUserName': const NullableStringSafeConverter().toJson(
    instance.parkCheckUserName,
  ),
  'parkCheckUserPhone': const NullableStringSafeConverter().toJson(
    instance.parkCheckUserPhone,
  ),
  'parkCheckTime': const NullableStringSafeConverter().toJson(
    instance.parkCheckTime,
  ),
  'parkCheckDesc': const NullableStringSafeConverter().toJson(
    instance.parkCheckDesc,
  ),
  'validityBeginTime': const NullableStringSafeConverter().toJson(
    instance.validityBeginTime,
  ),
  'validityEndTime': const NullableStringSafeConverter().toJson(
    instance.validityEndTime,
  ),
  'parkCheckStatus': const IntSafeConverter().toJson(instance.parkCheckStatus),
  'status': const IntSafeConverter().toJson(instance.status),
  'state': const IntSafeConverter().toJson(instance.state),
  'carCategory': const IntSafeConverter().toJson(instance.carCategory),
  'carNumbColour': const IntSafeConverter().toJson(instance.carNumbColour),
  'roadTransportPermitNumber': const NullableStringSafeConverter().toJson(
    instance.roadTransportPermitNumber,
  ),
  'drivingLicenseEnd': const NullableStringSafeConverter().toJson(
    instance.drivingLicenseEnd,
  ),
  'drivingLicensePic': const NullableStringSafeConverter().toJson(
    instance.drivingLicensePic,
  ),
  'trailer': const IntSafeConverter().toJson(instance.trailer),
  'trailerLicensePlate': const NullableStringSafeConverter().toJson(
    instance.trailerLicensePlate,
  ),
  'trailerRoadTransportPermitNumber': const NullableStringSafeConverter()
      .toJson(instance.trailerRoadTransportPermitNumber),
  'trailerTrailerDrivingLicense': const NullableStringSafeConverter().toJson(
    instance.trailerTrailerDrivingLicense,
  ),
  'sex': const IntSafeConverter().toJson(instance.sex),
  'idCard': const NullableStringSafeConverter().toJson(instance.idCard),
  'faceUrl': const NullableStringSafeConverter().toJson(instance.faceUrl),
};
