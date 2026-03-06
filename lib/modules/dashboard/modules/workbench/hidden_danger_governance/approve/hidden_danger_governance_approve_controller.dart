import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../../../core/components/date_picker/ios_date_picker.dart';
import '../../../../../../core/components/select/app_user_select_field.dart';
import '../../../../../../core/components/toast/toast_widget.dart';
import '../../../../../../data/models/workbench/inspection_abnormal_item_model.dart';
import '../../../../../../data/models/workbench/inspection_rectification_item_model.dart';
import '../hidden_danger_governance_controller.dart';

enum HiddenDangerGovernanceApproveMode { confirm, rectify, verify, reassign }

/// 隐患治理审批页控制器。
class HiddenDangerGovernanceApproveController extends GetxController {
  late final InspectionAbnormalItemModel item;
  late final HiddenDangerGovernanceApproveMode mode;
  HiddenDangerGovernanceController? parentController;

  final TextEditingController enterpriseNameController =
      TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController rectifyDescController = TextEditingController();
  final TextEditingController photoUrlsController = TextEditingController();
  final TextEditingController verifyCommentController = TextEditingController();
  final TextEditingController reassignReasonController =
      TextEditingController();

  bool loading = false;
  bool submitting = false;

  String confirmVerifyResult = 'CONFIRMED';
  String? responsibleType;
  AppSelectedUser? selectedResponsibleUser;
  AppSelectedUser? selectedRectifyUser;
  AppSelectedUser? selectedNewRectifyUser;

