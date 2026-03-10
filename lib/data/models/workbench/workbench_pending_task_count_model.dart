import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'workbench_pending_task_count_model.g.dart';

/// 工作台待处理数量统计。
@JsonSerializable()
class WorkbenchPendingTaskCountModel {
  /// 预约待处理数量。
  @IntSafeConverter()
  final int reservationPendingCount;

  /// 白名单待处理数量。
  @IntSafeConverter()
  final int whitePendingCount;

  /// 黑名单待处理数量。
  @IntSafeConverter()
  final int blackPendingCount;

  /// 车辆抽检待处理条数。
  @IntSafeConverter()
  final int securityCheckCount;

  /// 巡检计划待执行数量。
  @IntSafeConverter()
  final int inspectionPendingCount;

  /// 隐患治理待处理数量。
  @IntSafeConverter()
  final int hazardPendingCount;

  /// 异常确认待处理数量。
  @IntSafeConverter()
  final int exceptionPendingCount;

  /// 申诉回复待处理数量。
  @IntSafeConverter()
  final int appealPendingCount;

  /// 预警未处置条数。
  @IntSafeConverter()
  final int warningUnDisposalCount;

  /// 报警未处置条数。
  @IntSafeConverter()
  final int alarmUnDisposalCount;

  const WorkbenchPendingTaskCountModel({
    this.reservationPendingCount = 0,
    this.whitePendingCount = 0,
    this.blackPendingCount = 0,
    this.securityCheckCount = 0,
    this.inspectionPendingCount = 0,
    this.hazardPendingCount = 0,
    this.exceptionPendingCount = 0,
    this.appealPendingCount = 0,
    this.warningUnDisposalCount = 0,
    this.alarmUnDisposalCount = 0,
  });

  factory WorkbenchPendingTaskCountModel.fromJson(Map<String, dynamic> json) =>
      _$WorkbenchPendingTaskCountModelFromJson(json);

  Map<String, dynamic> toJson() => _$WorkbenchPendingTaskCountModelToJson(this);
}
