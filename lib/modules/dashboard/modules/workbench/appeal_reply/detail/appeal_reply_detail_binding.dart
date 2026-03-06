import 'package:get/get.dart';

import 'appeal_reply_detail_controller.dart';

/// 申诉回复详情页依赖绑定。
class AppealReplyDetailBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AppealReplyDetailController>()) {
      Get.lazyPut<AppealReplyDetailController>(AppealReplyDetailController.new);
    }
  }
}
