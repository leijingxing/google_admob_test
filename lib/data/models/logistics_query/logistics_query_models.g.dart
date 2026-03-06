// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logistics_query_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogisticsStatisticsItemModel _$LogisticsStatisticsItemModelFromJson(
  Map<String, dynamic> json,
) => LogisticsStatisticsItemModel(
  hazardousType: json['hazardousType'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['hazardousType']),
  topOneName: json['topOneName'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['topOneName']),
  topOneAmount: json['topOneAmount'] == null
      ? '0'
      : const StringSafeConverter().fromJson(json['topOneAmount']),
  topTwoName: json['topTwoName'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['topTwoName']),
  topTwoAmount: json['topTwoAmount'] == null
      ? '0'
      : const StringSafeConverter().fromJson(json['topTwoAmount']),
  topThreeName: json['topThreeName'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['topThreeName']),
  topThreeAmount: json['topThreeAmount'] == null
      ? '0'
      : const StringSafeConverter().fromJson(json['topThreeAmount']),
);

Map<String, dynamic> _$LogisticsStatisticsItemModelToJson(
  LogisticsStatisticsItemModel instance,
) => <String, dynamic>{
  'hazardousType': const IntSafeConverter().toJson(instance.hazardousType),
  'topOneName': const StringSafeConverter().toJson(instance.topOneName),
  'topOneAmount': const StringSafeConverter().toJson(instance.topOneAmount),
  'topTwoName': const StringSafeConverter().toJson(instance.topTwoName),
  'topTwoAmount': const StringSafeConverter().toJson(instance.topTwoAmount),
  'topThreeName': const StringSafeConverter().toJson(instance.topThreeName),
  'topThreeAmount': const StringSafeConverter().toJson(instance.topThreeAmount),
};

