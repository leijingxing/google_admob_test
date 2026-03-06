import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/components/toast/toast_widget.dart';
import '../../../../../data/models/workbench/whitelist_approval_item_model.dart';
import '../../../../../data/repository/workbench_repository.dart';
import '../widgets/workbench_segment_tabs.dart';

/// 白名单审批页面控制器。
class WhitelistApprovalController extends GetxController {
  final WorkbenchRepository _repository = WorkbenchRepository();
  final ValueNotifier<int> refreshTrigger = ValueNotifier<int>(0);

  final List<WorkbenchSegmentTabItem> tabItems = const [
    WorkbenchSegmentTabItem(label: '待审批'),
    WorkbenchSegmentTabItem(label: '已审批'),
  ];

  final TextEditingController keywordController = TextEditingController();

  int currentTabIndex = 0;
  int? selectedType;
  DateTimeRange? dateRange;

  final List<WhitelistApprovalTypeOption> typeOptions = const [
    WhitelistApprovalTypeOption(label: '请选择', value: null),
    WhitelistApprovalTypeOption(label: '车辆白名单', value: 2),
    WhitelistApprovalTypeOption(label: '人员白名单', value: 1),
  ];

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

  void onTypeChanged(int? value) {
    selectedType = value;
    _applyFilters();
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

  Future<List<WhitelistApprovalItemModel>> loadPageByTab(
    int tabIndex,
    int pageIndex,
    int pageSize,
  ) async {
    final result = await _repository.getWhitelistApprovePage(
      parkCheckStatus: tabIndex == 0 ? 0 : 1,
      current: pageIndex,
      size: pageSize,
      type: selectedType,
      validityBeginTime: dateRange == null
          ? null
          : _formatDateTime(dateRange!.start),
      validityEndTime: dateRange == null
          ? null
          : _formatDateTime(dateRange!.end),
      keyword: keywordController.text.trim(),
    );

    return result.when(
      success: (pageData) => pageData.items,
      failure: (error) {
        AppToast.showError(error.message);
        throw Exception(error.message);
      },
    );
  }

  String typeText(int type) {
    return type == 1 ? '人员白名单' : '车辆白名单';
  }

  String statusText(int status) {
    switch (status) {
      case 0:
        return '待审批';
      case 1:
        return '已审批';
      case 2:
        return '已拒绝';
      default:
        return '未知状态';
    }
  }

  String titleText(WhitelistApprovalItemModel item) {
    if ((item.carNumb ?? '').isNotEmpty) return item.carNumb!;
    if ((item.realName ?? '').isNotEmpty) return item.realName!;
    return '--';
  }

  String companyText(WhitelistApprovalItemModel item) {
    return item.companyName ?? item.submitBy ?? '--';
  }

  String timeText(WhitelistApprovalItemModel item) {
    return item.submitDate ?? item.parkCheckTime ?? '--';
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

class WhitelistApprovalTypeOption {
  final String label;
  final int? value;

  const WhitelistApprovalTypeOption({required this.label, required this.value});
}
