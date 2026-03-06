import 'package:get/get.dart';

import '../../../../../core/utils/dict_field_query_tool.dart';
import '../../../../../data/models/logistics_query/logistics_query_models.dart';
import '../logistics_query_statistics_controller.dart';

/// 物流详情控制器。
class LogisticsQueryDetailController extends GetxController {
  LogisticsQueryDetailController({
    required this.statisticsController,
    required this.row,
  });

  final LogisticsQueryStatisticsController statisticsController;
  final LogisticsComprehensiveItemModel row;

  late Future<LogisticsDetailCountModel> detailCountFuture;

  @override
  void onInit() {
    super.onInit();
    reloadDetailCount();
  }

  /// 重新加载顶部统计。
  void reloadDetailCount() {
    detailCountFuture = statisticsController.loadDetailCount(cas: row.cas);
    update();
  }

  /// 装载类型文案。
  static String loadTypeText(int? loadType) {
    if (loadType == null) return '--';
    return DictFieldQueryTool.loadTypeLabel(loadType, fallback: '$loadType');
  }
}
