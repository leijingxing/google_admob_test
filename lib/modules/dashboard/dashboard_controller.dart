import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../router/module_routes/dashboard_routes.dart';

/// 主页控制器：管理首页五大模块入口。
class DashboardController extends GetxController {
  final List<DashboardModuleItem> modules = const [
    DashboardModuleItem(
      title: '工作台',
      subtitle: '日常任务与快捷入口',
      icon: Icons.space_dashboard_rounded,
      color: Color(0xFF1E88E5),
    ),
    DashboardModuleItem(
      title: '车辆查询',
      subtitle: '车辆信息与状态查询',
      icon: Icons.directions_car_filled_rounded,
      color: Color(0xFF2E7D32),
    ),
    DashboardModuleItem(
      title: '人员查询',
      subtitle: '人员档案与进出记录',
      icon: Icons.badge_rounded,
      color: Color(0xFFEF6C00),
    ),
    DashboardModuleItem(
      title: '物流查询',
      subtitle: '物流信息与轨迹跟踪',
      icon: Icons.local_shipping_rounded,
      color: Color(0xFF6A1B9A),
    ),
    DashboardModuleItem(
      title: '总览',
      subtitle: '统计图与业务数据概览',
      icon: Icons.insights_rounded,
      color: Color(0xFF1565C0),
    ),
  ];

  /// 化工安全小贴士（首页演示数据）。
  final List<SafetyTipItem> safetyTips = const [
    SafetyTipItem(
      title: '入园车辆必须按指定线路行驶',
      content: '危化车辆进园后请遵循电子围栏路线，严禁在禁停区长时间停留。',
    ),
    SafetyTipItem(
      title: '危化品装卸前先核验作业票',
      content: '确认作业票、人员资质和现场防护措施后，再执行装卸流程。',
    ),
    SafetyTipItem(
      title: '遇到告警信息先确认再处置',
      content: '接到异常告警后，先核对车辆与人员位置，再联动值守人员处理。',
    ),
  ];

  /// 点击模块入口。
  void onTapModule(int index) {
    switch (index) {
      case 0:
        DashboardRoutes.toWorkbench();
        return;
      case 1:
        DashboardRoutes.toVehicleQuery();
        return;
      case 2:
        DashboardRoutes.toPersonnelQuery();
        return;
      case 3:
        DashboardRoutes.toLogisticsQuery();
        return;
      case 4:
        DashboardRoutes.toOverview();
        return;
      default:
        return;
    }
  }
}

/// 首页模块卡片数据。
class DashboardModuleItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const DashboardModuleItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

/// 首页小贴士数据。
class SafetyTipItem {
  final String title;
  final String content;

  const SafetyTipItem({required this.title, required this.content});
}
