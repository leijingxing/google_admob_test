import 'package:get/get.dart';

import 'blacklist_approval_approve_controller.dart';

/// 黑名单审批/更改授权页面依赖绑定。
class BlacklistApprovalApproveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BlacklistApprovalApproveController>(
      () => BlacklistApprovalApproveController(),
    );
  }
}
