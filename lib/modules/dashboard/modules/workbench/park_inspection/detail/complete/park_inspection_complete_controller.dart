import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../park_inspection_detail_controller.dart';

class ParkInspectionCompleteController extends GetxController {
  static const int maxRemarkLength = 200;

  late final ParkInspectionDetailController detailController;

  final TextEditingController remarkController = TextEditingController();
  bool submitting = false;

  String get trimmedRemark => remarkController.text.trim();

  bool get canSubmit => !submitting;

  @override
  void onInit() {
    super.onInit();
    detailController = Get.find<ParkInspectionDetailController>();
  }

  Future<void> submit() async {
    if (!canSubmit) return;

    _setSubmitting(true);
    var success = false;
    try {
      success = await detailController.completeTask(completeRemark: trimmedRemark);
    } finally {
      _setSubmitting(false);
    }

    if (success) {
      Get.back<bool>(result: true);
    }
  }

  void _setSubmitting(bool value) {
    if (submitting == value) return;
    submitting = value;
    if (!isClosed) {
      update();
    }
  }

  @override
  void onClose() {
    remarkController.dispose();
    super.onClose();
  }
}
