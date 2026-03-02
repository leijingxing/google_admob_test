import 'package:get/get.dart';

import 'auth_controller.dart';

/// 登录页依赖注入。
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.isRegistered<AuthController>()) {
      Get.delete<AuthController>(force: true);
    }
    Get.lazyPut<AuthController>(AuthController.new, fenix: true);
  }
}
