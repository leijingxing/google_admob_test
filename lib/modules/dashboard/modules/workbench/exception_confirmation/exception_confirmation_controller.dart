import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/components/app_info_status_card.dart';
import '../../../../../core/components/toast/toast_widget.dart';
import '../../../../../data/models/workbench/exception_confirmation_item_model.dart';
import '../../../../../data/repository/workbench_repository.dart';
import '../widgets/workbench_segment_tabs.dart';

/// 异常确认控制器。
class ExceptionConfirmationController extends GetxController {
  final WorkbenchRepository _repository = WorkbenchRepository();

  final ValueNotifier<int> refreshTrigger = ValueNotifier<int>(0);
  final TextEditingController keywordController = TextEditingController();

  final List<WorkbenchSegmentTabItem> tabItems = const [
    WorkbenchSegmentTabItem(label: '待确认'),
    WorkbenchSegmentTabItem(label: '已确认'),
  ];

  int currentTabIndex = 0;
  DateTimeRange? dateRange;

  String get pageTitle => '异常确认';

  @override
  void onClose() {
    refreshTrigger.dispose();
    keywordController.dispose();
    super.onClose();
  }

  void onTabChanged(int index) {
    if (index == currentTabIndex) return;
    currentTabIndex = index;
    update();
  }

  void applyKeyword(String value) {
    keywordController.text = value.trim();
    _applyFilters();
  }

  void applyFilters({required DateTimeRange? nextDateRange}) {
    dateRange = nextDateRange;
    _applyFilters();
  }

  Future<List<ExceptionConfirmationItemModel>> loadPageByTab(
    int tabIndex,
    int pageIndex,
    int pageSize,
  ) async {
    final result = await _repository.getExceptionConfirmationPage(
      confirmStatus: tabIndex == 0 ? 2 : 1,
      current: pageIndex,
      size: pageSize,
      keyword: keywordController.text.trim(),
      reportTimeBegin: _rangeStart(dateRange),
      reportTimeEnd: _rangeEnd(dateRange),
    );

    return result.when(
      success: (pageData) => pageData.items,
      failure: (error) {
        AppToast.showError(error.message);
        throw Exception(error.message);
      },
    );
  }

  Future<bool> confirmItem({
    required String id,
    required int isValid,
    required String remark,
  }) async {
    final result = await _repository.confirmExceptionReport(
      id: id,
      isValid: isValid,
      remark: remark,
    );

    return result.when(
      success: (_) {
        AppToast.showSuccess('确认成功');
        refreshTrigger.value++;
        return true;
      },
      failure: (error) {
        AppToast.showError(error.message);
        return false;
      },
    );
  }

  bool canConfirm(ExceptionConfirmationItemModel item) {
    return item.confirmStatus != 1 &&
        (item.confirmerId == null || item.confirmerId!.trim().isEmpty);
  }

  String statusText(int value) => value == 1 ? '已确认' : '待确认';

  String validText(int value) {
    switch (value) {
      case 1:
        return '有效';
      case 2:
        return '无效';
      default:
        return '--';
    }
  }

  AppCardStatusStyle statusStyle(int value) {
    if (value == 1) {
      return const AppCardStatusStyle(
        textColor: Color(0xFF0E8C4C),
        backgroundColor: Color(0xFFE7F8EE),
        borderColor: Color(0xFFB8E8CC),
      );
    }
    return const AppCardStatusStyle(
      textColor: Color(0xFFE07A34),
      backgroundColor: Color(0xFFFFF1E8),
      borderColor: Color(0xFFF6D0B8),
    );
  }

  void _applyFilters() {
    update();
    refreshTrigger.value++;
  }

  String? _rangeStart(DateTimeRange? range) {
    if (range == null) return null;
    final date = range.start;
    return '${date.year}-${_pad2(date.month)}-${_pad2(date.day)} 00:00:00';
  }

  String? _rangeEnd(DateTimeRange? range) {
    if (range == null) return null;
    final date = range.end;
    return '${date.year}-${_pad2(date.month)}-${_pad2(date.day)} 23:59:59';
  }

  String _pad2(int value) => value.toString().padLeft(2, '0');
}
