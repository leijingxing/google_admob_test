import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/components/log_util.dart';
import '../../../../../core/components/toast/toast_widget.dart';
import '../../../../../core/utils/user_manager.dart';
import '../../../../../data/models/workbench/inspection_abnormal_item_model.dart';
import '../../../../../data/models/workbench/inspection_rectification_item_model.dart';
import '../../../../../data/repository/workbench_repository.dart';
import '../widgets/workbench_segment_tabs.dart';

/// 巡检异常状态枚举值。
abstract class HiddenDangerAbnormalStatus {
  static const String pendingConfirm = 'PENDING_CONFIRM';
  static const String pendingRectify = 'PENDING_RECTIFY';
  static const String rectifying = 'RECTIFYING';
  static const String pendingVerify = 'PENDING_VERIFY';
  static const String completed = 'COMPLETED';
  static const String reassign = 'REASSIGN';
}

/// 隐患治理控制器。
class HiddenDangerGovernanceController extends GetxController {
  final WorkbenchRepository _repository = WorkbenchRepository();

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
    HiddenDangerStatusOption(
      label: '待确认',
      value: HiddenDangerAbnormalStatus.pendingConfirm,
    ),
    HiddenDangerStatusOption(
      label: '待整改',
      value: HiddenDangerAbnormalStatus.pendingRectify,
    ),
    HiddenDangerStatusOption(
      label: '整改中',
      value: HiddenDangerAbnormalStatus.rectifying,
    ),
    HiddenDangerStatusOption(
      label: '待核查',
      value: HiddenDangerAbnormalStatus.pendingVerify,
    ),
    HiddenDangerStatusOption(
      label: '待重新指派',
      value: HiddenDangerAbnormalStatus.reassign,
    ),
  ];

  final List<HiddenDangerStatusOption> _doneStatusOptions = const [
    HiddenDangerStatusOption(label: '请选择状态', value: null),
    HiddenDangerStatusOption(
      label: '已完成',
      value: HiddenDangerAbnormalStatus.completed,
    ),
  ];

  final Map<String, List<InspectionRectificationItemModel>>
  _rectificationsCache = <String, List<InspectionRectificationItemModel>>{};

  Map<String, String> pointNameMap = <String, String>{};
  Map<String, String> ruleNameMap = <String, String>{};

  int currentTabIndex = 0;
  bool? selectedEmergency;
  String? selectedStatus;
  DateTimeRange? dateRange;

  List<HiddenDangerStatusOption> get statusOptions =>
      currentTabIndex == 0 ? _pendingStatusOptions : _doneStatusOptions;

  @override
  void onInit() {
    super.onInit();
    unawaited(loadNameMaps());
  }

  @override
  void onClose() {
    refreshTrigger.dispose();
    keywordController.dispose();
    super.onClose();
  }

  /// 加载点位与细则名称映射。
  Future<void> loadNameMaps() async {
    final pointResult = await _repository.getInspectionPointNameMap();
    pointResult.when(
      success: (data) => pointNameMap = data,
      failure: (error) {
        AppLog.warning('加载巡检点位失败: ${error.message}');
      },
    );

    final ruleResult = await _repository.getInspectionRuleNameMap();
    ruleResult.when(
      success: (data) => ruleNameMap = data,
      failure: (error) {
        AppLog.warning('加载巡检细则失败: ${error.message}');
      },
    );
    update();
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
    required String? nextStatus,
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

  Future<List<InspectionAbnormalItemModel>> loadPageByTab(
    int tabIndex,
    int pageIndex,
    int pageSize,
  ) async {
    final result = await _repository.getInspectionAbnormalPage(
      current: pageIndex,
      size: pageSize,
      keywords: keywordController.text.trim(),
      abnormalStatus: selectedStatus,
      isUrgent: _urgentParam(selectedEmergency),
      beginTime: rangeStartTime(dateRange),
      endTime: rangeEndTime(dateRange),
    );

    return result.when(
      success: (page) => page.items
          .where((item) => _isInCurrentTab(item.abnormalStatus, tabIndex))
          .toList(),
      failure: (error) {
        AppToast.showError(error.message);
        throw Exception(error.message);
      },
    );
  }

  /// 加载异常整改记录。
  Future<List<InspectionRectificationItemModel>> loadRectifications({
    required String abnormalId,
    bool forceRefresh = false,
  }) async {
    final key = abnormalId.trim();
    if (key.isEmpty) return const <InspectionRectificationItemModel>[];
    if (!forceRefresh && _rectificationsCache.containsKey(key)) {
      return _rectificationsCache[key]!;
    }

    final result = await _repository.getInspectionRectifications(
      abnormalId: key,
    );
    return result.when(
      success: (list) {
        _rectificationsCache[key] = list;
        return list;
      },
      failure: (error) {
        AppToast.showError(error.message);
        throw Exception(error.message);
      },
    );
  }

  /// 根据异常状态判断主操作按钮文案。
  String actionText(String? abnormalStatus) {
    switch (abnormalStatus) {
      case HiddenDangerAbnormalStatus.pendingConfirm:
        return '确认';
      case HiddenDangerAbnormalStatus.pendingRectify:
      case HiddenDangerAbnormalStatus.rectifying:
        return '整改';
      case HiddenDangerAbnormalStatus.pendingVerify:
        return '核查';
      case HiddenDangerAbnormalStatus.reassign:
        return '指派';
      default:
        return '查看';
    }
  }

  String statusText(String? abnormalStatus) {
    switch (abnormalStatus) {
      case HiddenDangerAbnormalStatus.pendingConfirm:
        return '待确认';
      case HiddenDangerAbnormalStatus.pendingRectify:
        return '待整改';
      case HiddenDangerAbnormalStatus.rectifying:
        return '整改中';
      case HiddenDangerAbnormalStatus.pendingVerify:
        return '待核查';
      case HiddenDangerAbnormalStatus.completed:
        return '已完成';
      case HiddenDangerAbnormalStatus.reassign:
        return '待重新指派';
      default:
        return '--';
    }
  }

  String urgentText(String? isUrgent) => isUrgent == '1' ? '是' : '否';

  String dateRangeText() {
    if (dateRange == null) return '开始时间 - 结束时间';
    final start = _formatDate(dateRange!.start);
    final end = _formatDate(dateRange!.end);
    return '$start - $end';
  }

  String displayPointName(InspectionAbnormalItemModel item) {
    final pointName = (item.pointName ?? '').trim();
    if (pointName.isNotEmpty) return pointName;
    final pointId = (item.pointId ?? '').trim();
    if (pointId.isEmpty) return '--';
    return pointNameMap[pointId] ?? pointId;
  }

  String displayRuleName(InspectionAbnormalItemModel item) {
    final ruleName = (item.ruleName ?? '').trim();
    if (ruleName.isNotEmpty) return ruleName;
    final ruleId = (item.ruleId ?? '').trim();
    if (ruleId.isEmpty) return '--';
    return ruleNameMap[ruleId] ?? ruleId;
  }

  String displayReporterName(InspectionAbnormalItemModel item) {
    final value = (item.reporterName ?? '').trim();
    return value.isEmpty ? '--' : value;
  }

  String displayAbnormalDesc(InspectionAbnormalItemModel item) {
    final value = (item.abnormalDesc ?? '').trim();
    return value.isEmpty ? '--' : value;
  }

  String displayReportTime(InspectionAbnormalItemModel item) {
    final value = (item.reportTime ?? '').trim();
    return value.isEmpty ? '--' : value;
  }

  String displayPhotoSummary(List<String>? photoUrls) {
    if (photoUrls == null || photoUrls.isEmpty) return '0';
    return '${photoUrls.length}张';
  }

  bool canShowPrimaryAction(String? abnormalStatus) {
    return abnormalStatus == HiddenDangerAbnormalStatus.pendingConfirm ||
        abnormalStatus == HiddenDangerAbnormalStatus.pendingRectify ||
        abnormalStatus == HiddenDangerAbnormalStatus.rectifying ||
        abnormalStatus == HiddenDangerAbnormalStatus.pendingVerify ||
        abnormalStatus == HiddenDangerAbnormalStatus.reassign;
  }

  Future<bool> confirmAbnormal({
    required InspectionAbnormalItemModel item,
    required String verifyResult,
    String? responsibleType,
    String? responsibleId,
    String? responsibleName,
    String? rectifyUserId,
    String? rectifyUserName,
    String? deadline,
  }) async {
    final abnormalId = (item.id ?? '').trim();
    if (abnormalId.isEmpty) {
      AppToast.showWarning('异常ID为空，无法确认');
      return false;
    }

    final currentUser = UserManager.user;
    final result = await _repository.confirmInspectionAbnormal(
      abnormalId: abnormalId,
      verifyResult: verifyResult,
      verifierId: (currentUser?.id ?? '').trim(),
      verifierName: (currentUser?.userName ?? '').trim(),
      responsibleType: responsibleType,
      responsibleId: responsibleId,
      responsibleName: responsibleName,
      rectifyUserId: rectifyUserId,
      rectifyUserName: rectifyUserName,
      deadline: deadline,
    );

    return result.when(
      success: (_) {
        AppToast.showSuccess('确认成功');
        _triggerRefresh();
        return true;
      },
      failure: (error) {
        AppToast.showError(error.message);
        return false;
      },
    );
  }

  Future<bool> submitRectification({
    required InspectionAbnormalItemModel item,
    required String rectifyUserId,
    required String rectifyUserName,
    required String rectifyDesc,
    List<String>? photoUrls,
  }) async {
    final abnormalId = (item.id ?? '').trim();
    if (abnormalId.isEmpty) {
      AppToast.showWarning('异常ID为空，无法提交整改');
      return false;
    }

    final result = await _repository.submitInspectionRectification(
      abnormalId: abnormalId,
      rectifyUserId: rectifyUserId,
      rectifyUserName: rectifyUserName,
      rectifyDesc: rectifyDesc,
      photoUrls: photoUrls,
    );

    return result.when(
      success: (_) {
        AppToast.showSuccess('提交整改成功');
        _rectificationsCache.remove(abnormalId);
        _triggerRefresh();
        return true;
      },
      failure: (error) {
        AppToast.showError(error.message);
        return false;
      },
    );
  }

  Future<bool> verifyRectification({
    required InspectionAbnormalItemModel item,
    required String rectificationId,
    required String verifyResult,
    String? verifyComment,
  }) async {
    final abnormalId = (item.id ?? '').trim();
    if (abnormalId.isEmpty) {
      AppToast.showWarning('异常ID为空，无法核查整改');
      return false;
    }

    final currentUser = UserManager.user;
    final result = await _repository.verifyInspectionRectification(
      abnormalId: abnormalId,
      rectificationId: rectificationId,
      verifyResult: verifyResult,
      verifyComment: verifyComment,
      verifierId: (currentUser?.id ?? '').trim(),
      verifierName: (currentUser?.userName ?? '').trim(),
    );

    return result.when(
      success: (_) {
        AppToast.showSuccess('核查成功');
        _rectificationsCache.remove(abnormalId);
        _triggerRefresh();
        return true;
      },
      failure: (error) {
        AppToast.showError(error.message);
        return false;
      },
    );
  }

  Future<bool> reassignAbnormal({
    required InspectionAbnormalItemModel item,
    required String newRectifyUserId,
    required String newRectifyUserName,
    String? reassignReason,
  }) async {
    final abnormalId = (item.id ?? '').trim();
    if (abnormalId.isEmpty) {
      AppToast.showWarning('异常ID为空，无法重新指派');
      return false;
    }

    final result = await _repository.reassignInspectionAbnormal(
      abnormalId: abnormalId,
      newRectifyUserId: newRectifyUserId,
      newRectifyUserName: newRectifyUserName,
      reassignReason: reassignReason,
    );

    return result.when(
      success: (_) {
        AppToast.showSuccess('重新指派成功');
        _rectificationsCache.remove(abnormalId);
        _triggerRefresh();
        return true;
      },
      failure: (error) {
        AppToast.showError(error.message);
        return false;
      },
    );
  }

  InspectionRectificationItemModel? pickLatestPendingVerifyRectification(
    List<InspectionRectificationItemModel> records,
  ) {
    if (records.isEmpty) return null;
    for (final item in records) {
      if ((item.status ?? '').trim() == 'PENDING_VERIFY') {
        return item;
      }
    }
    return records.last;
  }

  String rectifyTypeText(String? rectifyType) {
    switch (rectifyType) {
      case 'INITIAL':
        return '初始整改';
      case 'REJECT':
        return '驳回重改';
      case 'REASSIGN':
        return '重新指派';
      default:
        return rectifyType?.trim().isNotEmpty == true ? rectifyType! : '--';
    }
  }

  String verifyResultText(String? verifyResult) {
    switch (verifyResult) {
      case 'PASS':
        return '通过';
      case 'REJECT':
        return '驳回';
      default:
        return verifyResult?.trim().isNotEmpty == true ? verifyResult! : '--';
    }
  }

  String rectifyStatusText(String? status) {
    switch (status) {
      case 'PENDING_VERIFY':
        return '待核查';
      case 'PASSED':
        return '已通过';
      case 'REJECTED':
        return '已驳回';
      default:
        return status?.trim().isNotEmpty == true ? status! : '--';
    }
  }

  String? rangeStartTime(DateTimeRange? range) {
    if (range == null) return null;
    return _formatDateTime(
      DateTime(range.start.year, range.start.month, range.start.day, 0, 0, 0),
    );
  }

  String? rangeEndTime(DateTimeRange? range) {
    if (range == null) return null;
    return _formatDateTime(
      DateTime(range.end.year, range.end.month, range.end.day, 23, 59, 59),
    );
  }

  bool _isInCurrentTab(String? abnormalStatus, int tabIndex) {
    final value = (abnormalStatus ?? '').trim();
    if (tabIndex == 1) {
      return value == HiddenDangerAbnormalStatus.completed;
    }
    return value == HiddenDangerAbnormalStatus.pendingConfirm ||
        value == HiddenDangerAbnormalStatus.pendingRectify ||
        value == HiddenDangerAbnormalStatus.rectifying ||
        value == HiddenDangerAbnormalStatus.pendingVerify ||
        value == HiddenDangerAbnormalStatus.reassign ||
        value.isEmpty;
  }

  String? _urgentParam(bool? value) {
    if (value == null) return null;
    return value ? '1' : '0';
  }

  void _triggerRefresh() {
    refreshTrigger.value++;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${_pad2(date.month)}-${_pad2(date.day)}';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${_pad2(dateTime.month)}-${_pad2(dateTime.day)} '
        '${_pad2(dateTime.hour)}:${_pad2(dateTime.minute)}:${_pad2(dateTime.second)}';
  }

  String _pad2(int value) => value.toString().padLeft(2, '0');
}

class HiddenDangerStatusOption {
  final String label;
  final String? value;

  const HiddenDangerStatusOption({required this.label, required this.value});
}

class HiddenDangerBoolOption {
  final String label;
  final bool? value;

  const HiddenDangerBoolOption({required this.label, required this.value});
}
