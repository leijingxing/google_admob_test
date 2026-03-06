// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appeal_reply_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppealReplyItemModel _$AppealReplyItemModelFromJson(
  Map<String, dynamic> json,
) => AppealReplyItemModel(
  id: const NullableStringSafeConverter().fromJson(json['id']),
  relationId: const NullableStringSafeConverter().fromJson(json['relationId']),
  appealType: json['appealType'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['appealType']),
  targetValue: const NullableStringSafeConverter().fromJson(
    json['targetValue'],
  ),
  abnormalDesc: const NullableStringSafeConverter().fromJson(
    json['abnormalDesc'],
  ),
  applicant: const NullableStringSafeConverter().fromJson(json['applicant']),
  appealTime: const NullableStringSafeConverter().fromJson(json['appealTime']),
  appealDesc: const NullableStringSafeConverter().fromJson(json['appealDesc']),
  reply: const NullableStringSafeConverter().fromJson(json['reply']),
  status: json['status'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['status']),
);

Map<String, dynamic> _$AppealReplyItemModelToJson(
  AppealReplyItemModel instance,
) => <String, dynamic>{
  'id': const NullableStringSafeConverter().toJson(instance.id),
  'relationId': const NullableStringSafeConverter().toJson(instance.relationId),
  'appealType': const IntSafeConverter().toJson(instance.appealType),
  'targetValue': const NullableStringSafeConverter().toJson(
    instance.targetValue,
  ),
  'abnormalDesc': const NullableStringSafeConverter().toJson(
    instance.abnormalDesc,
  ),
  'applicant': const NullableStringSafeConverter().toJson(instance.applicant),
  'appealTime': const NullableStringSafeConverter().toJson(instance.appealTime),
  'appealDesc': const NullableStringSafeConverter().toJson(instance.appealDesc),
  'reply': const NullableStringSafeConverter().toJson(instance.reply),
  'status': const IntSafeConverter().toJson(instance.status),
};
