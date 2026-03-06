import 'package:get/get.dart';

import 'whitelist_approval_detail_controller.dart';

/// 白名单详情依赖注入。
class WhitelistApprovalDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WhitelistApprovalDetailController>(
      WhitelistApprovalDetailController.new,
    );
  }
}
