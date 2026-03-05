import 'package:get/get.dart';

import 'appointment_approval_approve_controller.dart';

/// 预约审批页依赖注入。
class AppointmentApprovalApproveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppointmentApprovalApproveController>(
      AppointmentApprovalApproveController.new,
    );
  }
}