  String verifyResult = 'PASS';
  InspectionRectificationItemModel? latestRectification;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    item = args is InspectionAbnormalItemModel
        ? args
        : const InspectionAbnormalItemModel();
    if (Get.isRegistered<HiddenDangerGovernanceController>()) {
      parentController = Get.find<HiddenDangerGovernanceController>();
    }
    mode = _resolveMode(item.abnormalStatus);
    if (mode == HiddenDangerGovernanceApproveMode.verify) {
      _loadLatestRectification();
    }
  }

  @override
  void onClose() {
    enterpriseNameController.dispose();
    deadlineController.dispose();
    rectifyDescController.dispose();
    photoUrlsController.dispose();
    verifyCommentController.dispose();
    reassignReasonController.dispose();
    super.onClose();
  }

  String get pageTitle {
    switch (mode) {
      case HiddenDangerGovernanceApproveMode.confirm:
        return '确认';
      case HiddenDangerGovernanceApproveMode.rectify:
        return '整改';
      case HiddenDangerGovernanceApproveMode.verify:
        return '核查';
      case HiddenDangerGovernanceApproveMode.reassign:
        return '重新指派';
    }
  }

  String get submitButtonText {
    switch (mode) {
      case HiddenDangerGovernanceApproveMode.confirm:
        return '提交确认';
      case HiddenDangerGovernanceApproveMode.rectify:
        return '提交整改';
      case HiddenDangerGovernanceApproveMode.verify:
        return '提交核查';
      case HiddenDangerGovernanceApproveMode.reassign:
        return '提交指派';
    }
  }

  List<HiddenDangerApproveDetailLine> buildDetailLines() {
    return <HiddenDangerApproveDetailLine>[
      HiddenDangerApproveDetailLine(label: '巡检点位', value: pointText),
      HiddenDangerApproveDetailLine(label: '巡检细则', value: ruleText),
      HiddenDangerApproveDetailLine(label: '上报人', value: reporterText),
      HiddenDangerApproveDetailLine(label: '上报时间', value: reportTimeText),
      HiddenDangerApproveDetailLine(label: '是否紧急', value: urgentText),
      HiddenDangerApproveDetailLine(label: '当前状态', value: statusText),
      HiddenDangerApproveDetailLine(label: '责任对象', value: responsibleNameText),
      HiddenDangerApproveDetailLine(label: '异常描述', value: abnormalDescText),
    ];
  }

  Future<void> _loadLatestRectification() async {
    final abnormalId = (item.id ?? '').trim();
    if (abnormalId.isEmpty) {
      AppToast.showWarning('异常ID为空，无法核查');
      return;
    }

    loading = true;
    update();

    try {
      final controller = parentController;
      if (controller == null) {
        AppToast.showWarning('未找到隐患治理上下文');
      } else {
        final records = await controller.loadRectifications(
          abnormalId: abnormalId,
          forceRefresh: true,
        );
        latestRectification = controller.pickLatestPendingVerifyRectification(
          records,
        );
        if (latestRectification?.id == null ||
            (latestRectification!.id ?? '').trim().isEmpty) {
          AppToast.showWarning('未找到待核查整改记录');
        }
      }
    } catch (_) {
      latestRectification = null;
    } finally {
      loading = false;
      update();
    }
  }

  Future<void> pickDeadline(BuildContext context) async {
    final now = DateTime.now();
    showIosDatePicker(
      context: context,
      initialTime: now,
      minTime: DateTime(now.year - 2, 1, 1),
      maxTime: DateTime(now.year + 3, 12, 31),
      mode: CupertinoDatePickerMode.dateAndTime,
      onConfirm: (dateTime) {
        deadlineController.text = _formatDateTime(dateTime);
        update();
      },
    );
  }

  Future<void> submit() async {
    if (submitting) return;
    final controller = parentController;
    if (controller == null) {
      AppToast.showWarning('未找到隐患治理上下文');
      return;
    }

    bool success = false;
    switch (mode) {
      case HiddenDangerGovernanceApproveMode.confirm:
        success = await _submitConfirm(controller);
        break;
      case HiddenDangerGovernanceApproveMode.rectify:
        success = await _submitRectify(controller);
        break;
      case HiddenDangerGovernanceApproveMode.verify:
        success = await _submitVerify(controller);
        break;
      case HiddenDangerGovernanceApproveMode.reassign:
        success = await _submitReassign(controller);
        break;
    }

    if (success) {
      Get.back<bool>(result: true);
    }
  }

  Future<bool> _submitConfirm(
    HiddenDangerGovernanceController controller,
  ) async {
    if (confirmVerifyResult == 'CONFIRMED') {
      if ((responsibleType ?? '').isEmpty) {
        AppToast.showWarning('请选择责任类型');
        return false;
      }
      if (responsibleType == 'ENTERPRISE') {
        if (enterpriseNameController.text.trim().isEmpty) {
          AppToast.showWarning('请输入责任对象名称');
          return false;
        }
      } else if (selectedResponsibleUser == null) {
        AppToast.showWarning('请选择责任人员');
        return false;
      }
      if (selectedRectifyUser == null) {
        AppToast.showWarning('请选择整改人员');
        return false;
      }
      if (deadlineController.text.trim().isEmpty) {
        AppToast.showWarning('请选择整改期限');
        return false;
      }
    }

    submitting = true;
    update();
    final success = await controller.confirmAbnormal(
      item: item,
      verifyResult: confirmVerifyResult,
      responsibleType: responsibleType,
      responsibleId: responsibleType == 'PERSONNEL'
          ? selectedResponsibleUser?.id
          : null,
      responsibleName: responsibleType == 'PERSONNEL'
          ? selectedResponsibleUser?.displayName
          : enterpriseNameController.text.trim(),
      rectifyUserId: selectedRectifyUser?.id,
      rectifyUserName: selectedRectifyUser?.displayName,
      deadline: deadlineController.text.trim(),
    );
    submitting = false;
    update();
    return success;
  }

  Future<bool> _submitRectify(
    HiddenDangerGovernanceController controller,
  ) async {
    if (selectedRectifyUser == null) {
      AppToast.showWarning('请选择整改人员');
      return false;
    }
    if (rectifyDescController.text.trim().isEmpty) {
      AppToast.showWarning('请输入整改描述');
      return false;
    }

    final photoUrls = photoUrlsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    submitting = true;
    update();
    final success = await controller.submitRectification(
      item: item,
      rectifyUserId: selectedRectifyUser!.id,
      rectifyUserName: selectedRectifyUser!.displayName,
      rectifyDesc: rectifyDescController.text.trim(),
      photoUrls: photoUrls.isEmpty ? null : photoUrls,
    );
    submitting = false;
    update();
    return success;
  }

  Future<bool> _submitVerify(
    HiddenDangerGovernanceController controller,
  ) async {
    final record = latestRectification;
    if (record == null || (record.id ?? '').trim().isEmpty) {
      AppToast.showWarning('未找到待核查整改记录');
      return false;
    }

    submitting = true;
    update();
    final success = await controller.verifyRectification(
      item: item,
      rectificationId: (record.id ?? '').trim(),
      verifyResult: verifyResult,
      verifyComment: verifyCommentController.text.trim(),
    );
    submitting = false;
    update();
    return success;
  }

  Future<bool> _submitReassign(
    HiddenDangerGovernanceController controller,
  ) async {
    if (selectedNewRectifyUser == null) {
      AppToast.showWarning('请选择新整改人员');
      return false;
    }

    submitting = true;
    update();
    final success = await controller.reassignAbnormal(
      item: item,
      newRectifyUserId: selectedNewRectifyUser!.id,
      newRectifyUserName: selectedNewRectifyUser!.displayName,
      reassignReason: reassignReasonController.text.trim(),
    );
    submitting = false;
    update();
    return success;
  }

  void onResponsibleTypeChanged(String? value) {
    responsibleType = value;
    if (value != 'PERSONNEL') {
      selectedResponsibleUser = null;
    }
    if (value != 'ENTERPRISE') {
      enterpriseNameController.clear();
    }
    update();
  }

  void setPhotoUrls(List<String> photoIds) {
    photoUrlsController.text = photoIds.join(',');
    update();
  }

  String get pointText =>
      parentController?.displayPointName(item) ?? _emptyDash(item.pointName);

  String get ruleText =>
      parentController?.displayRuleName(item) ?? _emptyDash(item.ruleName);

  String get reporterText =>
      parentController?.displayReporterName(item) ??
      _emptyDash(item.reporterName);

  String get reportTimeText =>
      parentController?.displayReportTime(item) ?? _emptyDash(item.reportTime);

  String get urgentText =>
      parentController?.urgentText(item.isUrgent) ??
      ((item.isUrgent ?? '').trim() == '1' ? '是' : '否');

  String get statusText =>
      parentController?.statusText(item.abnormalStatus) ??
      _emptyDash(item.abnormalStatus);

  String get responsibleNameText => _emptyDash(item.responsibleName);

  String get abnormalDescText => _emptyDash(item.abnormalDesc);

  List<String> get abnormalPhotos {
    final photos = item.photoUrls;
    if (photos == null || photos.isEmpty) return const <String>[];
    return photos
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty && e.toLowerCase() != 'null')
        .toList();
  }

  String rectifyTypeText(String? value) =>
      parentController?.rectifyTypeText(value) ?? _emptyDash(value);

  String verifyResultText(String? value) =>
      parentController?.verifyResultText(value) ?? _emptyDash(value);

  String rectifyStatusText(String? value) =>
      parentController?.rectifyStatusText(value) ?? _emptyDash(value);

  HiddenDangerGovernanceApproveMode _resolveMode(String? abnormalStatus) {
    switch ((abnormalStatus ?? '').trim()) {
      case HiddenDangerAbnormalStatus.pendingConfirm:
        return HiddenDangerGovernanceApproveMode.confirm;
      case HiddenDangerAbnormalStatus.pendingVerify:
        return HiddenDangerGovernanceApproveMode.verify;
      case HiddenDangerAbnormalStatus.reassign:
        return HiddenDangerGovernanceApproveMode.reassign;
      case HiddenDangerAbnormalStatus.pendingRectify:
      case HiddenDangerAbnormalStatus.rectifying:
      default:
        return HiddenDangerGovernanceApproveMode.rectify;
    }
  }

  String _formatDateTime(DateTime value) {
    String twoDigits(int input) => input.toString().padLeft(2, '0');
    return '${value.year}-${twoDigits(value.month)}-${twoDigits(value.day)} '
        '${twoDigits(value.hour)}:${twoDigits(value.minute)}:${twoDigits(value.second)}';
  }

  String _emptyDash(String? value) {
    final text = (value ?? '').trim();
    return text.isEmpty ? '--' : text;
  }
}

class HiddenDangerApproveDetailLine {
  final String label;
  final String value;

  const HiddenDangerApproveDetailLine({
    required this.label,
    required this.value,
  });
}
