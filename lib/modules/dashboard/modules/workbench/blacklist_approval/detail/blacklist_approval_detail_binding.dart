import 'package:get/get.dart';

import 'blacklist_approval_detail_controller.dart';

/// 黑名单详情页面依赖绑定。
class BlacklistApprovalDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BlacklistApprovalDetailController>(
      () => BlacklistApprovalDetailController(),
    );
  }
}
