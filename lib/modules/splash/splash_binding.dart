import 'package:get/get.dart';

import 'splash_controller.dart';

/// 启动页依赖注入。
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(SplashController.new);
  }
}
