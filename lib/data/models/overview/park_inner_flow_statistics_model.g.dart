// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'park_inner_flow_statistics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParkInnerFlowStatisticsModel _$ParkInnerFlowStatisticsModelFromJson(
  Map<String, dynamic> json,
) => ParkInnerFlowStatisticsModel(
  timeAxis: json['timeAxis'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['timeAxis']),
  inCount: json['inCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['inCount']),
  outCount: json['outCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['outCount']),
);

Map<String, dynamic> _$ParkInnerFlowStatisticsModelToJson(
  ParkInnerFlowStatisticsModel instance,
) => <String, dynamic>{
  'timeAxis': const StringSafeConverter().toJson(instance.timeAxis),
  'inCount': const IntSafeConverter().toJson(instance.inCount),
  'outCount': const IntSafeConverter().toJson(instance.outCount),
};