LogisticsComprehensiveItemModel _$LogisticsComprehensiveItemModelFromJson(
  Map<String, dynamic> json,
) => LogisticsComprehensiveItemModel(
  id: const NullableStringSafeConverter().fromJson(json['id']),
  cas: json['cas'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['cas']),
  goodsName: json['goodsName'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['goodsName']),
  goodsType: (json['goodsType'] as num?)?.toInt() ?? 0,
  hazardousType: const IntSafeConverter().fromJson(json['hazardousType']),
  inCount: json['inCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['inCount']),
  outCount: json['outCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['outCount']),
  inGoodsAmount: json['inGoodsAmount'] == null
      ? '0'
      : const StringSafeConverter().fromJson(json['inGoodsAmount']),
  outGoodsAmount: json['outGoodsAmount'] == null
      ? '0'
      : const StringSafeConverter().fromJson(json['outGoodsAmount']),
);

Map<String, dynamic> _$LogisticsComprehensiveItemModelToJson(
  LogisticsComprehensiveItemModel instance,
) => <String, dynamic>{
  'id': const NullableStringSafeConverter().toJson(instance.id),
  'cas': const StringSafeConverter().toJson(instance.cas),
  'goodsName': const StringSafeConverter().toJson(instance.goodsName),
  'goodsType': instance.goodsType,
  'hazardousType': _$JsonConverterToJson<Object?, int>(
    instance.hazardousType,
    const IntSafeConverter().toJson,
  ),
  'inCount': const IntSafeConverter().toJson(instance.inCount),
  'outCount': const IntSafeConverter().toJson(instance.outCount),
  'inGoodsAmount': const StringSafeConverter().toJson(instance.inGoodsAmount),
  'outGoodsAmount': const StringSafeConverter().toJson(instance.outGoodsAmount),
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

LogisticsDetailCountModel _$LogisticsDetailCountModelFromJson(
  Map<String, dynamic> json,
) => LogisticsDetailCountModel(
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

Map<String, dynamic> _$LogisticsDetailCountModelToJson(
  LogisticsDetailCountModel instance,
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

LogisticsAuthorizationRecordModel _$LogisticsAuthorizationRecordModelFromJson(
  Map<String, dynamic> json,
) => LogisticsAuthorizationRecordModel(
  id: const NullableStringSafeConverter().fromJson(json['id']),
  reservationId: const NullableStringSafeConverter().fromJson(
    json['reservationId'],
  ),
  parkCheckTime: json['parkCheckTime'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['parkCheckTime']),
  validityBeginTime: json['validityBeginTime'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['validityBeginTime']),
  validityEndTime: json['validityEndTime'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['validityEndTime']),
  carNumb: json['carNumb'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['carNumb']),
  loadType: json['loadType'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['loadType']),
  destination: json['destination'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['destination']),
);

Map<String, dynamic> _$LogisticsAuthorizationRecordModelToJson(
  LogisticsAuthorizationRecordModel instance,
) => <String, dynamic>{
  'id': const NullableStringSafeConverter().toJson(instance.id),
  'reservationId': const NullableStringSafeConverter().toJson(
    instance.reservationId,
  ),
  'parkCheckTime': const StringSafeConverter().toJson(instance.parkCheckTime),
  'validityBeginTime': const StringSafeConverter().toJson(
    instance.validityBeginTime,
  ),
  'validityEndTime': const StringSafeConverter().toJson(
    instance.validityEndTime,
  ),
  'carNumb': const StringSafeConverter().toJson(instance.carNumb),
  'loadType': const IntSafeConverter().toJson(instance.loadType),
  'destination': const StringSafeConverter().toJson(instance.destination),
};

LogisticsAccessRecordModel _$LogisticsAccessRecordModelFromJson(
  Map<String, dynamic> json,
) => LogisticsAccessRecordModel(
  id: const NullableStringSafeConverter().fromJson(json['id']),
  reservationId: const NullableStringSafeConverter().fromJson(
    json['reservationId'],
  ),
  carNumb: json['carNumb'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['carNumb']),
  destination: json['destination'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['destination']),
  inDate: json['inDate'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['inDate']),
  inDeviceName: json['inDeviceName'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['inDeviceName']),
  inGoodsAmount: json['inGoodsAmount'] == null
      ? '0'
      : const StringSafeConverter().fromJson(json['inGoodsAmount']),
  outGoodsAmount: json['outGoodsAmount'] == null
      ? '0'
      : const StringSafeConverter().fromJson(json['outGoodsAmount']),
  transportAmount: json['transportAmount'] == null
      ? '0'
      : const StringSafeConverter().fromJson(json['transportAmount']),
  outDate: json['outDate'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['outDate']),
  outDeviceName: json['outDeviceName'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['outDeviceName']),
  parkCheckTime: json['parkCheckTime'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['parkCheckTime']),
  validityBeginTime: json['validityBeginTime'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['validityBeginTime']),
  validityEndTime: json['validityEndTime'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['validityEndTime']),
  loadType: json['loadType'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['loadType']),
);

Map<String, dynamic> _$LogisticsAccessRecordModelToJson(
  LogisticsAccessRecordModel instance,
) => <String, dynamic>{
  'id': const NullableStringSafeConverter().toJson(instance.id),
  'reservationId': const NullableStringSafeConverter().toJson(
    instance.reservationId,
  ),
  'carNumb': const StringSafeConverter().toJson(instance.carNumb),
  'destination': const StringSafeConverter().toJson(instance.destination),
  'inDate': const StringSafeConverter().toJson(instance.inDate),
  'inDeviceName': const StringSafeConverter().toJson(instance.inDeviceName),
  'inGoodsAmount': const StringSafeConverter().toJson(instance.inGoodsAmount),
  'outGoodsAmount': const StringSafeConverter().toJson(instance.outGoodsAmount),
  'transportAmount': const StringSafeConverter().toJson(
    instance.transportAmount,
  ),
  'outDate': const StringSafeConverter().toJson(instance.outDate),
  'outDeviceName': const StringSafeConverter().toJson(instance.outDeviceName),
  'parkCheckTime': const StringSafeConverter().toJson(instance.parkCheckTime),
  'validityBeginTime': const StringSafeConverter().toJson(
    instance.validityBeginTime,
  ),
  'validityEndTime': const StringSafeConverter().toJson(
    instance.validityEndTime,
  ),
  'loadType': const IntSafeConverter().toJson(instance.loadType),
};
