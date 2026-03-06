import 'package:get/get.dart';

import 'blacklist_approval_controller.dart';

/// 黑名单审批页面依赖绑定。
class BlacklistApprovalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BlacklistApprovalController>(
      () => BlacklistApprovalController(),
    );
  }
}
