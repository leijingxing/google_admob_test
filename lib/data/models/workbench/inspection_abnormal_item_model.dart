import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'inspection_abnormal_item_model.g.dart';

/// 巡检异常列表项模型。
@JsonSerializable()
class InspectionAbnormalItemModel {
  @NullableStringSafeConverter()
  final String? id;

  @NullableStringSafeConverter()
  final String? pointId;

  @NullableStringSafeConverter()
  final String? pointName;

  @NullableStringSafeConverter()
  final String? ruleId;

  @NullableStringSafeConverter()
  final String? ruleName;

  @NullableStringSafeConverter()
  final String? reporterId;

  @NullableStringSafeConverter()
  final String? reporterName;

  @NullableStringSafeConverter()
  final String? abnormalDesc;

  @NullableStringListSafeConverter()
  final List<String>? photoUrls;

  /// 1-是；0-否。
  @NullableStringSafeConverter()
  final String? isUrgent;

  /// 参考 `inspectionManagement/constants.js` 的 ABNORMAL_STATUS 枚举。
  @NullableStringSafeConverter()
  final String? abnormalStatus;

  @NullableStringSafeConverter()
  final String? reportTime;

  @NullableStringSafeConverter()
  final String? responsibleType;

  @NullableStringSafeConverter()
  final String? responsibleName;

  const InspectionAbnormalItemModel({
    this.id,
    this.pointId,
    this.pointName,
    this.ruleId,
    this.ruleName,
    this.reporterId,
    this.reporterName,
    this.abnormalDesc,
    this.photoUrls,
    this.isUrgent,
    this.abnormalStatus,
    this.reportTime,
    this.responsibleType,
    this.responsibleName,
  });

  factory InspectionAbnormalItemModel.fromJson(Map<String, dynamic> json) =>
      _$InspectionAbnormalItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$InspectionAbnormalItemModelToJson(this);
}
