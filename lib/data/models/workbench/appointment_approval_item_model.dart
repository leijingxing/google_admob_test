import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'appointment_approval_item_model.g.dart';

/// 预约审批列表项模型。
@JsonSerializable()
class AppointmentApprovalItemModel {
  /// 预约记录 ID。
  @NullableStringSafeConverter()
  final String? id;

  /// 预约类型：1-人员；2-普通车；3-危化车；4-危废车；5-货车。
  @IntSafeConverter()
  final int reservationType;

  /// 车牌号（车辆类预约）。
  @NullableStringSafeConverter()
  final String? carNumb;

  /// 姓名（人员类预约）。
  @NullableStringSafeConverter()
  final String? realName;

  /// 列表当前状态：
  /// 0-企业待审批；1-企业通过；2-企业不通过；
  /// 3-园区待审批；4-园区通过；5-园区不通过；6-已过期。
  @IntSafeConverter()
  final int status;

  /// 企业审核状态：0-待审核；1-通过；2-拒绝。
  @IntSafeConverter()
  final int companyCheckStatus;

  /// 园区审核状态：0-待审核；1-通过；2-拒绝。
  @IntSafeConverter()
  final int parkCheckStatus;

  /// 创建时间（文档字段：createDate）。
  @NullableStringSafeConverter()
  final String? createDate;

  /// 审批时间。
  @NullableStringSafeConverter()
  final String? parkCheckTime;

  const AppointmentApprovalItemModel({
    this.id,
    this.reservationType = 0,
    this.carNumb,
    this.realName,
    this.status = 0,
    this.companyCheckStatus = 0,
    this.parkCheckStatus = 0,
    this.createDate,
    this.parkCheckTime,
  });

  /// 从 JSON 创建实例。
  factory AppointmentApprovalItemModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentApprovalItemModelFromJson(json);

  /// 转为 JSON。
  Map<String, dynamic> toJson() => _$AppointmentApprovalItemModelToJson(this);
}
