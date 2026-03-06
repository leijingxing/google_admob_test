import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'whitelist_approval_item_model.g.dart';

/// 白名单审批列表项模型。
@JsonSerializable()
class WhitelistApprovalItemModel {
  @NullableStringSafeConverter()
  final String? id;

  /// 1-人员白名单；2-车辆白名单。
  @IntSafeConverter()
  final int type;

  @NullableStringSafeConverter()
  final String? carNumb;

  @NullableStringSafeConverter()
  final String? realName;

  @NullableStringSafeConverter()
  final String? userPhone;

  @NullableStringSafeConverter()
  final String? companyName;

  @NullableStringSafeConverter()
  final String? submitBy;

  @NullableStringSafeConverter()
  final String? submitDate;

  @NullableStringSafeConverter()
  final String? parkCheckTime;

  @NullableStringSafeConverter()
  final String? validityBeginTime;

  @NullableStringSafeConverter()
  final String? validityEndTime;

  @NullableStringSafeConverter()
  final String? parkCheckDesc;

  @IntSafeConverter()
  final int parkCheckStatus;

  const WhitelistApprovalItemModel({
    this.id,
    this.type = 0,
    this.carNumb,
    this.realName,
    this.userPhone,
    this.companyName,
    this.submitBy,
    this.submitDate,
    this.parkCheckTime,
    this.validityBeginTime,
    this.validityEndTime,
    this.parkCheckDesc,
    this.parkCheckStatus = 0,
  });

  factory WhitelistApprovalItemModel.fromJson(Map<String, dynamic> json) =>
      _$WhitelistApprovalItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$WhitelistApprovalItemModelToJson(this);
}
