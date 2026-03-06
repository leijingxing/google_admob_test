import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'risk_warning_disposal_item_model.g.dart';

/// 报警/预警处置列表项模型。
@JsonSerializable()
class RiskWarningDisposalItemModel {
  @NullableStringSafeConverter()
  final String? id;

  @IntSafeConverter()
  final int warningType;

  @NullableStringSafeConverter()
  final String? title;

  @NullableStringSafeConverter()
  final String? description;

  @IntSafeConverter()
  final int warningLevel;

  @IntSafeConverter()
  final int warningStatus;

  @IntSafeConverter()
  final int warningSource;

  @NullableStringSafeConverter()
  final String? warningStartTime;

  @NullableStringSafeConverter()
  final String? warningEndTime;

  @NullableStringSafeConverter()
  final String? deviceName;

  @NullableStringSafeConverter()
  final String? position;

  @IntSafeConverter()
  final int disposalCategory;

  @NullableStringSafeConverter()
  final String? disposalResult;

  @NullableStringListSafeConverter()
  final List<String>? disposalFiles;

  const RiskWarningDisposalItemModel({
    this.id,
    this.warningType = 0,
    this.title,
    this.description,
    this.warningLevel = 0,
    this.warningStatus = 0,
    this.warningSource = 0,
    this.warningStartTime,
    this.warningEndTime,
    this.deviceName,
    this.position,
    this.disposalCategory = 0,
    this.disposalResult,
    this.disposalFiles,
  });

  factory RiskWarningDisposalItemModel.fromJson(Map<String, dynamic> json) =>
      _$RiskWarningDisposalItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$RiskWarningDisposalItemModelToJson(this);
}
