import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'appointment_approval_item_model.g.dart';

/// 预约审批列表项模型。
@JsonSerializable()
class AppointmentApprovalItemModel {
  /// 预约记录 ID。
  @NullableStringSafeConverter()
  final String? id;

  /// 预约类型：1-来访人员；2-普通车辆；3-危化车辆；4-危废车辆；5-普通货车。
  @IntSafeConverter()
  final int reservationType;

  /// 车牌号（车辆类预约）。
  @NullableStringSafeConverter()
  final String? carNumb;

  /// 姓名（人员类预约）。
  @NullableStringSafeConverter()
  final String? realName;

  /// 园区审核状态：0-待审核；1-通过；2-拒绝；3-已过期（兜底）。
  @IntSafeConverter()
  final int parkCheckStatus;

  /// 提交时间（接口字段可能不统一，当前优先读取 submitTime）。
  @NullableStringSafeConverter()
  final String? submitTime;

  /// 创建时间（submitTime 缺失时兜底）。
  @NullableStringSafeConverter()
  final String? createTime;

  /// 审批时间。
  @NullableStringSafeConverter()
  final String? parkCheckTime;

  const AppointmentApprovalItemModel({
    this.id,
    this.reservationType = 0,
    this.carNumb,
    this.realName,
    this.parkCheckStatus = 0,
    this.submitTime,
    this.createTime,
    this.parkCheckTime,
  });

  /// 从 JSON 创建实例。
  factory AppointmentApprovalItemModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentApprovalItemModelFromJson(json);

  /// 转为 JSON。
  Map<String, dynamic> toJson() => _$AppointmentApprovalItemModelToJson(this);
}
