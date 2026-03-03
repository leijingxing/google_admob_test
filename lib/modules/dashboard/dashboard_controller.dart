import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/components/toast/toast_widget.dart';

/// 主页 Tab 控制器（演示用假数据）。
class DashboardController extends GetxController {
  final String greeting = '你好，张三';
  final String weather = '杭州 18°C 多云';

  final List<DashboardStatData> stats = const [
    DashboardStatData(
      title: '今日访问',
      value: '12,640',
      trend: '+18%',
      color: Color(0xFF1967B4),
    ),
    DashboardStatData(
      title: '待处理工单',
      value: '23',
      trend: '-3%',
      color: Color(0xFF2A9D8F),
    ),
    DashboardStatData(
      title: '转化率',
      value: '64.8%',
      trend: '+2.1%',
      color: Color(0xFFEF8354),
    ),
  ];

  final List<DashboardQuickActionData> quickActions = const [
    DashboardQuickActionData(
      icon: Icons.assignment_outlined,
      title: '审批中心',
      subtitle: '3 条待处理',
    ),
    DashboardQuickActionData(
      icon: Icons.inventory_2_outlined,
      title: '商品管理',
      subtitle: '库存预警 8',
    ),
    DashboardQuickActionData(
      icon: Icons.people_alt_outlined,
      title: '客户列表',
      subtitle: '新增客户 12',
    ),
    DashboardQuickActionData(
      icon: Icons.bar_chart_outlined,
      title: '经营报表',
      subtitle: '查看本周趋势',
    ),
  ];

  final List<DashboardTodoData> todos = const [
    DashboardTodoData(title: '完成春季活动页验收', time: '10:30', priority: '高'),
    DashboardTodoData(title: '跟进供应链对账单确认', time: '14:00', priority: '中'),
    DashboardTodoData(title: '输出本周增长复盘结论', time: '17:30', priority: '高'),
  ];

  final List<DashboardProjectData> projects = const [
    DashboardProjectData(name: '商城改版 3.0', progress: 0.78, owner: '产品组'),
    DashboardProjectData(name: '会员中心重构', progress: 0.46, owner: '客户端组'),
    DashboardProjectData(name: '营销引擎优化', progress: 0.62, owner: '增长组'),
  ];

  final List<DashboardActivityData> activities = const [
    DashboardActivityData(
      title: '订单峰值达到 2,341 单',
      desc: '较昨日同期增长 14.3%，建议关注高峰时段履约。',
      time: '5 分钟前',
    ),
    DashboardActivityData(
      title: '首页 Banner 已发布',
      desc: '运营位已更新春季主题素材，A/B 方案并行。',
      time: '28 分钟前',
    ),
    DashboardActivityData(
      title: '库存告警已触发',
      desc: 'SKU 38271、38298 低于安全库存阈值。',
      time: '1 小时前',
    ),
  ];

  void onQuickActionTap(DashboardQuickActionData item) {
    AppToast.showInfo('已点击「${item.title}」，当前为 Demo 假数据页。');
  }

  void onTodoTap(DashboardTodoData item) {
    AppToast.showInfo('待办「${item.title}」已标记为已读（演示）。');
  }
}

class DashboardStatData {
  final String title;
  final String value;
  final String trend;
  final Color color;

  const DashboardStatData({
    required this.title,
    required this.value,
    required this.trend,
    required this.color,
  });
}

class DashboardQuickActionData {
  final IconData icon;
  final String title;
  final String subtitle;

  const DashboardQuickActionData({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

class DashboardTodoData {
  final String title;
  final String time;
  final String priority;

  const DashboardTodoData({
    required this.title,
    required this.time,
    required this.priority,
  });
}

class DashboardProjectData {
  final String name;
  final double progress;
  final String owner;

  const DashboardProjectData({
    required this.name,
    required this.progress,
    required this.owner,
  });
}

class DashboardActivityData {
  final String title;
  final String desc;
  final String time;

  const DashboardActivityData({
    required this.title,
    required this.desc,
    required this.time,
  });
}
