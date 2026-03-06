// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personnel_query_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonnelCountModel _$PersonnelCountModelFromJson(Map<String, dynamic> json) =>
    PersonnelCountModel(
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

Map<String, dynamic> _$PersonnelCountModelToJson(
  PersonnelCountModel instance,
) => <String, dynamic>{
  'totalCount': const IntSafeConverter().toJson(instance.totalCount),
  'blackListCount': const IntSafeConverter().toJson(instance.blackListCount),
  'whiteListCount': const IntSafeConverter().toJson(instance.whiteListCount),
  'reservationCount': const IntSafeConverter().toJson(
    instance.reservationCount,
  ),
};

PersonnelComprehensiveItemModel _$PersonnelComprehensiveItemModelFromJson(
  Map<String, dynamic> json,
) => PersonnelComprehensiveItemModel(
  id: const NullableStringSafeConverter().fromJson(json['id']),
  name: json['name'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['name']),
  phone: json['phone'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['phone']),
  idCard: json['idCard'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['idCard']),
  unit: json['unit'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['unit']),
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

Map<String, dynamic> _$PersonnelComprehensiveItemModelToJson(
  PersonnelComprehensiveItemModel instance,
) => <String, dynamic>{
  'id': const NullableStringSafeConverter().toJson(instance.id),
  'name': const StringSafeConverter().toJson(instance.name),
  'phone': const StringSafeConverter().toJson(instance.phone),
  'idCard': const StringSafeConverter().toJson(instance.idCard),
  'unit': const StringSafeConverter().toJson(instance.unit),
  'validityStatus': const IntSafeConverter().toJson(instance.validityStatus),
  'accessCount': const IntSafeConverter().toJson(instance.accessCount),
  'inCount': const IntSafeConverter().toJson(instance.inCount),
  'outCount': const IntSafeConverter().toJson(instance.outCount),
  'violationCount': const IntSafeConverter().toJson(instance.violationCount),
  'blackCount': const IntSafeConverter().toJson(instance.blackCount),
};
