import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 总览统计控制器：维护筛选状态与统计展示数据。
class OverviewStatisticsController extends GetxController {
  /// 园区下拉选项。
  final List<String> parkOptions = const ['全部园区', '一园区', '二园区', '三园区'];

  /// 危化品入园统计筛选：园区。
  String hazardousInPark = '全部园区';

  /// 危化品出园统计筛选：园区。
  String hazardousOutPark = '全部园区';

  /// 危化品入园统计筛选：日期范围。
  DateTimeRange? hazardousInRange;

  /// 危化品出园统计筛选：日期范围。
  DateTimeRange? hazardousOutRange;

  /// 审批统计假数据。
  final List<ApprovalStatRow> approvalRows = const [
    ApprovalStatRow(
      title: '今日已审批',
      icon: Icons.task_alt_rounded,
      leftLabel: '企业',
      leftValue: '147',
      rightLabel: '园区',
      rightValue: '362',
    ),
    ApprovalStatRow(
      title: '今日新增黑名单',
      icon: Icons.person_off_rounded,
      leftLabel: '人员',
      leftValue: '0',
      rightLabel: '车辆',
      rightValue: '0',
    ),
    ApprovalStatRow(
      title: '今日新增白名单',
      icon: Icons.verified_user_rounded,
      leftLabel: '人员',
      leftValue: '13',
      rightLabel: '车辆',
      rightValue: '31',
    ),
  ];

  /// 园内统计卡片（示例数据）。
  final List<YardStatCardData> yardStats = const [
    YardStatCardData(
      title: '危化车辆统计',
      metrics: [
        YardMetric(value: '67', label: '当前在园'),
        YardMetric(value: '207/423', label: '入园/出园车辆'),
        YardMetric(value: '140/327', label: '入园/出园次数'),
      ],
    ),
    YardStatCardData(
      title: '危化品统计(吨/立方)',
      metrics: [
        YardMetric(value: '207', label: '入园'),
        YardMetric(value: '140', label: '出园'),
        YardMetric(value: '92963', label: '累计入园'),
        YardMetric(value: '158694', label: '累计出园'),
        YardMetric(value: '23', label: '种类'),
      ],
    ),
    YardStatCardData(
      title: '危废车辆统计',
      metrics: [
        YardMetric(value: '67', label: '当前在园'),
        YardMetric(value: '207/423', label: '入园/出园车辆'),
        YardMetric(value: '140/327', label: '入园/出园次数'),
      ],
    ),
    YardStatCardData(
      title: '危废物统计(吨/立方)',
      metrics: [
        YardMetric(value: '207', label: '入园'),
        YardMetric(value: '140', label: '出园'),
        YardMetric(value: '92963', label: '累计入园'),
        YardMetric(value: '158694', label: '累计出园'),
        YardMetric(value: '13', label: '种类'),
      ],
    ),
    YardStatCardData(
      title: '货车统计',
      metrics: [
        YardMetric(value: '67', label: '当前在园'),
        YardMetric(value: '207/423', label: '入园/出园车辆'),
        YardMetric(value: '140/327', label: '入园/出园次数'),
      ],
    ),
    YardStatCardData(
      title: '货物统计(吨/立方)',
      metrics: [
        YardMetric(value: '207', label: '入园'),
        YardMetric(value: '140', label: '出园'),
        YardMetric(value: '92963', label: '累计入园'),
        YardMetric(value: '158694', label: '累计出园'),
        YardMetric(value: '43', label: '种类'),
      ],
    ),
    YardStatCardData(
      title: '人员统计',
      metrics: [YardMetric(value: '67', label: '入园人员')],
    ),
    YardStatCardData(
      title: '待审批统计',
      metrics: [
        YardMetric(value: '67', label: '企业'),
        YardMetric(value: '207', label: '园区'),
      ],
    ),
  ];

  /// 危化品入园饼图数据（示例）。
  List<PiePoint> get hazardousInPie => const [
    PiePoint(name: '易燃液体', value: 38),
    PiePoint(name: '压缩气体', value: 24),
    PiePoint(name: '腐蚀品', value: 20),
    PiePoint(name: '其他', value: 18),
  ];

  /// 危化品出园饼图数据（示例）。
  List<PiePoint> get hazardousOutPie => const [
    PiePoint(name: '易燃液体', value: 33),
    PiePoint(name: '压缩气体', value: 27),
    PiePoint(name: '腐蚀品', value: 22),
    PiePoint(name: '其他', value: 18),
  ];

  /// 更新入园统计园区筛选。
  void onHazardousInParkChanged(String? value) {
    if (value == null) return;
    hazardousInPark = value;
    update();
  }

  /// 更新出园统计园区筛选。
  void onHazardousOutParkChanged(String? value) {
    if (value == null) return;
    hazardousOutPark = value;
    update();
  }

  /// 选择入园统计时间范围。
  Future<void> pickHazardousInRange(BuildContext context) async {
    final now = DateTime.now();
    final result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 1),
      initialDateRange: hazardousInRange,
      helpText: '选择开始日期-结束日期',
    );
    if (result == null) return;
    hazardousInRange = result;
    update();
  }

  /// 选择出园统计时间范围。
  Future<void> pickHazardousOutRange(BuildContext context) async {
    final now = DateTime.now();
    final result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 1),
      initialDateRange: hazardousOutRange,
      helpText: '选择开始日期-结束日期',
    );
    if (result == null) return;
    hazardousOutRange = result;
    update();
  }

  /// 入园统计时间范围文案。
  String get hazardousInRangeText => _rangeText(hazardousInRange);

  /// 出园统计时间范围文案。
  String get hazardousOutRangeText => _rangeText(hazardousOutRange);

  String _rangeText(DateTimeRange? range) {
    if (range == null) return '开始日期-结束日期';
    final start = '${range.start.year}-${range.start.month}-${range.start.day}';
    final end = '${range.end.year}-${range.end.month}-${range.end.day}';
    return '$start ~ $end';
  }
}

/// 饼图点位数据。
class PiePoint {
  final String name;
  final num value;

  const PiePoint({required this.name, required this.value});
}

/// 审批统计行数据。
class ApprovalStatRow {
  final String title;
  final IconData icon;
  final String leftLabel;
  final String leftValue;
  final String rightLabel;
  final String rightValue;

  const ApprovalStatRow({
    required this.title,
    required this.icon,
    required this.leftLabel,
    required this.leftValue,
    required this.rightLabel,
    required this.rightValue,
  });
}

/// 园内统计卡片数据。
class YardStatCardData {
  final String title;
  final List<YardMetric> metrics;

  const YardStatCardData({required this.title, required this.metrics});
}

/// 园内统计指标。
class YardMetric {
  final String value;
  final String label;

  const YardMetric({required this.value, required this.label});
}
