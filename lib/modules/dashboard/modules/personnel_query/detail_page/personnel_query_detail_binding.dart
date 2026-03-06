import 'package:get/get.dart';

import '../../../../../data/models/personnel_query/personnel_query_models.dart';
import '../personnel_query_statistics_controller.dart';
import 'personnel_query_detail_controller.dart';

/// 人员详情依赖注入。
class PersonnelQueryDetailBinding extends Bindings {
  PersonnelQueryDetailBinding({
    required this.statisticsController,
    required this.row,
  });

  final PersonnelQueryStatisticsController statisticsController;
  final PersonnelComprehensiveItemModel row;

  @override
  void dependencies() {
    Get.lazyPut<PersonnelQueryDetailController>(
      () => PersonnelQueryDetailController(
        statisticsController: statisticsController,
        row: row,
      ),
    );
  }
}
