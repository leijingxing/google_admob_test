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
