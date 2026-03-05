import 'package:get/get.dart';

import 'appointment_approval_controller.dart';

/// 预约审批依赖注入。
class AppointmentApprovalBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AppointmentApprovalController>()) {
      Get.lazyPut<AppointmentApprovalController>(
        AppointmentApprovalController.new,
      );
    }
  }
}
