import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/components/toast/toast_widget.dart';
import '../../../../../data/models/workbench/appointment_approval_item_model.dart';
import '../../../../../data/repository/workbench_repository.dart';
import '../widgets/workbench_segment_tabs.dart';

/// 预约审批控制器。
class AppointmentApprovalController extends GetxController {
  final WorkbenchRepository _workbenchRepository = WorkbenchRepository();

  /// 顶部 Tab：待审批 / 已审批。
  final List<WorkbenchSegmentTabItem> tabItems = const [
    WorkbenchSegmentTabItem(label: '待审批'),
    WorkbenchSegmentTabItem(label: '已审批'),
  ];

  /// 当前选中的 Tab 索引。
  int currentTabIndex = 0;

  /// 预约类型筛选：null 表示全部。
  int? reservationType;

  /// 状态筛选：null 表示全部。
  int? parkCheckStatus;

  /// 时间区间筛选。
  DateTimeRange? dateRange;

  /// 关键字筛选。
  String keywords = '';

  /// 列表数据。
  List<AppointmentApprovalItemModel> items = const [];

  /// 列表加载中。
  bool isLoading = false;

  /// 预约类型选项。
  final List<WorkbenchFilterOption<int?>> reservationTypeOptions = const [
    WorkbenchFilterOption(label: '预约类型', value: null),
    WorkbenchFilterOption(label: '来访人员', value: 1),
    WorkbenchFilterOption(label: '普通车辆', value: 2),
    WorkbenchFilterOption(label: '危化车辆', value: 3),
    WorkbenchFilterOption(label: '危废车辆', value: 4),
    WorkbenchFilterOption(label: '普通货车', value: 5),
  ];

  /// 状态选项。
  final List<WorkbenchFilterOption<int?>> statusOptions = const [
    WorkbenchFilterOption(label: '状态', value: null),
    WorkbenchFilterOption(label: '待审批', value: 0),
    WorkbenchFilterOption(label: '已审批', value: 1),
    WorkbenchFilterOption(label: '已拒绝', value: 2),
    WorkbenchFilterOption(label: '已过期', value: 3),
  ];

  @override
  void onInit() {
    super.onInit();
    fetchList();
  }

  /// 切换顶部 Tab 并刷新列表。
  Future<void> onTabChanged(int index) async {
    if (currentTabIndex == index) return;
    currentTabIndex = index;
    update();
    await fetchList();
  }

  /// 更新预约类型筛选并刷新列表。
  Future<void> onReservationTypeChanged(int? value) async {
    reservationType = value;
    update();
    await fetchList();
  }

  /// 更新状态筛选并刷新列表。
  Future<void> onStatusChanged(int? value) async {
    parkCheckStatus = value;
    update();
    await fetchList();
  }

  /// 选择时间区间并刷新列表。
  Future<void> pickDateRange(BuildContext context) async {
    final now = DateTime.now();
    final result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 1),
      initialDateRange: dateRange,
      helpText: '选择开始日期-结束日期',
    );
    if (result == null) return;
    dateRange = result;
    update();
    await fetchList();
  }

  /// 拉取预约审批列表。
  Future<void> fetchList() async {
    isLoading = true;
    update();

    final result = await _workbenchRepository.getReservationApprovePage(
      approvePageType: currentTabIndex == 0 ? 2 : 3,
      current: 1,
      size: 20,
      reservationType: reservationType,
      parkCheckStatus: parkCheckStatus,
      keywords: keywords,
      beginTime: dateRange == null ? null : _formatDateTime(dateRange!.start),
      endTime: dateRange == null ? null : _formatDateTime(dateRange!.end),
    );

    result.when(
      success: (pageData) {
        items = pageData.items;
      },
      failure: (error) {
        items = const [];
        AppToast.showError(error.message);
      },
    );

    isLoading = false;
    update();
  }

  /// 时间范围显示文案。
  String get dateRangeText {
    if (dateRange == null) return '开始时间 - 结束时间';
    return '${_formatDate(dateRange!.start)} - ${_formatDate(dateRange!.end)}';
  }

  /// 预约类型文案。
  String reservationTypeText(int type) {
    switch (type) {
      case 1:
        return '来访人员';
      case 2:
        return '普通车辆';
      case 3:
        return '危化车辆';
      case 4:
        return '危废车辆';
      case 5:
        return '普通货车';
      default:
        return '未知类型';
    }
  }

  /// 状态文案。
  String statusText(int status) {
    switch (status) {
      case 0:
        return '待园区审批';
      case 1:
        return '已审批';
      case 2:
        return '已拒绝';
      case 3:
        return '已过期';
      default:
        return '未知状态';
    }
  }

  /// 提交时间文案，优先 submitTime。
  String submitTimeText(AppointmentApprovalItemModel item) {
    return item.submitTime ?? item.createTime ?? '--';
  }

  String _formatDateTime(DateTime date) {
    return '${date.year}-${_pad2(date.month)}-${_pad2(date.day)} ${_pad2(date.hour)}:${_pad2(date.minute)}:${_pad2(date.second)}';
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }

  String _pad2(int value) => value.toString().padLeft(2, '0');
}

class WorkbenchFilterOption<T> {
  final String label;
  final T value;

  const WorkbenchFilterOption({required this.label, required this.value});
}
