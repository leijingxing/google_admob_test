import 'package:get/get.dart';

import 'message_controller.dart';

/// 消息模块依赖注入。
class MessageBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<MessageController>()) {
      Get.lazyPut<MessageController>(MessageController.new);
    }
  }
}
