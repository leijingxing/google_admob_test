import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'approval_pending_statistics_model.g.dart';

/// 待审批统计。
@JsonSerializable()
class ApprovalPendingStatisticsModel {
  /// 企业待审批数量。
  @IntSafeConverter()
  final int companyPendingCount;

  /// 园区待审批数量。
  @IntSafeConverter()
  final int parkPendingCount;

  const ApprovalPendingStatisticsModel({
    this.companyPendingCount = 0,
    this.parkPendingCount = 0,
  });

  factory ApprovalPendingStatisticsModel.fromJson(Map<String, dynamic> json) =>
      _$ApprovalPendingStatisticsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApprovalPendingStatisticsModelToJson(this);
}
