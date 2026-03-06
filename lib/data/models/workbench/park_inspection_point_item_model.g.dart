// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'park_inspection_point_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParkInspectionPointItemModel _$ParkInspectionPointItemModelFromJson(
  Map<String, dynamic> json,
) => ParkInspectionPointItemModel(
  id: const NullableStringSafeConverter().fromJson(json['id']),
  pointId: const NullableStringSafeConverter().fromJson(json['pointId']),
  pointName: const NullableStringSafeConverter().fromJson(json['pointName']),
  position: const NullableStringSafeConverter().fromJson(json['position']),
  checkRadius: json['checkRadius'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['checkRadius']),
);

Map<String, dynamic> _$ParkInspectionPointItemModelToJson(
  ParkInspectionPointItemModel instance,
) => <String, dynamic>{
  'id': const NullableStringSafeConverter().toJson(instance.id),
  'pointId': const NullableStringSafeConverter().toJson(instance.pointId),
  'pointName': const NullableStringSafeConverter().toJson(instance.pointName),
  'position': const NullableStringSafeConverter().toJson(instance.position),
  'checkRadius': const IntSafeConverter().toJson(instance.checkRadius),
};
