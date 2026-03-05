import 'package:get/get.dart';

import 'vehicle_query_statistics_controller.dart';

/// 车辆查询模块依赖注入。
class VehicleQueryBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<VehicleQueryStatisticsController>()) {
      Get.lazyPut<VehicleQueryStatisticsController>(
        VehicleQueryStatisticsController.new,
      );
    }
  }
}
