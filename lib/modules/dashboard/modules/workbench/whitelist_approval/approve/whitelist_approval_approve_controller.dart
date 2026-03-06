import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/components/toast/toast_widget.dart';
import '../../../../../../data/models/workbench/whitelist_approval_item_model.dart';
import '../../../../../../data/repository/workbench_repository.dart';
import '../../../../../../global.dart';

/// 白名单审批页控制器。
class WhitelistApprovalApproveController extends GetxController {
  final WorkbenchRepository _repository = WorkbenchRepository();

  late final WhitelistApprovalItemModel item;
  final TextEditingController parkCheckDescController = TextEditingController();

  bool loading = false;
  bool submitting = false;

  DateTime? validityStart;
  DateTime? validityEnd;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is WhitelistApprovalItemModel) {
      item = args;
      validityStart = _parseDateTime(item.validityBeginTime);
      validityEnd = _parseDateTime(item.validityEndTime);
      final desc = (item.parkCheckDesc ?? '').trim();
      if (desc.isNotEmpty) {
        parkCheckDescController.text = desc;
      }
    } else {
      item = const WhitelistApprovalItemModel();
    }
  }

  @override
  void onClose() {
    parkCheckDescController.dispose();
    super.onClose();
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
      AppToast.showError('缺少白名单记录ID');
      return;
    }
    if (validityStart == null || validityEnd == null) {
      AppToast.showError('请选择授权期限');
      return;
    }

    submitting = true;
    update();

    final result = await _repository.approveWhitelist(
      ids: <String>[id],
      type: item.type,
      parkCheckStatus: parkCheckStatus,
      validityBeginTime: _formatDateTime(validityStart!),
      validityEndTime: _formatDateTime(validityEnd!),
      parkCheckDesc: parkCheckDescController.text.trim(),
    );

    submitting = false;
    update();

    result.when(
      success: (_) {
        AppToast.showSuccess('审批成功');
        Get.back<bool>(result: true);
      },
      failure: (error) {
        talker.error('白名单审批提交失败', error, StackTrace.current);
        AppToast.showError(error.message);
      },
    );
  }

  String typeText(int type) {
    return type == 1 ? '人员白名单' : '车辆白名单';
  }

  List<WhitelistApproveDetailLine> buildDetailLines() {
    return <WhitelistApproveDetailLine>[
      WhitelistApproveDetailLine(label: '名单类型', value: typeText(item.type)),
      WhitelistApproveDetailLine(label: '主体信息', value: titleText),
      WhitelistApproveDetailLine(label: '企业名称', value: companyText),
      WhitelistApproveDetailLine(label: '联系电话', value: phoneText),
      WhitelistApproveDetailLine(label: '提交时间', value: submitTimeText),
    ].where((e) => e.value != '--').toList();
  }

  String get titleText {
    if ((item.carNumb ?? '').isNotEmpty) return item.carNumb!;
    if ((item.realName ?? '').isNotEmpty) return item.realName!;
    return '--';
  }

  String get companyText => _firstNonEmpty(item.companyName, item.submitBy);

  String get phoneText => _firstNonEmpty(item.userPhone);

  String get submitTimeText =>
      _firstNonEmpty(item.submitDate, item.parkCheckTime);

  DateTime? _parseDateTime(Object? value) {
    final text = (value ?? '').toString().trim();
    if (text.isEmpty || text.toLowerCase() == 'null') return null;
    return DateTime.tryParse(text.replaceFirst(' ', 'T'));
  }

  String _formatDateTime(DateTime date) {
    return '${date.year}-${_pad2(date.month)}-${_pad2(date.day)} '
        '${_pad2(date.hour)}:${_pad2(date.minute)}:${_pad2(date.second)}';
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

class WhitelistApproveDetailLine {
  const WhitelistApproveDetailLine({required this.label, required this.value});

  final String label;
  final String value;
}
