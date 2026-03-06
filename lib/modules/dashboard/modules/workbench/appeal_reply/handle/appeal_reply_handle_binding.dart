import 'package:get/get.dart';

import 'appeal_reply_handle_controller.dart';

/// 申诉回复处理页依赖绑定。
class AppealReplyHandleBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AppealReplyHandleController>()) {
      Get.lazyPut<AppealReplyHandleController>(AppealReplyHandleController.new);
    }
  }
}
