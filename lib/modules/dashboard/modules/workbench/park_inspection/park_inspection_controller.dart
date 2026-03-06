import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/components/toast/toast_widget.dart';
import '../../../../../data/models/workbench/park_inspection_plan_item_model.dart';
import '../../../../../data/models/workbench/park_inspection_task_item_model.dart';
import '../../../../../data/repository/workbench_repository.dart';
import '../widgets/workbench_segment_tabs.dart';

abstract class ParkInspectionTaskStatus {
  static const String pending = 'PENDING';
  static const String inProgress = 'IN_PROGRESS';
  static const String completed = 'COMPLETED';
  static const String cancelled = 'CANCELLED';
}

class ParkInspectionOption {
  const ParkInspectionOption({required this.label, required this.value});

  final String label;
  final String? value;
}

class ParkInspectionController extends GetxController {
  final WorkbenchRepository _repository = WorkbenchRepository();

  final ValueNotifier<int> refreshTrigger = ValueNotifier<int>(0);
  final TextEditingController keywordController = TextEditingController();

  final List<WorkbenchSegmentTabItem> tabItems = const [
    WorkbenchSegmentTabItem(label: '待执行'),
    WorkbenchSegmentTabItem(label: '执行中'),
    WorkbenchSegmentTabItem(label: '已完成'),
    WorkbenchSegmentTabItem(label: '已取消'),
  ];

  final List<ParkInspectionOption> typeOptions = const [
    ParkInspectionOption(label: '全部类型', value: null),
    ParkInspectionOption(label: '设备巡检', value: 'EQUIPMENT'),
    ParkInspectionOption(label: '安全巡检', value: 'SAFETY'),
    ParkInspectionOption(label: '环保巡检', value: 'ENVIRONMENT'),
    ParkInspectionOption(label: '人员行为巡检', value: 'PERSONNEL'),
    ParkInspectionOption(label: '日常巡检', value: 'DAILY'),
    ParkInspectionOption(label: '自动化巡检', value: 'AUTOMATION'),
  ];

  final List<ParkInspectionOption> dispatchOptions = const [
    ParkInspectionOption(label: '全部派发', value: null),
    ParkInspectionOption(label: '自动派发', value: 'AUTO'),
    ParkInspectionOption(label: '手动派发', value: 'MANUAL_WEB'),
    ParkInspectionOption(label: 'APP派发', value: 'MANUAL_APP'),
  ];

  int currentTabIndex = 0;
  String? selectedTypeCode;
  String? selectedDispatchType;
  DateTimeRange? dateRange;

