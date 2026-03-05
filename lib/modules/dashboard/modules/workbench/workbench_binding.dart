import 'package:get/get.dart';

import 'workbench_controller.dart';

/// 工作台模块依赖注入。
class WorkbenchBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<WorkbenchController>()) {
      Get.lazyPut<WorkbenchController>(WorkbenchController.new);
    }
  }
}
