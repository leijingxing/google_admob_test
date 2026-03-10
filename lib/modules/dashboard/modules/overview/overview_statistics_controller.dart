import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 总览统计控制器：维护筛选状态与统计展示数据。
class OverviewStatisticsController extends GetxController {
  /// 园区下拉选项。
  final List<String> parkOptions = const ['全部园区', '一园区', '二园区', '三园区'];

  /// 今日预约情况：单位选项。
  final List<String> reservationUnitOptions = const ['全部单位', '一园区', '二园区', '三园区'];

  /// 危化品入园统计筛选：园区。
  String hazardousInPark = '全部园区';

  /// 危化品出园统计筛选：园区。
  String hazardousOutPark = '全部园区';

  /// 危化品入园统计筛选：日期范围。
  DateTimeRange? hazardousInRange;

  /// 危化品出园统计筛选：日期范围。
  DateTimeRange? hazardousOutRange;

  /// 今日预约情况：选中单位。
  String selectedReservationUnit = '全部单位';

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
        YardMetric(value: '207/423', label: '入/出园车辆'),
        YardMetric(value: '140/327', label: '入/出园次数'),
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
        YardMetric(value: '207/423', label: '入/出园车辆'),
        YardMetric(value: '140/327', label: '入/出园次数'),
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
        YardMetric(value: '207/423', label: '入/出园车辆'),
        YardMetric(value: '140/327', label: '入/出园次数'),
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

  /// 今日预约概览指标。
  List<ReservationSummaryMetric> get reservationSummaryMetrics => const [
    ReservationSummaryMetric(value: '0', label: '人员'),
    ReservationSummaryMetric(value: '245', label: '普通车辆'),
    ReservationSummaryMetric(value: '121', label: '危化车辆'),
    ReservationSummaryMetric(value: '0', label: '危废车辆'),
    ReservationSummaryMetric(value: '8/366', label: '待审批/已提交'),
  ];

  /// 今日预约折线数据。
  List<ReservationTrendSeries> get reservationTrendSeries => const [
    ReservationTrendSeries(
      label: '人员',
      color: Color(0xFF4C7DFF),
      points: [
        ReservationTrendPoint(time: '00:00', value: 0),
        ReservationTrendPoint(time: '02:00', value: 0),
        ReservationTrendPoint(time: '04:00', value: 0),
        ReservationTrendPoint(time: '06:00', value: 0),
        ReservationTrendPoint(time: '08:00', value: 0),
        ReservationTrendPoint(time: '10:00', value: 0),
        ReservationTrendPoint(time: '12:00', value: 0),
        ReservationTrendPoint(time: '14:00', value: 0),
        ReservationTrendPoint(time: '16:00', value: 0),
        ReservationTrendPoint(time: '18:00', value: 0),
        ReservationTrendPoint(time: '20:00', value: 0),
        ReservationTrendPoint(time: '22:00', value: 0),
      ],
    ),
    ReservationTrendSeries(
      label: '普通车辆',
      color: Color(0xFF59D3B4),
      points: [
        ReservationTrendPoint(time: '00:00', value: 6),
        ReservationTrendPoint(time: '02:00', value: 2),
        ReservationTrendPoint(time: '04:00', value: 0),
        ReservationTrendPoint(time: '06:00', value: 0),
        ReservationTrendPoint(time: '08:00', value: 24),
        ReservationTrendPoint(time: '10:00', value: 29),
        ReservationTrendPoint(time: '12:00', value: 16),
        ReservationTrendPoint(time: '13:00', value: 41),
        ReservationTrendPoint(time: '14:00', value: 31),
        ReservationTrendPoint(time: '15:00', value: 3),
        ReservationTrendPoint(time: '16:00', value: 0),
        ReservationTrendPoint(time: '22:00', value: 0),
      ],
    ),
    ReservationTrendSeries(
      label: '危化车辆',
      color: Color(0xFFE4A32A),
      points: [
        ReservationTrendPoint(time: '00:00', value: 0),
        ReservationTrendPoint(time: '02:00', value: 0),
        ReservationTrendPoint(time: '04:00', value: 0),
        ReservationTrendPoint(time: '06:00', value: 0),
        ReservationTrendPoint(time: '07:00', value: 8),
        ReservationTrendPoint(time: '08:00', value: 20),
        ReservationTrendPoint(time: '09:00', value: 15),
        ReservationTrendPoint(time: '10:00', value: 16),
        ReservationTrendPoint(time: '11:00', value: 14),
        ReservationTrendPoint(time: '12:00', value: 12),
        ReservationTrendPoint(time: '13:00', value: 6),
        ReservationTrendPoint(time: '14:00', value: 9),
        ReservationTrendPoint(time: '15:00', value: 0),
        ReservationTrendPoint(time: '22:00', value: 0),
      ],
    ),
    ReservationTrendSeries(
      label: '危废车辆',
      color: Color(0xFFFF7B2F),
      points: [
        ReservationTrendPoint(time: '00:00', value: 0),
        ReservationTrendPoint(time: '06:00', value: 0),
        ReservationTrendPoint(time: '12:00', value: 0),
        ReservationTrendPoint(time: '18:00', value: 0),
        ReservationTrendPoint(time: '22:00', value: 0),
      ],
    ),
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

  /// 更新今日预约情况单位筛选。
  void onReservationUnitChanged(String? value) {
    if (value == null) return;
    selectedReservationUnit = value;
    update();
  }

  /// 刷新今日预约情况。
  void refreshReservationTrend() {
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

/// 今日预约概览指标。
class ReservationSummaryMetric {
  final String value;
  final String label;

  const ReservationSummaryMetric({required this.value, required this.label});
}

/// 今日预约趋势图系列。
class ReservationTrendSeries {
  final String label;
  final Color color;
  final List<ReservationTrendPoint> points;

  const ReservationTrendSeries({
    required this.label,
    required this.color,
    required this.points,
  });
}

/// 今日预约趋势图点位。
class ReservationTrendPoint {
  final String time;
  final double value;

  const ReservationTrendPoint({required this.time, required this.value});
}
