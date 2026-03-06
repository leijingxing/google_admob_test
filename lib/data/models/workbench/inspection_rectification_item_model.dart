import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'inspection_rectification_item_model.g.dart';

/// 巡检异常整改记录模型。
@JsonSerializable()
class InspectionRectificationItemModel {
  @NullableStringSafeConverter()
  final String? id;

  @NullableStringSafeConverter()
  final String? abnormalId;

  /// INITIAL-初始整改；REJECT-驳回重改；REASSIGN-重新指派。
  @NullableStringSafeConverter()
  final String? rectifyType;

  @NullableStringSafeConverter()
  final String? rectifyUserId;

  @NullableStringSafeConverter()
  final String? rectifyUserName;

  @NullableStringSafeConverter()
  final String? rectifyDesc;

  @NullableStringListSafeConverter()
  final List<String>? photoUrls;

  @NullableStringSafeConverter()
  final String? rectifyTime;

  /// PASS-通过；REJECT-驳回。
  @NullableStringSafeConverter()
  final String? verifyResult;

  /// PENDING_VERIFY/PASSED/REJECTED。
  @NullableStringSafeConverter()
  final String? status;

  const InspectionRectificationItemModel({
    this.id,
    this.abnormalId,
    this.rectifyType,
    this.rectifyUserId,
    this.rectifyUserName,
    this.rectifyDesc,
    this.photoUrls,
    this.rectifyTime,
    this.verifyResult,
    this.status,
  });

  factory InspectionRectificationItemModel.fromJson(
    Map<String, dynamic> json,
  ) => _$InspectionRectificationItemModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$InspectionRectificationItemModelToJson(this);
}
