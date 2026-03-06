import 'package:get/get.dart';

import 'personnel_query_statistics_controller.dart';

/// 人员查询模块依赖注入。
class PersonnelQueryBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<PersonnelQueryStatisticsController>()) {
      Get.lazyPut<PersonnelQueryStatisticsController>(
        PersonnelQueryStatisticsController.new,
      );
    }
  }
}
