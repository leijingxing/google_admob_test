import 'package:get/get.dart';

import '../../../../../../core/http/result.dart';
import '../../../../../../core/components/toast/toast_widget.dart';
import '../../../../../../core/utils/user_manager.dart';
import '../../../../../../data/models/workbench/inspection_abnormal_item_model.dart';
import '../../../../../../data/models/workbench/park_inspection_point_item_model.dart';
import '../../../../../../data/models/workbench/park_inspection_record_detail_item_model.dart';
import '../../../../../../data/models/workbench/park_inspection_rule_item_model.dart';
import '../../../../../../data/models/workbench/park_inspection_task_item_model.dart';
import '../../../../../../data/models/workbench/park_inspection_task_record_model.dart';
import '../../../../../../data/repository/workbench_repository.dart';
import '../park_inspection_controller.dart';

class ParkInspectionRuleDraft {
  const ParkInspectionRuleDraft({
    required this.ruleId,
    required this.ruleName,
    required this.checkStandard,
    required this.checkMethod,
    this.resultStatus = '',
    this.remark = '',
    this.attachments = const <String>[],
    this.checked = false,
  });

  final String ruleId;
  final String ruleName;
  final String checkStandard;
  final String checkMethod;
  final String resultStatus;
  final String remark;
  final List<String> attachments;
  final bool checked;

  ParkInspectionRuleDraft copyWith({
    String? resultStatus,
    String? remark,
    List<String>? attachments,
    bool? checked,
  }) {
    return ParkInspectionRuleDraft(
      ruleId: ruleId,
      ruleName: ruleName,
      checkStandard: checkStandard,
      checkMethod: checkMethod,
      resultStatus: resultStatus ?? this.resultStatus,
      remark: remark ?? this.remark,
      attachments: attachments ?? this.attachments,
      checked: checked ?? this.checked,
    );
  }
}

class ParkInspectionDetailController extends GetxController {
  final WorkbenchRepository _repository = WorkbenchRepository();

  late ParkInspectionTaskItemModel item;
  bool didChange = false;

  bool loading = false;
  bool startLoading = false;
  bool completeLoading = false;

