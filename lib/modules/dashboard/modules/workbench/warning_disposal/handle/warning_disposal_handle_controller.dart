import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/components/toast/toast_widget.dart';
import '../../../../../../data/models/workbench/risk_warning_disposal_item_model.dart';
import '../../../../../../data/repository/workbench_repository.dart';

/// 预警处置控制器。
class WarningDisposalHandleController extends GetxController {
  final WorkbenchRepository _repository = WorkbenchRepository();

  late final RiskWarningDisposalItemModel item;
  final TextEditingController disposalResultController =
      TextEditingController();
  final List<String> disposalFiles = <String>[];
  bool submitting = false;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    item = args is RiskWarningDisposalItemModel
        ? args
        : const RiskWarningDisposalItemModel();
    disposalResultController.text = item.disposalResult?.trim() ?? '';
    if (item.disposalFiles != null) {
      disposalFiles.addAll(item.disposalFiles!);
    }
  }

  @override
  void onClose() {
    disposalResultController.dispose();
    super.onClose();
  }

  void onFilesChanged(List<String> files) {
    disposalFiles
      ..clear()
      ..addAll(files);
    update();
  }

  Future<void> submit() async {
    final resultText = disposalResultController.text.trim();
    if (resultText.isEmpty) {
      AppToast.showWarning('请输入处置描述');
      return;
    }
    if (disposalFiles.isEmpty) {
      AppToast.showWarning('请上传附件');
      return;
    }

    submitting = true;
    update();

    final result = await _repository.disposeRiskWarning(
      item: RiskWarningDisposalItemModel(
        id: item.id,
        warningType: 1,
        title: item.title,
        description: item.description,
        warningLevel: item.warningLevel,
        warningStatus: item.warningStatus,
        warningSource: item.warningSource,
        warningStartTime: item.warningStartTime,
        warningEndTime: item.warningEndTime,
        deviceName: item.deviceName,
        position: item.position,
      ),
      disposalResult: resultText,
      disposalFiles: List<String>.from(disposalFiles),
    );

    result.when(
      success: (_) {
        AppToast.showSuccess('提交成功');
        Get.back(result: true);
      },
      failure: (error) => AppToast.showError(error.message),
    );

    submitting = false;
    update();
  }

  String display(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? '--' : text;
  }
}
