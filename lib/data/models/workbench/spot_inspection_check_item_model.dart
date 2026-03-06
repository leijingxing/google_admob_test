import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'spot_inspection_check_item_model.g.dart';

/// 抽检检查项模型。
@JsonSerializable()
class SpotInspectionCheckItemModel {
  @NullableStringSafeConverter()
  final String? id;

  @NullableStringSafeConverter()
  final String? checkItemId;

  @NullableStringSafeConverter()
  final String? checkItemName;

  @NullableStringSafeConverter()
  final String? checkDescribe;

  @NullableStringSafeConverter()
  final String? createDate;

  @NullableStringSafeConverter()
  final String? checkFile;

  @NullableStringSafeConverter()
  final String? remark;

  @NullableStringSafeConverter()
  final String? checkStatus;

  @NullableStringSafeConverter()
  final String? isConformity;

  const SpotInspectionCheckItemModel({
    this.id,
    this.checkItemId,
    this.checkItemName,
    this.checkDescribe,
    this.createDate,
    this.checkFile,
    this.remark,
    this.checkStatus,
    this.isConformity,
  });

  factory SpotInspectionCheckItemModel.fromJson(Map<String, dynamic> json) =>
      _$SpotInspectionCheckItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$SpotInspectionCheckItemModelToJson(this);
}
