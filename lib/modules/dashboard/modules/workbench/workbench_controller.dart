import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/components/toast/toast_widget.dart';
import '../../../../data/models/workbench/workbench_pending_task_count_model.dart';
import '../../../../data/repository/workbench_repository.dart';
import '../../../../router/module_routes/workbench_routes.dart';

/// 工作台页面控制器。
class WorkbenchController extends GetxController {
  final WorkbenchRepository _workbenchRepository = WorkbenchRepository();
  static const int defaultPendingCount = 0;
  static const WorkbenchPendingTaskCountModel _defaultPendingTaskCount =
      WorkbenchPendingTaskCountModel();

  /// 任务进度百分比（0~100），用于展示文案与进度圈。
  double taskProgressPercent = 0;
  int appointmentApprovalCount = defaultPendingCount;
  WorkbenchPendingTaskCountModel pendingTaskCount = _defaultPendingTaskCount;

  /// 工作台入口配置。
  List<WorkbenchEntry> get entries => [
    WorkbenchEntry(
      title: '白名单审批',
      count: pendingTaskCount.whitePendingCount,
      icon: Icons.verified_user_outlined,
      color: const Color(0xFF3C84F6),
      onTap: WorkbenchRoutes.toWhitelistApproval,
    ),
    WorkbenchEntry(
      title: '黑名单审批',
      count: pendingTaskCount.blackPendingCount,
      icon: Icons.gpp_bad_outlined,
      color: const Color(0xFF4694FF),
      onTap: WorkbenchRoutes.toBlacklistApproval,
    ),
    WorkbenchEntry(
      title: '车辆抽检',
      count: pendingTaskCount.securityCheckCount,
      icon: Icons.directions_car_filled_outlined,
      color: const Color(0xFF5DA3FF),
      onTap: WorkbenchRoutes.toSpotInspection,
    ),
    WorkbenchEntry(
      title: '园区巡检',
      count: pendingTaskCount.inspectionPendingCount,
      icon: Icons.camera_outdoor_outlined,
      color: const Color(0xFF4B8EF7),
      onTap: WorkbenchRoutes.toParkInspection,
    ),
    WorkbenchEntry(
      title: '隐患治理',
      count: pendingTaskCount.hazardPendingCount,
      icon: Icons.build_circle_outlined,
      color: const Color(0xFF6AA9FF),
      onTap: WorkbenchRoutes.toHiddenDangerGovernance,
    ),
    WorkbenchEntry(
      title: '异常确认',
      count: pendingTaskCount.exceptionPendingCount,
      icon: Icons.report_problem_outlined,
      color: const Color(0xFF55A0FF),
      onTap: WorkbenchRoutes.toExceptionConfirmation,
    ),
    WorkbenchEntry(
      title: '申诉回复',
      count: pendingTaskCount.appealPendingCount,
      icon: Icons.message_outlined,
      color: const Color(0xFF3F90F0),
      onTap: WorkbenchRoutes.toAppealReply,
    ),
    WorkbenchEntry(
      title: '报警处置',
      count: pendingTaskCount.alarmUnDisposalCount,
      icon: Icons.notifications_active_outlined,
      color: const Color(0xFF5A98F3),
      onTap: WorkbenchRoutes.toAlarmDisposal,
    ),
    WorkbenchEntry(
      title: '预警处置',
      count: pendingTaskCount.warningUnDisposalCount,
      icon: Icons.warning_amber_rounded,
      color: const Color(0xFF73B1FF),
      onTap: WorkbenchRoutes.toWarningDisposal,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    fetchTaskProgress();
    fetchPendingTaskCount();
  }

  /// 获取任务进度跟踪百分比。
  Future<void> fetchTaskProgress() async {
    final result = await _workbenchRepository.getTaskProgressPercent();
    result.when(
      success: (percent) {
        // 接口返回值按百分比语义处理，这里统一限制在 0~100。
        taskProgressPercent = percent.clamp(0, 100).toDouble();
        update();
      },
      failure: (error) {
        AppToast.showError(error.message);
      },
    );
  }

  /// 获取工作台待处理数量统计。
  Future<void> fetchPendingTaskCount() async {
    final result = await _workbenchRepository.getPendingTaskCount();
    result.when(
      success: (data) {
        pendingTaskCount = data;
        appointmentApprovalCount = data.reservationPendingCount;
        update();
      },
      failure: (error) {
        AppToast.showError(error.message);
      },
    );
  }

  /// 进入预约审批。
  void openAppointmentApproval() {
    WorkbenchRoutes.toAppointmentApproval();
  }

  /// 进入任务详情页。
  void openTaskProgressDetail() {
    WorkbenchRoutes.toTaskProgressDetail();
  }

  /// 进入工作台入口。
  void openEntry(WorkbenchEntry entry) {
    entry.onTap();
  }
}

/// 工作台入口卡片数据。
class WorkbenchEntry {
  final String title;
  final int? count;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const WorkbenchEntry({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
