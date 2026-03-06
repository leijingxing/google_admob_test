import 'package:get/get.dart';

import '../../../../../data/models/logistics_query/logistics_query_models.dart';
import '../logistics_query_statistics_controller.dart';
import 'logistics_query_detail_controller.dart';

/// 物流详情依赖注入。
class LogisticsQueryDetailBinding extends Bindings {
  LogisticsQueryDetailBinding({
    required this.statisticsController,
    required this.row,
  });

  final LogisticsQueryStatisticsController statisticsController;
  final LogisticsComprehensiveItemModel row;

  @override
  void dependencies() {
    Get.lazyPut<LogisticsQueryDetailController>(
      () => LogisticsQueryDetailController(
        statisticsController: statisticsController,
        row: row,
      ),
    );
  }
}
