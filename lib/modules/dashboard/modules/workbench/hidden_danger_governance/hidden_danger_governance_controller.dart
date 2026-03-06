import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/workbench_segment_tabs.dart';

/// 隐患治理控制器。
class HiddenDangerGovernanceController extends GetxController {
  final ValueNotifier<int> refreshTrigger = ValueNotifier<int>(0);
  final TextEditingController keywordController = TextEditingController();

  final List<WorkbenchSegmentTabItem> tabItems = const [
    WorkbenchSegmentTabItem(label: '待治理'),
    WorkbenchSegmentTabItem(label: '已治理'),
  ];

  final List<HiddenDangerBoolOption> emergencyOptions = const [
    HiddenDangerBoolOption(label: '是否紧急', value: null),
    HiddenDangerBoolOption(label: '是', value: true),
    HiddenDangerBoolOption(label: '否', value: false),
  ];

  final List<HiddenDangerStatusOption> _pendingStatusOptions = const [
    HiddenDangerStatusOption(label: '请选择状态', value: null),
    HiddenDangerStatusOption(label: '待确认', value: 0),
    HiddenDangerStatusOption(label: '待整改', value: 1),
  ];

  final List<HiddenDangerStatusOption> _doneStatusOptions = const [
    HiddenDangerStatusOption(label: '请选择状态', value: null),
    HiddenDangerStatusOption(label: '已整改', value: 2),
    HiddenDangerStatusOption(label: '已关闭', value: 3),
  ];

  int currentTabIndex = 0;
  bool? selectedEmergency;
  int? selectedStatus;
  DateTimeRange? dateRange;

  static final List<HiddenDangerGovernanceItem> _mockItems =
      <HiddenDangerGovernanceItem>[
        HiddenDangerGovernanceItem(
          pointName: '巡检点位A-01',
          abnormalDesc: '临时堆放区域未设置警戒线',
          reporter: '张三',
          reportTime: DateTime(2026, 3, 6, 9, 30, 0),
          urgent: true,
          status: 0,
        ),
        HiddenDangerGovernanceItem(
          pointName: '巡检点位B-02',
          abnormalDesc: '消防通道有占用现象',
          reporter: '李四',
          reportTime: DateTime(2026, 3, 5, 16, 20, 0),
          urgent: false,
          status: 1,
        ),
        HiddenDangerGovernanceItem(
          pointName: '巡检点位C-03',
          abnormalDesc: '危化品标识缺失',
          reporter: '王五',
          reportTime: DateTime(2026, 3, 4, 14, 8, 0),
          urgent: true,
          status: 1,
        ),
        HiddenDangerGovernanceItem(
          pointName: '巡检点位D-04',
          abnormalDesc: '照明设施损坏已修复',
          reporter: '赵六',
          reportTime: DateTime(2026, 3, 3, 10, 45, 0),
          urgent: false,
          status: 2,
        ),
        HiddenDangerGovernanceItem(
          pointName: '巡检点位E-05',
          abnormalDesc: '排水沟堵塞已处理',
          reporter: '钱七',
          reportTime: DateTime(2026, 3, 2, 11, 15, 0),
          urgent: false,
          status: 2,
        ),
        HiddenDangerGovernanceItem(
          pointName: '巡检点位F-06',
          abnormalDesc: '设备护栏松动，现场复查关闭',
          reporter: '孙八',
          reportTime: DateTime(2026, 3, 1, 8, 40, 0),
          urgent: true,
          status: 3,
        ),
      ];

  List<HiddenDangerStatusOption> get statusOptions =>
      currentTabIndex == 0 ? _pendingStatusOptions : _doneStatusOptions;

  @override
  void onClose() {
    refreshTrigger.dispose();
    keywordController.dispose();
    super.onClose();
  }

  void onTabChanged(int index) {
    if (currentTabIndex == index) return;
    currentTabIndex = index;
    final currentValues = statusOptions.map((item) => item.value).toSet();
    if (!currentValues.contains(selectedStatus)) {
      selectedStatus = null;
    }
    update();
  }

  void applyFilters({
    required bool? nextEmergency,
    required int? nextStatus,
    required String nextKeywords,
    required DateTimeRange? nextDateRange,
  }) {
    selectedEmergency = nextEmergency;
    selectedStatus = nextStatus;
    keywordController.text = nextKeywords.trim();
    dateRange = nextDateRange;
    update();
    _triggerRefresh();
  }

