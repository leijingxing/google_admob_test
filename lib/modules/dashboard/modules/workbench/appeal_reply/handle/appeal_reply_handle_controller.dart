import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/components/toast/toast_widget.dart';
import '../../../../../../data/models/workbench/appeal_reply_item_model.dart';
import '../../../../../../data/repository/workbench_repository.dart';
import '../../../../../../global.dart';

/// 申诉回复处理页控制器。
class AppealReplyHandleController extends GetxController {
  final WorkbenchRepository _repository = WorkbenchRepository();

  late final AppealReplyItemModel item;
  final TextEditingController replyController = TextEditingController();

  int selectedStatus = 1;
  bool submitting = false;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    item = args is AppealReplyItemModel ? args : const AppealReplyItemModel();
    selectedStatus = item.status == 2 ? 2 : 1;
    if ((item.reply ?? '').trim().isNotEmpty) {
      replyController.text = item.reply!.trim();
    }
  }

  @override
  void onClose() {
    replyController.dispose();
    super.onClose();
  }

  void onStatusChanged(int? value) {
    if (value == null) return;
    selectedStatus = value;
    update();
  }

  Future<void> submit() async {
    final id = item.id ?? '';
    if (id.isEmpty) {
      AppToast.showError('缺少申诉记录ID');
      return;
    }

    final reply = replyController.text.trim();
    if (reply.isEmpty) {
      AppToast.showWarning('请输入回复描述');
      return;
    }

    submitting = true;
    update();

    final result = await _repository.replyAppealRecord(
      id: id,
      status: selectedStatus,
      reply: reply,
    );

    submitting = false;
    update();

    result.when(
      success: (_) {
        AppToast.showSuccess('回复成功');
        Get.back<bool>(result: true);
      },
      failure: (error) {
        talker.error('申诉回复提交失败', error, StackTrace.current);
        AppToast.showError(error.message);
      },
    );
  }

  String appealTypeText() {
    switch (item.appealType) {
      case 1:
        return '违规申诉';
      case 2:
        return '拉黑申诉';
      default:
        return '--';
    }
  }

  List<AppealReplyHandleLine> buildDetailLines() {
    return <AppealReplyHandleLine>[
      AppealReplyHandleLine(label: '申诉类型', value: appealTypeText()),
      AppealReplyHandleLine(label: '姓名/车牌', value: _display(item.targetValue)),
      AppealReplyHandleLine(label: '申诉人', value: _display(item.applicant)),
      AppealReplyHandleLine(label: '申诉时间', value: _display(item.appealTime)),
      AppealReplyHandleLine(label: '异常描述', value: _display(item.abnormalDesc)),
      AppealReplyHandleLine(label: '申诉描述', value: _display(item.appealDesc)),
    ];
  }

  String _display(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? '--' : text;
  }
}

class AppealReplyHandleLine {
  const AppealReplyHandleLine({required this.label, required this.value});

  final String label;
  final String value;
}
