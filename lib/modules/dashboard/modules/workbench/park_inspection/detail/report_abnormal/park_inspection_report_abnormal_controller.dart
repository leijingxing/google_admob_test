import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../core/components/toast/toast_widget.dart';
import '../../../../../../../data/models/workbench/park_inspection_task_record_model.dart';
import '../park_inspection_detail_controller.dart';

class ParkInspectionReportAbnormalController extends GetxController {
  late final ParkInspectionDetailController detailController;
  late final ParkInspectionTaskRecordModel record;

  final TextEditingController descController = TextEditingController();
  String? selectedRuleId;
  String isUrgent = '0';
  List<String> photoIds = <String>[];
  bool submitting = false;

  @override
  void onInit() {
    super.onInit();
    detailController = Get.find<ParkInspectionDetailController>();
    final args = Get.arguments;
    record = args is ParkInspectionTaskRecordModel
        ? args
        : const ParkInspectionTaskRecordModel();
  }

  void onRuleChanged(String? value) {
    selectedRuleId = value;
    update();
  }

  void onUrgentChanged(String value) {
    isUrgent = value;
    update();
  }

  void onPhotosChanged(List<String> value) {
    photoIds = value;
    update();
  }

  Future<void> submit() async {
    if ((selectedRuleId ?? '').trim().isEmpty) {
      AppToast.showWarning('请选择巡检细则');
      return;
    }
    if (descController.text.trim().isEmpty) {
      AppToast.showWarning('请输入异常描述');
      return;
    }
    if (submitting) return;

    submitting = true;
    update();
    final success = await detailController.reportAbnormal(
      record: record,
      ruleId: selectedRuleId!.trim(),
      abnormalDesc: descController.text.trim(),
      isUrgent: isUrgent,
      photoUrls: photoIds,
    );
    submitting = false;
    update();
    if (success) {
      Get.back<bool>(result: true);
    }
  }

  @override
  void onClose() {
    descController.dispose();
    super.onClose();
  }
}
