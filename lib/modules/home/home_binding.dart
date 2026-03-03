import 'package:get/get.dart';

import '../dashboard/dashboard_controller.dart';
import '../profile/profile_controller.dart';
import 'home_controller.dart';

/// 首页依赖注入。
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(HomeController.new);
    Get.lazyPut<DashboardController>(DashboardController.new);
    Get.lazyPut<ProfileController>(ProfileController.new);
  }
}
