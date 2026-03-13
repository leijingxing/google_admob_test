import 'package:flutter/material.dart';

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

/// 企业情况概览条目。
class EnterpriseOverviewItem {
  final int index;
  final String companyName;
  final String ownerName;
  final String phone;
  final String pendingCount;
  final String approvedCount;
  final String newBlacklistCount;
  final String newWhitelistCount;
  final String onDutyEmployeeCount;

  const EnterpriseOverviewItem({
    required this.index,
    required this.companyName,
    required this.ownerName,
    required this.phone,
    required this.pendingCount,
    required this.approvedCount,
    required this.newBlacklistCount,
    required this.newWhitelistCount,
    required this.onDutyEmployeeCount,
  });
}
