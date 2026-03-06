import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/components/app_info_status_card.dart';
import '../../../../../core/components/toast/toast_widget.dart';
import '../../../../../data/models/workbench/risk_warning_disposal_item_model.dart';
import '../../../../../data/repository/workbench_repository.dart';
import '../widgets/workbench_segment_tabs.dart';

/// 报警处置控制器。
class AlarmDisposalController extends GetxController {
  final WorkbenchRepository _repository = WorkbenchRepository();
  final ValueNotifier<int> refreshTrigger = ValueNotifier<int>(0);
  final TextEditingController keywordController = TextEditingController();

  final List<WorkbenchSegmentTabItem> tabItems = const [
    WorkbenchSegmentTabItem(label: '持续中'),
    WorkbenchSegmentTabItem(label: '已销警'),
  ];

  final List<AlarmWarningLevelOption> levelOptions = const [
    AlarmWarningLevelOption(label: '全部等级', value: null),
    AlarmWarningLevelOption(label: '红色', value: 1),
    AlarmWarningLevelOption(label: '橙色', value: 2),
    AlarmWarningLevelOption(label: '黄色', value: 3),
    AlarmWarningLevelOption(label: '蓝色', value: 4),
    AlarmWarningLevelOption(label: '无等级', value: 0),
  ];

  int currentTabIndex = 0;
  int? selectedWarningLevel;
  DateTimeRange? dateRange;

  String get pageTitle => '报警处置';

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

  void applyFilters({
    required int? nextWarningLevel,
    required DateTimeRange? nextDateRange,
  }) {
    selectedWarningLevel = nextWarningLevel;
    dateRange = nextDateRange;
    _applyFilters();
  }

  void applyKeyword(String value) {
    keywordController.text = value.trim();
    _applyFilters();
  }

  Future<List<RiskWarningDisposalItemModel>> loadPageByTab(
    int tabIndex,
    int pageIndex,
    int pageSize,
  ) async {
    final result = await _repository.getRiskWarningDisposalPage(
      warningType: 2,
      warningStatus: tabIndex == 0 ? 0 : 1,
      current: pageIndex,
      size: pageSize,
      keyword: keywordController.text.trim(),
      warningLevel: selectedWarningLevel,
      warningStartTimeBegin: _rangeStart(dateRange),
      warningStartTimeEnd: _rangeEnd(dateRange),
      warningEndTimeBegin: null,
      warningEndTimeEnd: null,
    );

    return result.when(
      success: (pageData) => pageData.items,
      failure: (error) {
        AppToast.showError(error.message);
        throw Exception(error.message);
      },
    );
  }

  String warningLevelText(int value) {
    switch (value) {
      case 1:
        return '红色';
      case 2:
        return '橙色';
      case 3:
        return '黄色';
      case 4:
        return '蓝色';
      case 0:
        return '无等级';
      default:
        return value <= 0 ? '--' : '等级$value';
    }
  }

  String statusText(int value) => value == 1 ? '已销警' : '持续中';

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

class AlarmWarningLevelOption {
  final String label;
  final int? value;

  const AlarmWarningLevelOption({required this.label, required this.value});
}
