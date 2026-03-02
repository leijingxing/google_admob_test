import 'package:get/get.dart';

import 'home_controller.dart';

/// 首页依赖注入。
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(HomeController.new);
  }
}
