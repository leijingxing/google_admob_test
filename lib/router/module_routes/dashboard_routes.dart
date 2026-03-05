import 'package:get/get.dart';

import '../../modules/dashboard/modules/logistics_query/logistics_query_view.dart';
import '../../modules/dashboard/modules/overview/overview_binding.dart';
import '../../modules/dashboard/modules/overview/overview_view.dart';
import '../../modules/dashboard/modules/personnel_query/personnel_query_view.dart';
import '../../modules/dashboard/modules/vehicle_query/vehicle_query_binding.dart';
import '../../modules/dashboard/modules/vehicle_query/vehicle_query_view.dart';
import '../../modules/dashboard/modules/workbench/workbench_binding.dart';
import '../../modules/dashboard/modules/workbench/workbench_view.dart';

/// Dashboard 模块子页面跳转封装（非命名路由）。
abstract class DashboardRoutes {
  DashboardRoutes._();

  /// 工作台。
  static Future<T?>? toWorkbench<T>() {
    return Get.to<T>(() => const WorkbenchView(), binding: WorkbenchBinding());
  }

  /// 车辆查询。
  static Future<T?>? toVehicleQuery<T>() {
    return Get.to<T>(() => const VehicleQueryView(), binding: VehicleQueryBinding());
  }

  /// 人员查询。
  static Future<T?>? toPersonnelQuery<T>() {
    return Get.to<T>(() => const PersonnelQueryView());
  }

  /// 物流查询。
  static Future<T?>? toLogisticsQuery<T>() {
    return Get.to<T>(() => const LogisticsQueryView());
  }

  /// 总览。
  static Future<T?>? toOverview<T>() {
    return Get.to<T>(() => const OverviewView(), binding: OverviewBinding());
  }
}
