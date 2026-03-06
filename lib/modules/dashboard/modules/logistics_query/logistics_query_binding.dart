import 'package:get/get.dart';

import 'logistics_query_statistics_controller.dart';

/// 物流查询模块依赖注入。
class LogisticsQueryBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<LogisticsQueryStatisticsController>()) {
      Get.lazyPut<LogisticsQueryStatisticsController>(
        LogisticsQueryStatisticsController.new,
      );
    }
  }
}
