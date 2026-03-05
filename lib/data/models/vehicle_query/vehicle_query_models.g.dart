// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_query_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleCategoryCountModel _$VehicleCategoryCountModelFromJson(
  Map<String, dynamic> json,
) => VehicleCategoryCountModel(
  carCategory: json['carCategory'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['carCategory']),
  totalCount: json['totalCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['totalCount']),
  blackListCount: json['blackListCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['blackListCount']),
  whiteListCount: json['whiteListCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['whiteListCount']),
  reservationCount: json['reservationCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['reservationCount']),
);

Map<String, dynamic> _$VehicleCategoryCountModelToJson(
  VehicleCategoryCountModel instance,
) => <String, dynamic>{
  'carCategory': const IntSafeConverter().toJson(instance.carCategory),
  'totalCount': const IntSafeConverter().toJson(instance.totalCount),
  'blackListCount': const IntSafeConverter().toJson(instance.blackListCount),
  'whiteListCount': const IntSafeConverter().toJson(instance.whiteListCount),
  'reservationCount': const IntSafeConverter().toJson(
    instance.reservationCount,
  ),
};

ComprehensiveDetailCountModel _$ComprehensiveDetailCountModelFromJson(
  Map<String, dynamic> json,
) => ComprehensiveDetailCountModel(
  accessRecordCount: json['accessRecordCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['accessRecordCount']),
  authorizationCount: json['authorizationCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['authorizationCount']),
  blackListCount: json['blackListCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['blackListCount']),
  violationCount: json['violationCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['violationCount']),
);

Map<String, dynamic> _$ComprehensiveDetailCountModelToJson(
  ComprehensiveDetailCountModel instance,
) => <String, dynamic>{
  'accessRecordCount': const IntSafeConverter().toJson(
    instance.accessRecordCount,
  ),
  'authorizationCount': const IntSafeConverter().toJson(
    instance.authorizationCount,
  ),
  'blackListCount': const IntSafeConverter().toJson(instance.blackListCount),
  'violationCount': const IntSafeConverter().toJson(instance.violationCount),
};

VehicleComprehensiveItemModel _$VehicleComprehensiveItemModelFromJson(
  Map<String, dynamic> json,
) => VehicleComprehensiveItemModel(
  id: const NullableStringSafeConverter().fromJson(json['id']),
  idCard: const NullableStringSafeConverter().fromJson(json['idCard']),
  carNumb: json['carNumb'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['carNumb']),
  carCategory: json['carCategory'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['carCategory']),
  carNumbColour: json['carNumbColour'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['carNumbColour']),
  trailer: json['trailer'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['trailer']),
  validityStatus: json['validityStatus'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['validityStatus']),
  accessCount: json['accessCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['accessCount']),
  inCount: json['inCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['inCount']),
  outCount: json['outCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['outCount']),
  violationCount: json['violationCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['violationCount']),
  blackCount: json['blackCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['blackCount']),
);

Map<String, dynamic> _$VehicleComprehensiveItemModelToJson(
  VehicleComprehensiveItemModel instance,
) => <String, dynamic>{
  'id': const NullableStringSafeConverter().toJson(instance.id),
  'idCard': const NullableStringSafeConverter().toJson(instance.idCard),
  'carNumb': const StringSafeConverter().toJson(instance.carNumb),
  'carCategory': const IntSafeConverter().toJson(instance.carCategory),
  'carNumbColour': const IntSafeConverter().toJson(instance.carNumbColour),
  'trailer': const IntSafeConverter().toJson(instance.trailer),
  'validityStatus': const IntSafeConverter().toJson(instance.validityStatus),
  'accessCount': const IntSafeConverter().toJson(instance.accessCount),
  'inCount': const IntSafeConverter().toJson(instance.inCount),
  'outCount': const IntSafeConverter().toJson(instance.outCount),
  'violationCount': const IntSafeConverter().toJson(instance.violationCount),
  'blackCount': const IntSafeConverter().toJson(instance.blackCount),
};

VehicleAuthorizationRecordModel _$VehicleAuthorizationRecordModelFromJson(
  Map<String, dynamic> json,
) => VehicleAuthorizationRecordModel(
  id: const NullableStringSafeConverter().fromJson(json['id']),
  recordType: json['recordType'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['recordType']),
  approvalTime: json['approvalTime'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['approvalTime']),
  validityBeginTime: json['validityBeginTime'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['validityBeginTime']),
  validityEndTime: json['validityEndTime'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['validityEndTime']),
  userPhone: json['userPhone'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['userPhone']),
  destination: json['destination'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['destination']),
  inDate: json['inDate'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['inDate']),
);

Map<String, dynamic> _$VehicleAuthorizationRecordModelToJson(
  VehicleAuthorizationRecordModel instance,
) => <String, dynamic>{
  'id': const NullableStringSafeConverter().toJson(instance.id),
  'recordType': const IntSafeConverter().toJson(instance.recordType),
  'approvalTime': const StringSafeConverter().toJson(instance.approvalTime),
  'validityBeginTime': const StringSafeConverter().toJson(
    instance.validityBeginTime,
  ),
  'validityEndTime': const StringSafeConverter().toJson(
    instance.validityEndTime,
  ),
  'userPhone': const StringSafeConverter().toJson(instance.userPhone),
  'destination': const StringSafeConverter().toJson(instance.destination),
  'inDate': const StringSafeConverter().toJson(instance.inDate),
};

VehicleAccessRecordModel _$VehicleAccessRecordModelFromJson(
  Map<String, dynamic> json,
) => VehicleAccessRecordModel(
  reservationOrWhileId: const NullableStringSafeConverter().fromJson(
    json['reservationOrWhileId'],
  ),
  recordType: json['recordType'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['recordType']),
  userPhone: json['userPhone'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['userPhone']),
  destination: json['destination'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['destination']),
  inDate: json['inDate'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['inDate']),
  inDeviceName: json['inDeviceName'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['inDeviceName']),
  outDate: json['outDate'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['outDate']),
  outDeviceName: json['outDeviceName'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['outDeviceName']),
  violationCount: json['violationCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['violationCount']),
);

Map<String, dynamic> _$VehicleAccessRecordModelToJson(
  VehicleAccessRecordModel instance,
) => <String, dynamic>{
  'reservationOrWhileId': const NullableStringSafeConverter().toJson(
    instance.reservationOrWhileId,
  ),
  'recordType': const IntSafeConverter().toJson(instance.recordType),
  'userPhone': const StringSafeConverter().toJson(instance.userPhone),
  'destination': const StringSafeConverter().toJson(instance.destination),
  'inDate': const StringSafeConverter().toJson(instance.inDate),
  'inDeviceName': const StringSafeConverter().toJson(instance.inDeviceName),
  'outDate': const StringSafeConverter().toJson(instance.outDate),
  'outDeviceName': const StringSafeConverter().toJson(instance.outDeviceName),
  'violationCount': const IntSafeConverter().toJson(instance.violationCount),
};

VehicleViolationRecordModel _$VehicleViolationRecordModelFromJson(
  Map<String, dynamic> json,
) => VehicleViolationRecordModel(
  subModuleTypeName: json['subModuleTypeName'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['subModuleTypeName']),
  description: json['description'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['description']),
  warningStartTime: json['warningStartTime'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['warningStartTime']),
  position: json['position'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['position']),
  warningFileUrl: const NullableStringSafeConverter().fromJson(
    json['warningFileUrl'],
  ),
);

Map<String, dynamic> _$VehicleViolationRecordModelToJson(
  VehicleViolationRecordModel instance,
) => <String, dynamic>{
  'subModuleTypeName': const StringSafeConverter().toJson(
    instance.subModuleTypeName,
  ),
  'description': const StringSafeConverter().toJson(instance.description),
  'warningStartTime': const StringSafeConverter().toJson(
    instance.warningStartTime,
  ),
  'position': const StringSafeConverter().toJson(instance.position),
  'warningFileUrl': const NullableStringSafeConverter().toJson(
    instance.warningFileUrl,
  ),
};

VehicleBlackRecordModel _$VehicleBlackRecordModelFromJson(
  Map<String, dynamic> json,
) => VehicleBlackRecordModel(
  userPhone: json['userPhone'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['userPhone']),
  status: json['status'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['status']),
  createBy: json['createBy'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['createBy']),
  createDate: json['createDate'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['createDate']),
  remark: json['remark'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['remark']),
);

Map<String, dynamic> _$VehicleBlackRecordModelToJson(
  VehicleBlackRecordModel instance,
) => <String, dynamic>{
  'userPhone': const StringSafeConverter().toJson(instance.userPhone),
  'status': const IntSafeConverter().toJson(instance.status),
  'createBy': const StringSafeConverter().toJson(instance.createBy),
  'createDate': const StringSafeConverter().toJson(instance.createDate),
  'remark': const StringSafeConverter().toJson(instance.remark),
};
