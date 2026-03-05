import 'package:get/get.dart';

import '../../../../../data/models/vehicle_query/vehicle_query_models.dart';
import '../vehicle_query_statistics_controller.dart';

/// 车辆详情控制器。
class VehicleQueryDetailController extends GetxController {
  VehicleQueryDetailController({
    required this.statisticsController,
    required this.row,
  });

  final VehicleQueryStatisticsController statisticsController;
  final VehicleComprehensiveItemModel row;

  late Future<ComprehensiveDetailCountModel> detailCountFuture;

  @override
  void onInit() {
    super.onInit();
    reloadDetailCount();
  }

  /// 重新加载顶部统计。
  void reloadDetailCount() {
    detailCountFuture = statisticsController.loadDetailCount(
      carNumb: row.carNumb,
      idCard: row.idCard,
    );
    update();
  }
}
