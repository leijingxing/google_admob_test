import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'park_inspection_record_detail_item_model.g.dart';

/// 巡检记录细则明细模型。
@JsonSerializable()
class ParkInspectionRecordDetailItemModel {
  @NullableStringSafeConverter()
  final String? id;

  @NullableStringSafeConverter()
  final String? recordId;

  @NullableStringSafeConverter()
  final String? ruleId;

  @NullableStringSafeConverter()
  final String? ruleName;

  @NullableStringSafeConverter()
  final String? resultStatus;

  @NullableStringSafeConverter()
  final String? remark;

  @NullableStringListSafeConverter()
  final List<String>? attachments;

  const ParkInspectionRecordDetailItemModel({
    this.id,
    this.recordId,
    this.ruleId,
    this.ruleName,
    this.resultStatus,
    this.remark,
    this.attachments,
  });

  factory ParkInspectionRecordDetailItemModel.fromJson(
    Map<String, dynamic> json,
  ) => _$ParkInspectionRecordDetailItemModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ParkInspectionRecordDetailItemModelToJson(this);
}