  bool dispatchLoading = false;
  bool dispatchSubmitting = false;
  List<ParkInspectionPlanItemModel> dispatchPlans =
      const <ParkInspectionPlanItemModel>[];

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
    refreshTrigger.value++;
  }

  void applyKeyword(String value) {
    keywordController.text = value.trim();
    update();
    refreshTrigger.value++;
  }

  void applyFilters({
    required String? nextTypeCode,
    required String? nextDispatchType,
    required DateTimeRange? nextDateRange,
  }) {
    selectedTypeCode = nextTypeCode;
    selectedDispatchType = nextDispatchType;
    dateRange = nextDateRange;
    update();
    refreshTrigger.value++;
  }

  Future<List<ParkInspectionTaskItemModel>> loadPageByTab(
    int tabIndex,
    int pageIndex,
    int pageSize,
  ) async {
    final result = await _repository.getParkInspectionTaskPage(
      current: pageIndex,
      size: pageSize,
      taskCode: keywordController.text.trim(),
      taskStatus: _tabStatus(tabIndex),
      typeCode: selectedTypeCode,
      dispatchType: selectedDispatchType,
      taskDateBegin: dateRange == null ? null : _formatDate(dateRange!.start),
      taskDateEnd: dateRange == null ? null : _formatDate(dateRange!.end),
    );

    return result.when(
      success: (data) => data.items,
      failure: (error) {
        AppToast.showError(error.message);
        throw Exception(error.message);
      },
    );
  }

  Future<void> loadDispatchPlans() async {
    if (dispatchLoading) return;
    dispatchLoading = true;
    update();
    final result = await _repository.getParkInspectionPlans();
    result.when(
      success: (data) {
        dispatchPlans = data
            .where((item) => (item.configStatus ?? '').trim() == 'COMPLETE')
            .toList();
      },
      failure: (error) => AppToast.showError(error.message),
    );
    dispatchLoading = false;
    update();
  }

  Future<bool> dispatchTask({
    required String planId,
    required String taskDate,
  }) async {
    if (dispatchSubmitting) return false;
    dispatchSubmitting = true;
    update();
    final result = await _repository.dispatchParkInspectionTask(
      planId: planId,
      taskDate: taskDate,
    );
    dispatchSubmitting = false;
    update();
    return result.when(
      success: (_) {
        AppToast.showSuccess('派发成功');
        refreshTrigger.value++;
        return true;
      },
      failure: (error) {
        AppToast.showError(error.message);
        return false;
      },
    );
  }

  void refreshPage() {
    refreshTrigger.value++;
  }

  String taskStatusText(String? value) {
    switch ((value ?? '').trim()) {
      case ParkInspectionTaskStatus.pending:
        return '待执行';
      case ParkInspectionTaskStatus.inProgress:
        return '执行中';
      case ParkInspectionTaskStatus.completed:
        return '已完成';
      case ParkInspectionTaskStatus.cancelled:
        return '已取消';
      default:
        return '--';
    }
  }

  String resultStatusText(String? value) {
    switch ((value ?? '').trim()) {
      case 'NORMAL':
        return '正常';
      case 'ABNORMAL':
        return '异常';
      default:
        return '待检查';
    }
  }

  String typeText(String? value) {
    for (final item in typeOptions) {
      if (item.value == value) return item.label;
    }
    return value?.trim().isNotEmpty == true ? value!.trim() : '--';
  }

  String dispatchTypeText(String? value) {
    for (final item in dispatchOptions) {
      if (item.value == value) return item.label;
    }
    return value?.trim().isNotEmpty == true ? value!.trim() : '--';
  }

  Color taskStatusColor(String? value) {
    switch ((value ?? '').trim()) {
      case ParkInspectionTaskStatus.pending:
        return const Color(0xFF4A84F5);
      case ParkInspectionTaskStatus.inProgress:
        return const Color(0xFFEAA53A);
      case ParkInspectionTaskStatus.completed:
        return const Color(0xFF22A06B);
      case ParkInspectionTaskStatus.cancelled:
        return const Color(0xFF8A97A8);
      default:
        return const Color(0xFF7B8798);
    }
  }

  Color resultStatusColor(String? value) {
    switch ((value ?? '').trim()) {
      case 'NORMAL':
        return const Color(0xFF22A06B);
      case 'ABNORMAL':
        return const Color(0xFFE06A4B);
      default:
        return const Color(0xFF8A97A8);
    }
  }

  String primaryActionText(ParkInspectionTaskItemModel item) {
    switch ((item.taskStatus ?? '').trim()) {
      case ParkInspectionTaskStatus.pending:
        return '执行';
      case ParkInspectionTaskStatus.inProgress:
        return '继续执行';
      default:
        return '查看';
    }
  }

  String _tabStatus(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return ParkInspectionTaskStatus.pending;
      case 1:
        return ParkInspectionTaskStatus.inProgress;
      case 2:
        return ParkInspectionTaskStatus.completed;
      default:
        return ParkInspectionTaskStatus.cancelled;
    }
  }

  String _formatDate(DateTime value) {
    return '${value.year}-${_pad2(value.month)}-${_pad2(value.day)}';
  }

  String _pad2(int value) => value.toString().padLeft(2, '0');
}
