import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../park_inspection_detail_controller.dart';

class ParkInspectionCompleteController extends GetxController {
  late final ParkInspectionDetailController detailController;

  final TextEditingController remarkController = TextEditingController();
  bool submitting = false;

  @override
  void onInit() {
    super.onInit();
    detailController = Get.find<ParkInspectionDetailController>();
  }

  Future<void> submit() async {
    if (submitting) return;

    submitting = true;
    update();
    final success = await detailController.completeTask(
      completeRemark: remarkController.text.trim(),
    );
    submitting = false;
    update();

    if (success) {
      Get.back<bool>(result: true);
    }
  }

  @override
  void onClose() {
    remarkController.dispose();
    super.onClose();
  }
}
