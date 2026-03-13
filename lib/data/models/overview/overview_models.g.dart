// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overview_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParkStatisticsModel _$ParkStatisticsModelFromJson(Map<String, dynamic> json) =>
    ParkStatisticsModel(
      type: json['type'] == null
          ? 0
          : const IntSafeConverter().fromJson(json['type']),
      currentInParkCount: json['currentInParkCount'] == null
          ? 0
          : const IntSafeConverter().fromJson(json['currentInParkCount']),
      inParkCount: json['inParkCount'] == null
          ? 0
          : const IntSafeConverter().fromJson(json['inParkCount']),
      outParkCount: json['outParkCount'] == null
          ? 0
          : const IntSafeConverter().fromJson(json['outParkCount']),
      inCount: json['inCount'] == null
          ? 0
          : const IntSafeConverter().fromJson(json['inCount']),
      outCount: json['outCount'] == null
          ? 0
          : const IntSafeConverter().fromJson(json['outCount']),
      inGoodsAmount: json['inGoodsAmount'] == null
          ? 0
          : const DoubleSafeConverter().fromJson(json['inGoodsAmount']),
      outGoodsAmount: json['outGoodsAmount'] == null
          ? 0
          : const DoubleSafeConverter().fromJson(json['outGoodsAmount']),
      totalInGoodsAmount: json['totalInGoodsAmount'] == null
          ? 0
          : const DoubleSafeConverter().fromJson(json['totalInGoodsAmount']),
      totalOutGoodsAmount: json['totalOutGoodsAmount'] == null
          ? 0
          : const DoubleSafeConverter().fromJson(json['totalOutGoodsAmount']),
      typeCount: json['typeCount'] == null
          ? 0
          : const IntSafeConverter().fromJson(json['typeCount']),
    );

Map<String, dynamic> _$ParkStatisticsModelToJson(
  ParkStatisticsModel instance,
) => <String, dynamic>{
  'type': const IntSafeConverter().toJson(instance.type),
  'currentInParkCount': const IntSafeConverter().toJson(
    instance.currentInParkCount,
  ),
  'inParkCount': const IntSafeConverter().toJson(instance.inParkCount),
  'outParkCount': const IntSafeConverter().toJson(instance.outParkCount),
  'inCount': const IntSafeConverter().toJson(instance.inCount),
  'outCount': const IntSafeConverter().toJson(instance.outCount),
  'inGoodsAmount': const DoubleSafeConverter().toJson(instance.inGoodsAmount),
  'outGoodsAmount': const DoubleSafeConverter().toJson(instance.outGoodsAmount),
  'totalInGoodsAmount': const DoubleSafeConverter().toJson(
    instance.totalInGoodsAmount,
  ),
  'totalOutGoodsAmount': const DoubleSafeConverter().toJson(
    instance.totalOutGoodsAmount,
  ),
  'typeCount': const IntSafeConverter().toJson(instance.typeCount),
};
