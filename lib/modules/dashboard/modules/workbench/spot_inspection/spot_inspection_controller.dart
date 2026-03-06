import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/components/toast/toast_widget.dart';
import '../../../../../data/models/workbench/spot_inspection_item_model.dart';
import '../../../../../data/repository/workbench_repository.dart';
import '../widgets/workbench_segment_tabs.dart';

/// 车辆抽检工作台控制器。
class SpotInspectionController extends GetxController {
  final WorkbenchRepository _repository = WorkbenchRepository();
  final ValueNotifier<int> refreshTrigger = ValueNotifier<int>(0);

  final List<WorkbenchSegmentTabItem> tabItems = const [
    WorkbenchSegmentTabItem(label: '待抽检'),
    WorkbenchSegmentTabItem(label: '已抽检'),
  ];

  final TextEditingController keywordController = TextEditingController();

  int currentTabIndex = 0;
  DateTimeRange? dateRange;
  int pendingCount = 0;
  int passCount = 0;
  int failCount = 0;

  @override
  void onInit() {
    super.onInit();
    loadStatistics();
  }

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

  Future<void> loadStatistics() async {
    final result = await _repository.getSpotInspectionStatistics();
    result.when(
      success: (data) {
        pendingCount = _toInt(data['toBeSampled']);
        passCount = _toInt(data['pass']);
        failCount = _toInt(data['notPass']);
        update();
      },
      failure: (error) => AppToast.showError(error.message),
    );
  }

  Future<List<SpotInspectionItemModel>> loadPageByTab(
    int tabIndex,
    int pageIndex,
    int pageSize,
  ) async {
    final result = await _repository.getSpotInspectionPage(
      current: pageIndex,
      size: pageSize,
      keyword: keywordController.text.trim(),
      strCheckTime: dateRange == null
          ? null
          : _formatDateTime(dateRange!.start, startOfDay: true),
      endCheckTime: dateRange == null
          ? null
          : _formatDateTime(dateRange!.end, startOfDay: false),
      checkType: tabIndex == 0 ? '0' : '1',
    );

    return result.when(
      success: (data) => data.items,
      failure: (error) {
        AppToast.showError(error.message);
        throw Exception(error.message);
      },
    );
  }

  String vehicleStatusText(SpotInspectionItemModel item) {
    final custom = (item.parkStatusName ?? '').trim();
    if (custom.isNotEmpty) return custom;
    switch ((item.enter ?? item.parkStatus ?? '').trim()) {
      case '0':
        return '待入园';
      case '1':
        return '已入园';
      default:
        return currentTabIndex == 0 ? '待抽检' : '已抽检';
    }
  }

  String goodsTypeText(SpotInspectionItemModel item) {
    return _firstNonEmpty(item.goodsTypeName, item.goodsName);
  }

  String reservationTimeText(SpotInspectionItemModel item) {
    return _firstNonEmpty(
      item.validityBeginTime,
      item.validityEndTime,
      item.estimatedInTime,
      item.reservationTime,
      item.securityCheckTime,
    );
  }

  String resultText(String? result) {
    if ((result ?? '').trim() == '1') return '通过';
    if ((result ?? '').trim() == '0') return '不通过';
    return '待抽检';
  }

  void refreshPage() {
    loadStatistics();
    refreshTrigger.value++;
  }

  void _applyFilters() {
    update();
    refreshTrigger.value++;
  }

  int _toInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse((value ?? '').toString()) ?? 0;
  }

  String _firstNonEmpty([
    Object? a,
    Object? b,
    Object? c,
    Object? d,
    Object? e,
  ]) {
    for (final value in <Object?>[a, b, c, d, e]) {
      final text = value?.toString().trim() ?? '';
      if (text.isNotEmpty && text.toLowerCase() != 'null') return text;
    }
    return '--';
  }

  String _formatDateTime(DateTime date, {required bool startOfDay}) {
    final value = startOfDay
        ? DateTime(date.year, date.month, date.day, 0, 0, 0)
        : DateTime(date.year, date.month, date.day, 23, 59, 59);
    return '${value.year}-${_pad2(value.month)}-${_pad2(value.day)} ${_pad2(value.hour)}:${_pad2(value.minute)}:${_pad2(value.second)}';
  }

  String _pad2(int value) => value.toString().padLeft(2, '0');
}
