import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'spot_inspection_check_item_model.g.dart';

/// 抽检检查项模型。
@JsonSerializable()
class SpotInspectionCheckItemModel {
  @NullableStringSafeConverter()
  final String? id;

  @NullableStringSafeConverter()
  final String? companyId;

  @NullableStringSafeConverter()
  final String? companyName;

  @NullableStringSafeConverter()
  final String? securityTemplateId;

  @NullableStringSafeConverter()
  final String? checkItemId;

  @NullableStringSafeConverter()
  final String? checkItemName;

  @NullableStringSafeConverter()
  final String? checkItem;

  @NullableStringSafeConverter()
  final String? checkDescribe;

  @NullableStringSafeConverter()
  final String? checkMethod;

  @NullableStringSafeConverter()
  final String? selfCheckingStatus;

  @NullableStringSafeConverter()
  final String? spotCheckStatus;

  @NullableStringSafeConverter()
  final String? checkItemStatus;

  @NullableStringSafeConverter()
  final String? createDate;

  @NullableStringSafeConverter()
  final String? checkFile;

  @NullableStringSafeConverter()
  final String? checkResult;

  @NullableStringSafeConverter()
  final String? remark;

  @NullableStringSafeConverter()
  final String? remarks;

  @NullableStringSafeConverter()
  final String? checkStatus;

  @NullableStringSafeConverter()
  final String? isConformity;

  const SpotInspectionCheckItemModel({
    this.id,
    this.companyId,
    this.companyName,
    this.securityTemplateId,
    this.checkItemId,
    this.checkItemName,
    this.checkItem,
    this.checkDescribe,
    this.checkMethod,
    this.selfCheckingStatus,
    this.spotCheckStatus,
    this.checkItemStatus,
    this.createDate,
    this.checkFile,
    this.checkResult,
    this.remark,
    this.remarks,
    this.checkStatus,
    this.isConformity,
  });

  factory SpotInspectionCheckItemModel.fromJson(Map<String, dynamic> json) =>
      _$SpotInspectionCheckItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$SpotInspectionCheckItemModelToJson(this);
}
