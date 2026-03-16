// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hazardous_waste_in_and_out_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HazardousWasteInAndOutModel _$HazardousWasteInAndOutModelFromJson(
  Map<String, dynamic> json,
) => HazardousWasteInAndOutModel(
  goodsName: json['goodsName'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['goodsName']),
  count: json['count'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['count']),
);

Map<String, dynamic> _$HazardousWasteInAndOutModelToJson(
  HazardousWasteInAndOutModel instance,
) => <String, dynamic>{
  'goodsName': const StringSafeConverter().toJson(instance.goodsName),
  'count': const IntSafeConverter().toJson(instance.count),
};
