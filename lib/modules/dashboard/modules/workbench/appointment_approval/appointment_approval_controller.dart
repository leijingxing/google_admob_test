import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/components/toast/toast_widget.dart';
import '../../../../../core/utils/user_manager.dart';
import '../../../../../data/models/workbench/appointment_approval_item_model.dart';
import '../../../../../data/repository/workbench_repository.dart';
import '../widgets/workbench_segment_tabs.dart';

/// 预约审批控制器。
class AppointmentApprovalController extends GetxController {
  final WorkbenchRepository _workbenchRepository = WorkbenchRepository();
  final ValueNotifier<int> refreshTrigger = ValueNotifier<int>(0);

  /// 顶部 Tab：根据当前身份显示企业或园区审批维度。
  List<WorkbenchSegmentTabItem> get tabItems {
    if (isCompanyUser) {
      return const [
        WorkbenchSegmentTabItem(label: '企业待审批'),
        WorkbenchSegmentTabItem(label: '企业已审批'),
      ];
    }
    if (isParkUser) {
      return const [
        WorkbenchSegmentTabItem(label: '园区待审批'),
        WorkbenchSegmentTabItem(label: '园区已审批'),
      ];
    }
    return const [
      WorkbenchSegmentTabItem(label: '待审批'),
      WorkbenchSegmentTabItem(label: '已审批'),
    ];
  }

  int currentTabIndex = 0;
  int? reservationType;
  int? selectedStatus;
  DateTimeRange? dateRange;
  String keywords = '';

  final List<WorkbenchFilterOption<int?>> reservationTypeOptions = const [
    WorkbenchFilterOption(label: '全部', value: null),
    WorkbenchFilterOption(label: '人员', value: 1),
    WorkbenchFilterOption(label: '普通车', value: 2),
    WorkbenchFilterOption(label: '危化车', value: 3),
    WorkbenchFilterOption(label: '危废车', value: 4),
    WorkbenchFilterOption(label: '货车', value: 5),
  ];

  bool get isCompanyUser => UserManager.isCompanyUser;

  bool get isParkUser => UserManager.isParkUser;

  int get pendingStatusCode => isCompanyUser ? 0 : 3;

  List<int> get approvedStatusCodes =>
      isCompanyUser ? const [1, 2] : const [4, 5];

  List<WorkbenchFilterOption<int?>> get statusOptions {
    if (currentTabIndex == 0) {
      return const [WorkbenchFilterOption(label: '全部', value: null)];
    }

    return [
      const WorkbenchFilterOption(label: '全部', value: null),
      WorkbenchFilterOption<int?>(label: statusText(1), value: 1),
      WorkbenchFilterOption<int?>(label: statusText(2), value: 2),
    ];
  }

  @override
  void onClose() {
    refreshTrigger.dispose();
    super.onClose();
  }

  Future<void> onTabChanged(int index) async {
    if (currentTabIndex == index) return;
    currentTabIndex = index;
    selectedStatus = _normalizeStatus(selectedStatus, index);
    update();
  }

  void applyFilters({
    required int? nextReservationType,
    required int? nextStatus,
  }) {
    reservationType = nextReservationType;
    selectedStatus = _normalizeStatus(nextStatus, currentTabIndex);
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

  Future<List<AppointmentApprovalItemModel>> loadPage(
    int pageIndex,
    int pageSize,
  ) async {
    return loadPageByTab(currentTabIndex, pageIndex, pageSize);
  }

  Future<List<AppointmentApprovalItemModel>> loadPageByTab(
    int tabIndex,
    int pageIndex,
    int pageSize,
  ) async {
    final result = await _workbenchRepository.getReservationApprovePage(
      approvePageType: _approvePageTypeByTab(tabIndex),
      current: pageIndex,
      size: pageSize,
      reservationType: reservationType,
      status: _effectiveStatus(tabIndex),
      keywords: keywords,
      beginTime: dateRange == null ? null : _formatDateTime(dateRange!.start),
      endTime: dateRange == null ? null : _formatDateTime(dateRange!.end),
    );

    return result.when(
      success: (pageData) => pageData.items,
      failure: (error) {
        AppToast.showError(error.message);
        throw Exception(error.message);
      },
    );
  }

  String get dateRangeText {
    if (dateRange == null) return '开始时间 - 结束时间';
    return '${_formatDate(dateRange!.start)} - ${_formatDate(dateRange!.end)}';
  }

  String reservationTypeText(int type) {
    switch (type) {
      case 1:
        return '人员';
      case 2:
        return '普通车';
      case 3:
        return '危化车';
      case 4:
        return '危废车';
      case 5:
        return '货车';
      default:
        return '未知类型';
    }
  }

  String statusText(int status) {
    switch (status) {
      case 0:
        return '待审批';
      case 1:
        return '已通过';
      case 2:
        return '已拒绝';
      case 6:
        return '已过期';
      default:
        return '未知状态';
    }
  }

  /// 显示状态按当前审批主体取审核字段，不直接使用总状态 status。
  int resolveStatus(AppointmentApprovalItemModel item) {
    if (item.status == 6) {
      return 6;
    }
    return isCompanyUser ? item.companyCheckStatus : item.parkCheckStatus;
  }

  bool canApprove(AppointmentApprovalItemModel item) {
    if (item.status == 6) {
      return false;
    }
    if (isCompanyUser) {
      return item.companyCheckStatus == 0;
    }
    return item.parkCheckStatus == 0;
  }

  String submitTimeText(AppointmentApprovalItemModel item) {
    return item.createDate ?? '--';
  }

  String _formatDateTime(DateTime date) {
    return '${date.year}-${_pad2(date.month)}-${_pad2(date.day)} ${_pad2(date.hour)}:${_pad2(date.minute)}:${_pad2(date.second)}';
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }

  String _pad2(int value) => value.toString().padLeft(2, '0');

  int _approvePageTypeByTab(int tabIndex) {
    if (isCompanyUser) {
      return tabIndex == 0 ? 0 : 1;
    }
    return tabIndex == 0 ? 2 : 3;
  }

  int? _effectiveStatus(int tabIndex) {
    if (tabIndex == 0) {
      return pendingStatusCode;
    }
    return _normalizeStatus(selectedStatus, 1);
  }

  int? _normalizeStatus(int? status, int tabIndex) {
    if (tabIndex == 0) {
      return status == pendingStatusCode ? pendingStatusCode : null;
    }
    if (status != null && approvedStatusCodes.contains(status)) {
      return status;
    }
    return null;
  }

  void _triggerRefresh() {
    refreshTrigger.value++;
  }

  void refreshCurrentList() {
    _triggerRefresh();
  }
}

class WorkbenchFilterOption<T> {
  final String label;
  final T value;

  const WorkbenchFilterOption({required this.label, required this.value});
}
