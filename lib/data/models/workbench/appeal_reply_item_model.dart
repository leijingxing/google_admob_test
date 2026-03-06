import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'appeal_reply_item_model.g.dart';

/// 申诉回复列表项模型。
@JsonSerializable()
class AppealReplyItemModel {
  @NullableStringSafeConverter()
  final String? id;

  @NullableStringSafeConverter()
  final String? relationId;

  /// 1-违规申诉；2-拉黑申诉。
  @IntSafeConverter()
  final int appealType;

  @NullableStringSafeConverter()
  final String? targetValue;

  @NullableStringSafeConverter()
  final String? abnormalDesc;

  @NullableStringSafeConverter()
  final String? applicant;

  @NullableStringSafeConverter()
  final String? appealTime;

  @NullableStringSafeConverter()
  final String? appealDesc;

  @NullableStringSafeConverter()
  final String? reply;

  /// 0-申诉中；1-已通过；2-不通过。
  @IntSafeConverter()
  final int status;

  const AppealReplyItemModel({
    this.id,
    this.relationId,
    this.appealType = 0,
    this.targetValue,
    this.abnormalDesc,
    this.applicant,
    this.appealTime,
    this.appealDesc,
    this.reply,
    this.status = 0,
  });

  factory AppealReplyItemModel.fromJson(Map<String, dynamic> json) =>
      _$AppealReplyItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppealReplyItemModelToJson(this);
}
