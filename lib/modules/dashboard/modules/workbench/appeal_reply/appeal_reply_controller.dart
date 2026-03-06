import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/components/toast/toast_widget.dart';
import '../../../../../data/models/workbench/appeal_reply_item_model.dart';
import '../../../../../data/repository/workbench_repository.dart';
import '../widgets/workbench_segment_tabs.dart';

/// 申诉回复页面控制器。
class AppealReplyController extends GetxController {
  final WorkbenchRepository _repository = WorkbenchRepository();
  final ValueNotifier<int> refreshTrigger = ValueNotifier<int>(0);

  final List<WorkbenchSegmentTabItem> tabItems = const [
    WorkbenchSegmentTabItem(label: '申诉中'),
    WorkbenchSegmentTabItem(label: '已通过'),
    WorkbenchSegmentTabItem(label: '不通过'),
  ];

  final TextEditingController keywordController = TextEditingController();

  int currentTabIndex = 0;
  DateTimeRange? dateRange;

  @override
  void onClose() {
    refreshTrigger.dispose();
    keywordController.dispose();
    super.onClose();
  }

  void onTabChanged(int index) {
    if (currentTabIndex == index) return;
    currentTabIndex = index;
    update();
  }

  void onDateRangeSelected(DateTime? start, DateTime? end) {
    if (start == null || end == null) {
      dateRange = null;
    } else {
      final sortedStart = start.isBefore(end) ? start : end;
      final sortedEnd = start.isBefore(end) ? end : start;
      dateRange = DateTimeRange(start: sortedStart, end: sortedEnd);
    }
    _applyFilters();
  }

  void applyKeyword(String value) {
    keywordController.text = value.trim();
    _applyFilters();
  }

  Future<List<AppealReplyItemModel>> loadPageByTab(
    int tabIndex,
    int pageIndex,
    int pageSize,
  ) async {
    final result = await _repository.getAppealRecordPage(
      current: pageIndex,
      size: pageSize,
      status: _statusByTab(tabIndex),
      keywords: keywordController.text.trim(),
      appealTimeBegin: dateRange == null
          ? null
          : _formatDateTime(dateRange!.start),
      appealTimeEnd: dateRange == null ? null : _formatDateTime(dateRange!.end),
    );

    return result.when(
      success: (pageData) => pageData.items,
      failure: (error) {
        AppToast.showError(error.message);
        throw Exception(error.message);
      },
    );
  }

  int _statusByTab(int tabIndex) {
    switch (tabIndex) {
      case 1:
        return 1;
      case 2:
        return 2;
      default:
        return 0;
    }
  }

  String appealTypeText(int value) {
    switch (value) {
      case 1:
        return '违规申诉';
      case 2:
        return '拉黑申诉';
      default:
        return '未知类型';
    }
  }

  String statusText(int value) {
    switch (value) {
      case 1:
        return '已通过';
      case 2:
        return '不通过';
      default:
        return '申诉中';
    }
  }

  bool canReply(AppealReplyItemModel item) {
    return item.status == 0 || item.status == 2;
  }

  void triggerRefresh() {
    _triggerRefresh();
    update();
  }

  void _applyFilters() {
    update();
    _triggerRefresh();
  }

  void _triggerRefresh() {
    refreshTrigger.value++;
  }

  String _formatDateTime(DateTime date) {
    return '${date.year}-${_pad2(date.month)}-${_pad2(date.day)} '
        '${_pad2(date.hour)}:${_pad2(date.minute)}:${_pad2(date.second)}';
  }

  String _pad2(int value) => value.toString().padLeft(2, '0');
}
