import 'package:get/get.dart';

import 'auth_controller.dart';

/// 登录页依赖注入。
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(AuthController.new);
  }
}
