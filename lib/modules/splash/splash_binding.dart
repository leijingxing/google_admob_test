import 'package:get/get.dart';

import 'splash_controller.dart';

/// 启动页依赖注入。
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // [CONSTRAINT]: Splash 需要在页面进入后立即执行 onReady 跳转，
    // 不能使用 lazyPut 等待首次 Get.find()，否则会出现一直转圈不跳转。
    Get.put<SplashController>(SplashController());
  }
}
