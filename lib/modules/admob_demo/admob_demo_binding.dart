import 'package:get/get.dart';

import 'admob_demo_controller.dart';

/// AdMob 演示页依赖注入。
class AdmobDemoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdmobDemoController>(AdmobDemoController.new);
  }
}
