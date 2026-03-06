// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'risk_warning_disposal_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RiskWarningDisposalItemModel _$RiskWarningDisposalItemModelFromJson(
  Map<String, dynamic> json,
) => RiskWarningDisposalItemModel(
  id: const NullableStringSafeConverter().fromJson(json['id']),
  warningType: json['warningType'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['warningType']),
  title: const NullableStringSafeConverter().fromJson(json['title']),
  description: const NullableStringSafeConverter().fromJson(
    json['description'],
  ),
  warningLevel: json['warningLevel'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['warningLevel']),
  warningStatus: json['warningStatus'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['warningStatus']),
  warningSource: json['warningSource'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['warningSource']),
  warningStartTime: const NullableStringSafeConverter().fromJson(
    json['warningStartTime'],
  ),
  warningEndTime: const NullableStringSafeConverter().fromJson(
    json['warningEndTime'],
  ),
  deviceName: const NullableStringSafeConverter().fromJson(json['deviceName']),
  position: const NullableStringSafeConverter().fromJson(json['position']),
  disposalCategory: json['disposalCategory'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['disposalCategory']),
  disposalResult: const NullableStringSafeConverter().fromJson(
    json['disposalResult'],
  ),
  disposalFiles: const NullableStringListSafeConverter().fromJson(
    json['disposalFiles'],
  ),
);

Map<String, dynamic> _$RiskWarningDisposalItemModelToJson(
  RiskWarningDisposalItemModel instance,
) => <String, dynamic>{
  'id': const NullableStringSafeConverter().toJson(instance.id),
  'warningType': const IntSafeConverter().toJson(instance.warningType),
  'title': const NullableStringSafeConverter().toJson(instance.title),
  'description': const NullableStringSafeConverter().toJson(
    instance.description,
  ),
  'warningLevel': const IntSafeConverter().toJson(instance.warningLevel),
  'warningStatus': const IntSafeConverter().toJson(instance.warningStatus),
  'warningSource': const IntSafeConverter().toJson(instance.warningSource),
  'warningStartTime': const NullableStringSafeConverter().toJson(
    instance.warningStartTime,
  ),
  'warningEndTime': const NullableStringSafeConverter().toJson(
    instance.warningEndTime,
  ),
  'deviceName': const NullableStringSafeConverter().toJson(instance.deviceName),
  'position': const NullableStringSafeConverter().toJson(instance.position),
  'disposalCategory': const IntSafeConverter().toJson(
    instance.disposalCategory,
  ),
  'disposalResult': const NullableStringSafeConverter().toJson(
    instance.disposalResult,
  ),
  'disposalFiles': const NullableStringListSafeConverter().toJson(
    instance.disposalFiles,
  ),
};
