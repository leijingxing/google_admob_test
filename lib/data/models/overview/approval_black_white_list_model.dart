import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'approval_black_white_list_model.g.dart';

/// 今日审批/黑白名单统计。
@JsonSerializable()
class ApprovalBlackWhiteListModel {
  /// 企业审批数。
  @IntSafeConverter()
  final int companyApprovalCount;

  /// 园区审批数。
  @IntSafeConverter()
  final int parkApprovalCount;

  /// 人员黑名单数。
  @IntSafeConverter()
  final int personBlackListCount;

  /// 车辆黑名单数。
  @IntSafeConverter()
  final int carBlackListCount;

  /// 人员白名单数。
  @IntSafeConverter()
  final int personWhiteListCount;

  /// 车辆白名单数。
  @IntSafeConverter()
  final int carWhiteListCount;

  const ApprovalBlackWhiteListModel({
    this.companyApprovalCount = 0,
    this.parkApprovalCount = 0,
    this.personBlackListCount = 0,
    this.carBlackListCount = 0,
    this.personWhiteListCount = 0,
    this.carWhiteListCount = 0,
  });

  factory ApprovalBlackWhiteListModel.fromJson(Map<String, dynamic> json) =>
      _$ApprovalBlackWhiteListModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApprovalBlackWhiteListModelToJson(this);
}
