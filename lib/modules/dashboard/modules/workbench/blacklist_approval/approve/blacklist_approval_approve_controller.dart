import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/components/toast/toast_widget.dart';
import '../../../../../../core/http/result.dart';
import '../../../../../../data/models/workbench/blacklist_approval_item_model.dart';
import '../../../../../../data/repository/workbench_repository.dart';
import '../../../../../../global.dart';

/// 黑名单审批/更改授权页面控制器。
class BlacklistApprovalApproveController extends GetxController {
  final WorkbenchRepository _repository = WorkbenchRepository();

  late final BlacklistApprovalItemModel item;
  late final bool authorizationMode;

  final TextEditingController parkCheckDescController = TextEditingController();

  bool loading = false;
  bool submitting = false;
  Map<String, dynamic> detail = const <String, dynamic>{};

  DateTime? validityStart;
  DateTime? validityEnd;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      final rawItem = args['item'];
      item = rawItem is BlacklistApprovalItemModel
          ? rawItem
          : const BlacklistApprovalItemModel();
      authorizationMode = args['authorizationMode'] == true;
    } else if (args is BlacklistApprovalItemModel) {
      item = args;
      authorizationMode = false;
    } else {
      item = const BlacklistApprovalItemModel();
      authorizationMode = false;
    }

    if ((item.id ?? '').isNotEmpty) {
      loadDetail();
    }
  }

  @override
  void onClose() {
    parkCheckDescController.dispose();
    super.onClose();
  }

  Future<void> loadDetail() async {
    final id = item.id ?? '';
    if (id.isEmpty) return;

    loading = true;
    update();

    final result = await _repository.getBlacklistDetail(id: id);
    if (result is Success<Map<String, dynamic>>) {
      detail = result.data;
      _applyDetailDefaults();
    } else if (result is Failure<Map<String, dynamic>>) {
      talker.error('黑名单审批详情加载失败', result.error, StackTrace.current);
      AppToast.showError(result.error.message);
    }

    loading = false;
    update();
  }

  void _applyDetailDefaults() {
    final source = detail.isEmpty ? item.toJson() : detail;
    validityStart = _parseDateTime(source['validityBeginTime']);
    validityEnd = _parseDateTime(source['validityEndTime']);

    final desc = _firstNonEmpty(source['parkCheckDesc']);
    if (desc != '--' && parkCheckDescController.text.trim().isEmpty) {
      parkCheckDescController.text = desc;
    }
  }

  Future<void> onValidityDateChanged(DateTime? start, DateTime? end) async {
    if (start == null || end == null) {
      validityStart = start;
      validityEnd = end;
    } else {
      validityStart = start.isBefore(end) ? start : end;
      validityEnd = start.isBefore(end) ? end : start;
      validityStart = DateTime(
        validityStart!.year,
        validityStart!.month,
        validityStart!.day,
        0,
        0,
        0,
      );
      validityEnd = DateTime(
        validityEnd!.year,
        validityEnd!.month,
        validityEnd!.day,
        23,
        59,
        59,
      );
    }
    update();
  }

  Future<void> submitApproval({required int parkCheckStatus}) async {
    final id = item.id ?? '';
    if (id.isEmpty) {
      AppToast.showError('缺少黑名单记录ID');
      return;
    }

    submitting = true;
    update();

    final result = await _repository.reviewBlacklist(
      ids: <String>[id],
      parkCheckStatus: parkCheckStatus,
      approvalOpinion: parkCheckDescController.text.trim(),
    );

    submitting = false;
    update();

    result.when(
      success: (_) {
        AppToast.showSuccess('审批成功');
        Get.back<bool>(result: true);
      },
      failure: (error) {
        talker.error('黑名单审批提交失败', error, StackTrace.current);
        AppToast.showError(error.message);
      },
    );
  }

  Future<void> submitAuthorization() async {
    final id = item.id ?? '';
    if (id.isEmpty) {
      AppToast.showError('缺少黑名单记录ID');
      return;
    }
    if (validityStart == null || validityEnd == null) {
      AppToast.showError('请选择有效期限');
      return;
    }

    submitting = true;
    update();

    final result = await _repository.authorizeBlacklist(
      ids: <String>[id],
      validityBeginTime: _formatDateTime(validityStart!),
      validityEndTime: _formatDateTime(validityEnd!),
    );

    submitting = false;
    update();

    result.when(
      success: (_) {
        AppToast.showSuccess('更改授权成功');
        Get.back<bool>(result: true);
      },
      failure: (error) {
        talker.error('黑名单更改授权失败', error, StackTrace.current);
        AppToast.showError(error.message);
      },
    );
  }

  String typeText(int type) {
    return type == 1 ? '人员黑名单' : '车辆黑名单';
  }

  List<BlacklistApproveDetailLine> buildDetailLines() {
    return <BlacklistApproveDetailLine>[
      BlacklistApproveDetailLine(label: '名单类型', value: typeText(item.type)),
      BlacklistApproveDetailLine(label: '主体信息', value: titleText),
      BlacklistApproveDetailLine(label: '发起人', value: creatorText),
      BlacklistApproveDetailLine(label: '联系电话', value: creatorPhoneText),
      BlacklistApproveDetailLine(label: '发起时间', value: submitTimeText),
      BlacklistApproveDetailLine(label: '拉黑描述', value: remarkText),
    ].where((e) => e.value != '--').toList();
  }

  String get pageTitle => authorizationMode ? '更改授权' : '审批';

  String get titleText {
    if ((item.carNumb ?? '').isNotEmpty) return item.carNumb!;
    if ((item.realName ?? '').isNotEmpty) return item.realName!;
    return '--';
  }

  String get creatorText => _firstNonEmpty(detail['createBy'], item.createBy);

  String get creatorPhoneText => _firstNonEmpty(
    detail['submitUserPhone'],
    item.submitUserPhone,
    item.userPhone,
  );

  String get submitTimeText =>
      _firstNonEmpty(detail['createDate'], item.createDate, item.parkCheckTime);

  String get remarkText => _firstNonEmpty(detail['remark'], item.remark);

  DateTime? _parseDateTime(Object? value) {
    final text = (value ?? '').toString().trim();
    if (text.isEmpty || text.toLowerCase() == 'null') return null;
    return DateTime.tryParse(text.replaceFirst(' ', 'T'));
  }

  String _formatDateTime(DateTime date) {
    return '${date.year}-${_pad2(date.month)}-${_pad2(date.day)} ${_pad2(date.hour)}:${_pad2(date.minute)}:${_pad2(date.second)}';
  }

  String _pad2(int value) => value.toString().padLeft(2, '0');

  String _firstNonEmpty([Object? a, Object? b, Object? c]) {
    for (final value in <Object?>[a, b, c]) {
      final text = value?.toString().trim() ?? '';
      if (text.isNotEmpty && text.toLowerCase() != 'null') return text;
    }
    return '--';
  }
}

class BlacklistApproveDetailLine {
  const BlacklistApproveDetailLine({required this.label, required this.value});

  final String label;
  final String value;
}
