// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'park_inspection_record_detail_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParkInspectionRecordDetailItemModel
_$ParkInspectionRecordDetailItemModelFromJson(Map<String, dynamic> json) =>
    ParkInspectionRecordDetailItemModel(
      id: const NullableStringSafeConverter().fromJson(json['id']),
      recordId: const NullableStringSafeConverter().fromJson(json['recordId']),
      ruleId: const NullableStringSafeConverter().fromJson(json['ruleId']),
      ruleName: const NullableStringSafeConverter().fromJson(json['ruleName']),
      resultStatus: const NullableStringSafeConverter().fromJson(
        json['resultStatus'],
      ),
      remark: const NullableStringSafeConverter().fromJson(json['remark']),
      attachments: const NullableStringListSafeConverter().fromJson(
        json['attachments'],
      ),
    );

Map<String, dynamic> _$ParkInspectionRecordDetailItemModelToJson(
  ParkInspectionRecordDetailItemModel instance,
) => <String, dynamic>{
  'id': const NullableStringSafeConverter().toJson(instance.id),
  'recordId': const NullableStringSafeConverter().toJson(instance.recordId),
  'ruleId': const NullableStringSafeConverter().toJson(instance.ruleId),
  'ruleName': const NullableStringSafeConverter().toJson(instance.ruleName),
  'resultStatus': const NullableStringSafeConverter().toJson(
    instance.resultStatus,
  ),
  'remark': const NullableStringSafeConverter().toJson(instance.remark),
  'attachments': const NullableStringListSafeConverter().toJson(
    instance.attachments,
  ),
};
