import 'package:get/get.dart';

import '../../../../../core/utils/dict_field_query_tool.dart';
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

  static const Map<int, String> recordTypeLabelMap = {
    0: '白名单',
    1: '预约',
    2: '黑名单',
  };

  static const Map<int, String> blackRecordStatusLabelMap = {
    0: '解除',
    1: '拉黑',
  };

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

  /// 准入类别文案。
  static String recordTypeText(int? type) {
    if (type == null) return '未知';
    return DictFieldQueryTool.validityStatusLabel(
      type,
      fallback: recordTypeLabelMap[type] ?? '未知',
    );
  }

  /// 拉黑记录操作状态文案。
  static String blackRecordStatusText(int? status) {
    if (status == null) return '未知';
    return blackRecordStatusLabelMap[status] ?? '未知';
  }
}