  void onDateRangeSelected(DateTime? start, DateTime? end) {
    if (start == null && end == null) {
      dateRange = null;
    } else if (start != null && end != null) {
      final sortedStart = start.isBefore(end) ? start : end;
      final sortedEnd = start.isBefore(end) ? end : start;
      dateRange = DateTimeRange(start: sortedStart, end: sortedEnd);
    } else {
      final date = start ?? end!;
      dateRange = DateTimeRange(start: date, end: date);
    }
    update();
    _triggerRefresh();
  }

  void clearDateRange() {
    dateRange = null;
    update();
    _triggerRefresh();
  }

  void applyKeyword(String value) {
    keywordController.text = value.trim();
    update();
    _triggerRefresh();
  }

  Future<List<HiddenDangerGovernanceItem>> loadPage(
    int pageIndex,
    int pageSize,
  ) async {
    return loadPageByTab(currentTabIndex, pageIndex, pageSize);
  }

  Future<List<HiddenDangerGovernanceItem>> loadPageByTab(
    int tabIndex,
    int pageIndex,
    int pageSize,
  ) async {
    final filtered = _buildFilteredItems(tabIndex);
    final start = (pageIndex - 1) * pageSize;
    if (start >= filtered.length) {
      return const [];
    }
    final end = math.min(start + pageSize, filtered.length);
    return filtered.sublist(start, end);
  }

  String statusText(int status) {
    switch (status) {
      case 0:
        return '待确认';
      case 1:
        return '待整改';
      case 2:
        return '已整改';
      case 3:
        return '已关闭';
      default:
        return '--';
    }
  }

  String actionText(int status) {
    switch (status) {
      case 0:
        return '确认';
      case 1:
        return '整改';
      default:
        return '查看';
    }
  }

  String dateRangeText() {
    if (dateRange == null) return '开始时间 - 结束时间';
    final start = _formatDate(dateRange!.start);
    final end = _formatDate(dateRange!.end);
    return '$start - $end';
  }

  String reportTimeText(DateTime reportTime) {
    return '${_formatDate(reportTime)} ${_formatTime(reportTime)}';
  }

  String urgentText(bool urgent) => urgent ? '是' : '否';

  List<HiddenDangerGovernanceItem> _buildFilteredItems(int tabIndex) {
    final keyword = keywordController.text.trim();
    final isPendingTab = tabIndex == 0;
    final begin = dateRange?.start;
    final end = dateRange?.end;

    return _mockItems.where((item) {
      final inCurrentTab = isPendingTab
          ? (item.status == 0 || item.status == 1)
          : (item.status == 2 || item.status == 3);
      if (!inCurrentTab) return false;

      if (selectedEmergency != null && item.urgent != selectedEmergency) {
        return false;
      }

      if (selectedStatus != null && item.status != selectedStatus) {
        return false;
      }

      if (begin != null && end != null) {
        final itemDate = DateTime(
          item.reportTime.year,
          item.reportTime.month,
          item.reportTime.day,
        );
        final startDate = DateTime(begin.year, begin.month, begin.day);
        final endDate = DateTime(end.year, end.month, end.day);
        if (itemDate.isBefore(startDate) || itemDate.isAfter(endDate)) {
          return false;
        }
      }

      if (keyword.isNotEmpty) {
        final text = '${item.pointName}${item.abnormalDesc}'.toLowerCase();
        if (!text.contains(keyword.toLowerCase())) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  void _triggerRefresh() {
    refreshTrigger.value++;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${_pad2(date.month)}-${_pad2(date.day)}';
  }

  String _formatTime(DateTime date) {
    return '${_pad2(date.hour)}:${_pad2(date.minute)}';
  }

  String _pad2(int value) => value.toString().padLeft(2, '0');
}

class HiddenDangerGovernanceItem {
  final String pointName;
  final String abnormalDesc;
  final String reporter;
  final DateTime reportTime;
  final bool urgent;
  final int status;

  const HiddenDangerGovernanceItem({
    required this.pointName,
    required this.abnormalDesc,
    required this.reporter,
    required this.reportTime,
    required this.urgent,
    required this.status,
  });
}

class HiddenDangerStatusOption {
  final String label;
  final int? value;

  const HiddenDangerStatusOption({required this.label, required this.value});
}

class HiddenDangerBoolOption {
  final String label;
  final bool? value;

  const HiddenDangerBoolOption({required this.label, required this.value});
}
