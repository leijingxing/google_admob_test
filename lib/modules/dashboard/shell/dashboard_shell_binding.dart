import 'package:get/get.dart';

import 'dashboard_shell_controller.dart';

/// Dashboard 封闭式容器页依赖注入。
class DashboardShellBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<DashboardShellController>()) {
      Get.lazyPut<DashboardShellController>(DashboardShellController.new);
    }
  }
}
