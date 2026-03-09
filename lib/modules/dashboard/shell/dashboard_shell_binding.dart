import 'package:get/get.dart';

import '../modules/logistics_query/logistics_query_binding.dart';
import '../modules/overview/overview_binding.dart';
import '../modules/personnel_query/personnel_query_binding.dart';
import '../modules/vehicle_query/vehicle_query_binding.dart';
import '../modules/workbench/workbench_binding.dart';
import 'dashboard_shell_controller.dart';

/// Dashboard 封闭式容器页依赖注入。
class DashboardShellBinding extends Bindings {
  @override
  void dependencies() {
    WorkbenchBinding().dependencies();
    VehicleQueryBinding().dependencies();
    PersonnelQueryBinding().dependencies();
    LogisticsQueryBinding().dependencies();
    OverviewBinding().dependencies();

    if (!Get.isRegistered<DashboardShellController>()) {
      Get.lazyPut<DashboardShellController>(DashboardShellController.new);
    }
  }
}
