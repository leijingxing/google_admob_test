import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../core/components/toast/toast_widget.dart';
import '../park_inspection_detail_controller.dart';

class ParkInspectionCancelController extends GetxController {
  late final ParkInspectionDetailController detailController;

  final TextEditingController reasonController = TextEditingController();
  bool submitting = false;

  @override
  void onInit() {
    super.onInit();
    detailController = Get.find<ParkInspectionDetailController>();
  }

  Future<void> submit() async {
    if (reasonController.text.trim().isEmpty) {
      AppToast.showWarning('请输入取消原因');
      return;
    }
    if (submitting) return;

    submitting = true;
    update();
    final success = await detailController.cancelTask(
      cancelReason: reasonController.text.trim(),
    );
    submitting = false;
    update();

    if (success) {
      Get.back<bool>(result: true);
    }
  }

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }
}
