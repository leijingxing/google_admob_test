import 'package:get/get.dart';

import 'whitelist_approval_controller.dart';

/// 白名单审批依赖注入。
class WhitelistApprovalBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<WhitelistApprovalController>()) {
      Get.lazyPut<WhitelistApprovalController>(WhitelistApprovalController.new);
    }
  }
}
