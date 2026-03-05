import 'package:get/get.dart';

import 'overview_statistics_controller.dart';

/// 总览模块依赖注入。
class OverviewBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<OverviewStatisticsController>()) {
      Get.lazyPut<OverviewStatisticsController>(
        OverviewStatisticsController.new,
      );
    }
  }
}
