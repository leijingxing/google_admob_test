import 'package:get/get.dart';

import 'appointment_approval_detail_controller.dart';

/// 预约审批详情页依赖注入。
class AppointmentApprovalDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppointmentApprovalDetailController>(
      AppointmentApprovalDetailController.new,
    );
  }
}
