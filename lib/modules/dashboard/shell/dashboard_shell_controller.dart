import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Dashboard 封闭式容器页控制器。
class DashboardShellController extends GetxController {
  static const double sidebarWidth = 54;
  static const double sidebarItemHeight = 68;
  static const double sidebarItemIconBoxSize = 30;
  static const double sidebarItemIconSize = 15;

  final List<DashboardShellModuleItem> modules = const [
    DashboardShellModuleItem(
      title: '工作台',
      subtitle: '日常任务与快捷入口',
      icon: Icons.space_dashboard_rounded,
      color: Color(0xFF1E88E5),
    ),
    DashboardShellModuleItem(
      title: '总览',
      subtitle: '统计图与业务数据概览',
      icon: Icons.insights_rounded,
      color: Color(0xFF1565C0),
    ),
    DashboardShellModuleItem(
      title: '车辆查询',
      subtitle: '车辆信息与状态查询',
      icon: Icons.directions_car_filled_rounded,
      color: Color(0xFF2E7D32),
    ),
    DashboardShellModuleItem(
      title: '人员查询',
      subtitle: '人员档案与进出记录',
      icon: Icons.badge_rounded,
      color: Color(0xFFEF6C00),
    ),
    DashboardShellModuleItem(
      title: '物流查询',
      subtitle: '物流信息与轨迹跟踪',
      icon: Icons.local_shipping_rounded,
      color: Color(0xFF6A1B9A),
    ),
  ];

  int currentIndex = 0;

  DashboardShellModuleItem get currentModule => modules[currentIndex];

  @override
  void onInit() {
    super.onInit();
    final argIndex = Get.arguments is int ? Get.arguments as int : 0;
    currentIndex = argIndex.clamp(0, modules.length - 1);
  }

  /// 切换左侧模块。
  void switchModule(int index) {
    if (index == currentIndex) return;
    currentIndex = index;
    update();
  }
}

/// Dashboard 封闭页模块项。
class DashboardShellModuleItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const DashboardShellModuleItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}
