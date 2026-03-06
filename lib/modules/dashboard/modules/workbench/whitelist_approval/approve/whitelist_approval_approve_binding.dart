import 'package:get/get.dart';

import 'whitelist_approval_approve_controller.dart';

/// 白名单审批页依赖注入。
class WhitelistApprovalApproveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WhitelistApprovalApproveController>(
      WhitelistApprovalApproveController.new,
    );
  }
}
