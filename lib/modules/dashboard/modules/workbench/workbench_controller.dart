import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/components/toast/toast_widget.dart';
import '../../../../data/repository/workbench_repository.dart';

/// 工作台页面控制器。
class WorkbenchController extends GetxController {
  final WorkbenchRepository _workbenchRepository = WorkbenchRepository();

  /// 任务进度百分比（0~100），用于展示文案与进度圈。
  double taskProgressPercent = 0;

  /// 工作台快捷入口（演示数据）。
  final List<WorkbenchQuickAction> quickActions = const [
    WorkbenchQuickAction(
      title: '待处理任务',
      subtitle: '查看今日待办事项',
      icon: Icons.assignment_turned_in_rounded,
      color: Color(0xFF1E88E5),
    ),
    WorkbenchQuickAction(
      title: '消息通知',
      subtitle: '查看系统预警和公告',
      icon: Icons.notifications_active_rounded,
      color: Color(0xFFEF6C00),
    ),
    WorkbenchQuickAction(
      title: '快捷查询',
      subtitle: '按条件快速检索业务数据',
      icon: Icons.manage_search_rounded,
      color: Color(0xFF2E7D32),
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    fetchTaskProgress();
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
}

/// 工作台快捷入口卡片数据。
class WorkbenchQuickAction {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const WorkbenchQuickAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}
