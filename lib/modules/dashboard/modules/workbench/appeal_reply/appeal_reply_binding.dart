import 'package:get/get.dart';

import 'appeal_reply_controller.dart';

/// 申诉回复页面依赖绑定。
class AppealReplyBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AppealReplyController>()) {
      Get.lazyPut<AppealReplyController>(AppealReplyController.new);
    }
  }
}