  List<ParkInspectionTaskRecordModel> records =
      const <ParkInspectionTaskRecordModel>[];
  List<ParkInspectionPointItemModel> planPoints =
      const <ParkInspectionPointItemModel>[];
  List<ParkInspectionRuleItemModel> planRules =
      const <ParkInspectionRuleItemModel>[];
  Map<String, String> inspectionRuleNameMap = <String, String>{};

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    item = args is ParkInspectionTaskItemModel
        ? args
        : const ParkInspectionTaskItemModel();
    loadData();
  }

  Future<void> loadData() async {
    final taskId = (item.id ?? '').trim();
    if (taskId.isEmpty) {
      AppToast.showWarning('缺少任务ID');
      return;
    }
    loading = true;
    update();
    await Future.wait<void>([loadRecords(), loadPlanData()]);
    loading = false;
    update();
  }

  Future<void> loadRecords() async {
    final taskId = (item.id ?? '').trim();
    if (taskId.isEmpty) return;
    final result = await _repository.getParkInspectionRecords(taskId: taskId);
    result.when(
      success: (data) => records = data,
      failure: (error) => AppToast.showError(error.message),
    );
    update();
  }

  Future<void> loadPlanData() async {
    final planId = (item.planId ?? '').trim();
    if (planId.isEmpty) return;

    final results = await Future.wait([
      _repository.getParkInspectionPlanPoints(planId: planId),
      _repository.getParkInspectionPlanRules(planId: planId),
      _repository.getParkInspectionPoints(),
      _repository.getParkInspectionRules(),
      _repository.getInspectionRuleNameMap(),
    ]);

    final planPointResult =
        results[0] as Result<List<ParkInspectionPointItemModel>>;
    final planRuleResult =
        results[1] as Result<List<ParkInspectionRuleItemModel>>;
    final allPointResult =
        results[2] as Result<List<ParkInspectionPointItemModel>>;
    final allRuleResult =
        results[3] as Result<List<ParkInspectionRuleItemModel>>;
    final inspectionRuleNameMapResult =
        results[4] as Result<Map<String, String>>;

    final pointMap = <String, ParkInspectionPointItemModel>{};
    final ruleMap = <String, ParkInspectionRuleItemModel>{};

    allPointResult.when(
      success: (data) {
        for (final item in data) {
          final key = (item.id ?? item.pointId ?? '').trim();
          if (key.isNotEmpty) pointMap[key] = item;
        }
      },
      failure: (_) {},
    );
    allRuleResult.when(
      success: (data) {
        for (final item in data) {
          final key = (item.id ?? item.ruleId ?? '').trim();
          if (key.isNotEmpty) ruleMap[key] = item;
        }
      },
      failure: (_) {},
    );
    inspectionRuleNameMapResult.when(
      success: (data) => inspectionRuleNameMap = data,
      failure: (_) {},
    );

    planPointResult.when(
      success: (data) {
        planPoints = data.map((item) {
          final key = (item.pointId ?? item.id ?? '').trim();
          final full = pointMap[key];
          return ParkInspectionPointItemModel(
            id: item.id,
            pointId: item.pointId ?? full?.pointId ?? full?.id,
            pointName: full?.pointName ?? item.pointName ?? item.pointId,
            position: full?.position ?? item.position,
            checkRadius: full?.checkRadius ?? item.checkRadius,
          );
        }).toList();
      },
      failure: (error) => AppToast.showError(error.message),
    );
    planRuleResult.when(
      success: (data) {
        planRules = data.map((item) {
          final key = (item.ruleId ?? item.id ?? '').trim();
          final full = ruleMap[key];
          return ParkInspectionRuleItemModel(
            id: item.id,
            ruleId: item.ruleId ?? full?.ruleId ?? full?.id,
            ruleName: full?.ruleName ?? item.ruleName ?? item.ruleId,
            checkStandard: full?.checkStandard ?? item.checkStandard,
            checkMethod: full?.checkMethod ?? item.checkMethod,
          );
        }).toList();
      },
      failure: (error) => AppToast.showError(error.message),
    );
    update();
  }

  Future<bool> startTask() async {
    if (startLoading) return false;
    final taskId = (item.id ?? '').trim();
    final user = UserManager.user;
    if (taskId.isEmpty || user == null) {
      AppToast.showWarning('缺少任务或用户信息');
      return false;
    }
    startLoading = true;
    update();
    final result = await _repository.startParkInspectionTask(
      taskId: taskId,
      executorId: (user.id ?? '').trim(),
      executorName: (user.userName ?? '').trim(),
    );
    startLoading = false;
    update();
    return result.when(
      success: (_) {
        AppToast.showSuccess('任务已开始');
        didChange = true;
        _replaceTaskStatus(ParkInspectionTaskStatus.inProgress);
        return true;
      },
      failure: (error) {
        AppToast.showError(error.message);
        return false;
      },
    );
  }

  Future<bool> completeTask({String? completeRemark}) async {
    if (completeLoading) return false;
    final taskId = (item.id ?? '').trim();
    final user = UserManager.user;
    if (taskId.isEmpty || user == null) {
      AppToast.showWarning('缺少任务或用户信息');
      return false;
    }
    completeLoading = true;
    update();
    final result = await _repository.completeParkInspectionTask(
      taskId: taskId,
      executorId: (user.id ?? '').trim(),
      completeRemark: completeRemark,
    );
    completeLoading = false;
    update();
    return result.when(
      success: (_) {
        AppToast.showSuccess('巡检任务已完成');
        didChange = true;
        _replaceTaskStatus(ParkInspectionTaskStatus.completed);
        return true;
      },
      failure: (error) {
        AppToast.showError(error.message);
        return false;
      },
    );
  }

  Future<bool> cancelTask({required String cancelReason}) async {
    final taskId = (item.id ?? '').trim();
    if (taskId.isEmpty) {
      AppToast.showWarning('缺少任务ID');
      return false;
    }
    final result = await _repository.cancelParkInspectionTask(
      taskId: taskId,
      cancelReason: cancelReason,
    );
    return result.when(
      success: (_) {
        AppToast.showSuccess('任务已取消');
        didChange = true;
        _replaceTaskStatus(ParkInspectionTaskStatus.cancelled);
        return true;
      },
      failure: (error) {
        AppToast.showError(error.message);
        return false;
      },
    );
  }

  Future<bool> submitCheckIn({
    required String pointId,
    required String position,
    String? remark,
  }) async {
    final taskId = (item.id ?? '').trim();
    final user = UserManager.user;
    if (taskId.isEmpty || user == null) {
      AppToast.showWarning('缺少任务或用户信息');
      return false;
    }
    final result = await _repository.checkInParkInspectionRecord(
      taskId: taskId,
      pointId: pointId,
      executorId: (user.id ?? '').trim(),
      executorName: (user.userName ?? '').trim(),
      position: position,
      remark: remark,
    );
    return result.when(
      success: (_) async {
        AppToast.showSuccess('打卡成功');
        didChange = true;
        await loadRecords();
        return true;
      },
      failure: (error) {
        AppToast.showError(error.message);
        return false;
      },
    );
  }

  Future<List<ParkInspectionRuleDraft>> buildRuleDrafts({
    required ParkInspectionTaskRecordModel record,
  }) async {
    final detailResult = await _repository.getParkInspectionRecordDetails(
      recordId: (record.id ?? '').trim(),
    );
    final checkedDetails = detailResult.when(
      success: (data) => data,
      failure: (error) {
        AppToast.showError(error.message);
        return const <ParkInspectionRecordDetailItemModel>[];
      },
    );
    final detailMap = <String, ParkInspectionRecordDetailItemModel>{};
    for (final detail in checkedDetails) {
      final key = (detail.ruleId ?? '').trim();
      if (key.isNotEmpty) detailMap[key] = detail;
    }

    return planRules.map((rule) {
      final ruleId = (rule.ruleId ?? rule.id ?? '').trim();
      final detail = detailMap[ruleId];
      return ParkInspectionRuleDraft(
        ruleId: ruleId,
        ruleName: (rule.ruleName ?? '').trim(),
        checkStandard: (rule.checkStandard ?? '').trim(),
        checkMethod: (rule.checkMethod ?? '').trim(),
        resultStatus: (detail?.resultStatus ?? '').trim(),
        remark: (detail?.remark ?? '').trim(),
        attachments: detail?.attachments ?? const <String>[],
        checked: detail != null,
      );
    }).toList();
  }

  Future<bool> submitCheckRules({
    required ParkInspectionTaskRecordModel record,
    required List<ParkInspectionRuleDraft> drafts,
  }) async {
    final taskId = (item.id ?? '').trim();
    if (taskId.isEmpty) {
      AppToast.showWarning('缺少任务ID');
      return false;
    }
    final toSubmit = drafts.where((item) => !item.checked).toList();
    if (toSubmit.isEmpty) {
      AppToast.showWarning('没有需要提交的检查项');
      return false;
    }
    if (toSubmit.any((item) => item.resultStatus.trim().isEmpty)) {
      AppToast.showWarning('请为所有待提交细则选择检查结果');
      return false;
    }
    if (toSubmit.any(
      (item) => item.resultStatus == 'FAIL' && item.attachments.isEmpty,
    )) {
      AppToast.showWarning('检查结果为不通过的细则必须上传附件照片');
      return false;
    }

    final payload = toSubmit
        .map(
          (rule) => <String, dynamic>{
            'recordId': (record.id ?? '').trim(),
            'taskId': taskId,
            'ruleId': rule.ruleId,
            'resultStatus': rule.resultStatus,
            'remark': rule.remark,
            'attachments': rule.attachments
                .where((item) => item.trim().isNotEmpty)
                .join(','),
          },
        )
        .toList();

    final result = await _repository.checkParkInspectionRules(payload: payload);
    return result.when(
      success: (_) async {
        AppToast.showSuccess('细则检查提交成功');
        didChange = true;
        await loadRecords();
        return true;
      },
      failure: (error) {
        AppToast.showError(error.message);
        return false;
      },
    );
  }

  Future<bool> reportAbnormal({
    required ParkInspectionTaskRecordModel record,
    required String ruleId,
    required String abnormalDesc,
    required String isUrgent,
    required List<String> photoUrls,
  }) async {
    final taskId = (item.id ?? '').trim();
    final pointId = (record.pointId ?? '').trim();
    final user = UserManager.user;
    if (taskId.isEmpty || pointId.isEmpty || user == null) {
      AppToast.showWarning('缺少必要参数');
      return false;
    }
    final result = await _repository.reportParkInspectionAbnormal(
      taskId: taskId,
      recordId: (record.id ?? '').trim(),
      pointId: pointId,
      ruleId: ruleId,
      reporterId: (user.id ?? '').trim(),
      reporterName: (user.userName ?? '').trim(),
      abnormalDesc: abnormalDesc,
      photoUrls: photoUrls,
      isUrgent: isUrgent,
    );
    return result.when(
      success: (_) async {
        AppToast.showSuccess('异常上报成功');
        didChange = true;
        await loadRecords();
        return true;
      },
      failure: (error) {
        AppToast.showError(error.message);
        return false;
      },
    );
  }

  Future<List<InspectionAbnormalItemModel>> loadAbnormals({
    String? recordId,
  }) async {
    final taskId = (item.id ?? '').trim();
    if (taskId.isEmpty) return const <InspectionAbnormalItemModel>[];
    final result = await _repository.getParkInspectionAbnormals(
      taskId: taskId,
      recordId: recordId,
    );
    return result.when(
      success: (data) => data,
      failure: (error) {
        AppToast.showError(error.message);
        return const <InspectionAbnormalItemModel>[];
      },
    );
  }

  Future<List<ParkInspectionRecordDetailItemModel>> loadRecordDetails({
    required String recordId,
  }) async {
    final result = await _repository.getParkInspectionRecordDetails(
      recordId: recordId,
    );
    return result.when(
      success: (data) => data
          .map(
            (item) => ParkInspectionRecordDetailItemModel(
              id: item.id,
              recordId: item.recordId,
              ruleId: item.ruleId,
              ruleName: item.ruleName ?? ruleNameById(item.ruleId),
              resultStatus: item.resultStatus,
              remark: item.remark,
              attachments: item.attachments,
            ),
          )
          .toList(),
      failure: (error) {
        AppToast.showError(error.message);
        return const <ParkInspectionRecordDetailItemModel>[];
      },
    );
  }

  bool get canOperate =>
      taskStatus == ParkInspectionTaskStatus.pending ||
      taskStatus == ParkInspectionTaskStatus.inProgress;

  String get taskStatus => (item.taskStatus ?? '').trim();

  String typeText(String? value) {
    switch ((value ?? '').trim()) {
      case 'EQUIPMENT':
        return '设备巡检';
      case 'SAFETY':
        return '安全巡检';
      case 'ENVIRONMENT':
        return '环保巡检';
      case 'PERSONNEL':
        return '人员行为巡检';
      case 'DAILY':
        return '日常巡检';
      case 'AUTOMATION':
        return '自动化巡检';
      default:
        return '--';
    }
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

  String ruleNameById(String? ruleId) {
    final key = (ruleId ?? '').trim();
    if (key.isEmpty) return '--';
    if (inspectionRuleNameMap.containsKey(key)) {
      return inspectionRuleNameMap[key] ?? key;
    }
    for (final rule in planRules) {
      final ruleKey = (rule.ruleId ?? rule.id ?? '').trim();
      if (ruleKey == key) return rule.ruleName ?? key;
    }
    return key;
  }

  void _replaceTaskStatus(String nextStatus) {
    item = ParkInspectionTaskItemModel(
      id: item.id,
      taskCode: item.taskCode,
      planId: item.planId,
      planName: item.planName,
      dispatchType: item.dispatchType,
      typeCode: item.typeCode,
      executorId: item.executorId,
      executorName: item.executorName,
      executorNames: item.executorNames,
      taskDate: item.taskDate,
      taskStatus: nextStatus,
      resultStatus: item.resultStatus,
      totalPoints: item.totalPoints,
      completedPoints: item.completedPoints,
      abnormalCount: item.abnormalCount,
      remark: item.remark,
      isMultiPerson: item.isMultiPerson,
      multiPersonMode: item.multiPersonMode,
    );
    update();
  }
}
