import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 主页 Tab 控制器。
class DashboardController extends GetxController {
  final List<DashboardCardData> cards = const [
    DashboardCardData(
      icon: Icons.rocket_launch_outlined,
      title: '欢迎使用 Flutter Base',
      subtitle: '当前已切换为底部 Tab 首页结构，可继续扩展业务模块入口。',
    ),
    DashboardCardData(
      icon: Icons.layers_outlined,
      title: '推荐下一步',
      subtitle: '在主页补充业务看板、快捷入口、待办列表等内容。',
    ),
  ];
}

/// 首页卡片展示模型。
class DashboardCardData {
  final IconData icon;
  final String title;
  final String subtitle;

  const DashboardCardData({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
