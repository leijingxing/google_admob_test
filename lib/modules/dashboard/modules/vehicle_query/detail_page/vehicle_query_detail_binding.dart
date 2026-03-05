import 'package:get/get.dart';

import '../../../../../data/models/vehicle_query/vehicle_query_models.dart';
import '../vehicle_query_statistics_controller.dart';
import 'vehicle_query_detail_controller.dart';

/// 车辆详情依赖注入。
class VehicleQueryDetailBinding extends Bindings {
  VehicleQueryDetailBinding({
    required this.statisticsController,
    required this.row,
  });

  final VehicleQueryStatisticsController statisticsController;
  final VehicleComprehensiveItemModel row;

  @override
  void dependencies() {
    Get.lazyPut<VehicleQueryDetailController>(
      () => VehicleQueryDetailController(
        statisticsController: statisticsController,
        row: row,
      ),
    );
  }
}
