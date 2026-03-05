import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/components/log_util.dart';
import '../../../../core/components/toast/toast_widget.dart';
import '../../../../data/models/vehicle_query/vehicle_query_models.dart';
import '../../../../data/repository/vehicle_query_repository.dart';

/// 车辆查询控制器：维护筛选条件、统计数据与列表查询。
class VehicleQueryStatisticsController extends GetxController {
  final VehicleQueryRepository _repository = VehicleQueryRepository();

  /// 主列表关键字。
  final TextEditingController mainKeywordController = TextEditingController();

  /// 主列表开始/结束时间。
  DateTimeRange? mainDateRange;

  /// 主列表车辆类型筛选。
  int? mainCarCategory;

  /// 主列表刷新触发器。
  final ValueNotifier<int> mainRefreshTrigger = ValueNotifier<int>(0);

  /// 顶部统计加载态。
  bool statsLoading = false;

  /// 拉黑提交加载态。
  bool blackSubmitting = false;

  /// 顶部统计卡片。
  List<VehicleCountCardData> countCards = _defaultCountCards();

  static const Map<int, String> carCategoryLabelMap = {
    1: '危化车',
    2: '危废车',
    3: '普通车',
    4: '普货车',
  };

  static const Map<int, String> carNumbColourLabelMap = {
    1: '蓝牌',
    2: '黄牌',
    3: '黑牌',
    4: '白牌',
    5: '绿牌',
  };

  static const Map<int, String> validityStatusLabelMap = {
    0: '未知',
    1: '白名单',
    2: '黑名单',
  };

  static const Map<int, String> recordTypeLabelMap = {
    0: '白名单',
    1: '预约',
    2: '黑名单',
  };

  static const Map<int, String> blackRecordStatusLabelMap = {0: '解除', 1: '拉黑'};

  @override
  void onInit() {
    super.onInit();
    loadVehicleCountCards();
  }

  @override
  void onClose() {
    mainKeywordController.dispose();
    mainRefreshTrigger.dispose();
    super.onClose();
  }

  /// 搜索主列表。
  void onSearchMainList() {
    mainRefreshTrigger.value++;
    update();
  }

  /// 重置主列表筛选。
  void onResetMainList() {
    mainKeywordController.clear();
    mainDateRange = null;
    mainCarCategory = null;
    mainRefreshTrigger.value++;
    update();
  }

  /// 修改主列表时间范围。
  void onMainDateRangeChanged(DateTimeRange? value) {
    mainDateRange = value;
    update();
  }

  /// 修改主列表车辆类型。
  void onMainCarCategoryChanged(int? value) {
    mainCarCategory = value;
    update();
  }

  /// 主列表分页加载。
  Future<List<VehicleComprehensiveItemModel>> loadMainList(
    int pageIndex,
    int pageSize,
  ) async {
    final result = await _repository.getVehicleComprehensivePage(
      pageIndex: pageIndex,
      pageSize: pageSize,
      keyword: mainKeywordController.text.trim(),
      carCategory: mainCarCategory,
      startTime: rangeStartTime(mainDateRange),
      endTime: rangeEndTime(mainDateRange),
    );

    return result.when(
      success: (data) => data.items,
      failure: (error) {
        AppLog.warning('主列表查询失败: ${error.message}');
        throw Exception(error.message);
      },
    );
  }

  /// 刷新顶部统计。
  Future<void> loadVehicleCountCards() async {
    statsLoading = true;
    update();

    final result = await _repository.getVehicleCount();
    result.when(
      success: (data) {
        final map = <int, VehicleCategoryCountModel>{
          for (final item in data) item.carCategory: item,
        };
        countCards = _defaultCountCards().map((card) {
          final source = map[card.type];
          if (source == null) return card;
          return card.copyWith(
            metrics: [
              VehicleCountMetricData(label: '总数', value: source.totalCount),
              VehicleCountMetricData(
                label: '黑名单',
                value: source.blackListCount,
              ),
              VehicleCountMetricData(
                label: '白名单',
                value: source.whiteListCount,
              ),
              VehicleCountMetricData(
                label: '预约',
                value: source.reservationCount,
              ),
            ],
          );
        }).toList();
      },
      failure: (error) {
        AppLog.warning('顶部统计查询失败: ${error.message}');
        AppToast.showError(error.message);
      },
    );

    statsLoading = false;
    update();
  }

  /// 拉黑提交。
  Future<bool> addBlackRecord({
    required VehicleComprehensiveItemModel row,
    required String parkCheckDesc,
    required DateTimeRange validityDateRange,
  }) async {
    blackSubmitting = true;
    update();

    final validityBeginTime = rangeStartTime(validityDateRange);
    final validityEndTime = rangeEndTime(validityDateRange);
    final result = await _repository.addBlackRecord(
      carNumb: row.carNumb,
      carCategory: row.carCategory,
      parkCheckDesc: parkCheckDesc,
      validityBeginTime: validityBeginTime ?? '',
      validityEndTime: validityEndTime ?? '',
    );

    blackSubmitting = false;
    update();

    return result.when(
      success: (_) {
        AppToast.showSuccess('拉黑成功');
        loadVehicleCountCards();
        mainRefreshTrigger.value++;
        return true;
      },
      failure: (error) {
        AppLog.warning('拉黑失败: ${error.message}');
        AppToast.showError(error.message);
        return false;
      },
    );
  }

  /// 详情抽屉统计。
  Future<ComprehensiveDetailCountModel> loadDetailCount({
    required String carNumb,
    String? idCard,
  }) async {
    final result = await _repository.getComprehensiveDetailCount(
      carNumb: carNumb,
      idCard: idCard,
    );
    return result.when(
      success: (data) => data,
      failure: (error) {
        AppLog.warning('详情统计查询失败: ${error.message}');
        throw Exception(error.message);
      },
    );
  }

  /// 详情-授权记录分页。
  Future<List<VehicleAuthorizationRecordModel>> loadAuthorizationRecords(
    int pageIndex,
    int pageSize, {
    String? keyWords,
    DateTimeRange? parkCheckTime,
    DateTimeRange? inDate,
    String? carNumb,
    String? idCard,
    Object? type,
  }) async {
    final result = await _repository.getAuthorizationRecordPage(
      pageIndex: pageIndex,
      pageSize: pageSize,
      keyWords: keyWords,
      strParkCheckTime: rangeStartTime(parkCheckTime),
      endParkCheckTime: rangeEndTime(parkCheckTime),
      strInDate: rangeStartTime(inDate),
      endInDate: rangeEndTime(inDate),
      carNumb: carNumb,
      idCard: idCard,
      type: type,
    );
    return result.when(
      success: (data) => data.items,
      failure: (error) {
        AppLog.warning('授权记录查询失败: ${error.message}');
        throw Exception(error.message);
      },
    );
  }

  /// 详情-出入记录分页。
  Future<List<VehicleAccessRecordModel>> loadAccessRecords(
    int pageIndex,
    int pageSize, {
    String? keyWords,
    DateTimeRange? inDate,
    DateTimeRange? outDate,
    String? carNumb,
    String? idCard,
    Object? type,
  }) async {
    final result = await _repository.getAccessRecordPage(
      pageIndex: pageIndex,
      pageSize: pageSize,
      keyWords: keyWords,
      inDateBegin: rangeStartTime(inDate),
      inDateEnd: rangeEndTime(inDate),
      outDateBegin: rangeStartTime(outDate),
      outDateEnd: rangeEndTime(outDate),
      carNumb: carNumb,
      idCard: idCard,
      type: type,
    );
    return result.when(
      success: (data) => data.items,
      failure: (error) {
        AppLog.warning('出入记录查询失败: ${error.message}');
        throw Exception(error.message);
      },
    );
  }

  /// 详情-违规记录分页。
  Future<List<VehicleViolationRecordModel>> loadViolationRecords(
    int pageIndex,
    int pageSize, {
    String? keyword,
    DateTimeRange? warningStartTime,
    String? carNum,
  }) async {
    final result = await _repository.getViolationRecordPage(
      pageIndex: pageIndex,
      pageSize: pageSize,
      keyword: keyword,
      warningStartTimeBegin: rangeStartTime(warningStartTime),
      warningStartTimeEnd: rangeEndTime(warningStartTime),
      carNum: carNum,
    );
    return result.when(
      success: (data) => data.items,
      failure: (error) {
        AppLog.warning('违规记录查询失败: ${error.message}');
        throw Exception(error.message);
      },
    );
  }

  /// 详情-拉黑记录分页。
  Future<List<VehicleBlackRecordModel>> loadBlackRecords(
    int pageIndex,
    int pageSize, {
    String? keyword,
    String? carNumb,
    String? realName,
    Object? type,
  }) async {
    final result = await _repository.getBlackRecordPage(
      pageIndex: pageIndex,
      pageSize: pageSize,
      keyword: keyword,
      carNumb: carNumb,
      realName: realName,
      type: type,
    );
    return result.when(
      success: (data) => data.items,
      failure: (error) {
        AppLog.warning('拉黑记录查询失败: ${error.message}');
        throw Exception(error.message);
      },
    );
  }

  /// 格式化日期范围开始时间。
  String? rangeStartTime(DateTimeRange? range) {
    if (range == null) return null;
    return formatDateTime(
      DateTime(range.start.year, range.start.month, range.start.day, 0, 0, 0),
    );
  }

  /// 格式化日期范围结束时间。
  String? rangeEndTime(DateTimeRange? range) {
    if (range == null) return null;
    return formatDateTime(
      DateTime(range.end.year, range.end.month, range.end.day, 23, 59, 59),
    );
  }

  /// 格式化时间。
  String formatDateTime(DateTime dateTime) {
    final year = dateTime.year.toString().padLeft(4, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final second = dateTime.second.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute:$second';
  }

  static List<VehicleCountCardData> _defaultCountCards() {
    return const [
      VehicleCountCardData(
        name: '危化车',
        type: 1,
        accentColor: Color(0xFFEC5858),
      ),
      VehicleCountCardData(
        name: '危废车',
        type: 2,
        accentColor: Color(0xFFFFA126),
      ),
      VehicleCountCardData(
        name: '普通车',
        type: 3,
        accentColor: Color(0xFF26A4FF),
      ),
      VehicleCountCardData(
        name: '普货车',
        type: 4,
        accentColor: Color(0xFF37B6FF),
      ),
    ];
  }
}

/// 顶部统计卡片。
class VehicleCountCardData {
  final String name;
  final int type;
  final Color accentColor;
  final List<VehicleCountMetricData> metrics;

  const VehicleCountCardData({
    required this.name,
    required this.type,
    required this.accentColor,
    this.metrics = const [
      VehicleCountMetricData(label: '总数', value: 0),
      VehicleCountMetricData(label: '黑名单', value: 0),
      VehicleCountMetricData(label: '白名单', value: 0),
      VehicleCountMetricData(label: '预约', value: 0),
    ],
  });

  VehicleCountCardData copyWith({
    String? name,
    int? type,
    Color? accentColor,
    List<VehicleCountMetricData>? metrics,
  }) {
    return VehicleCountCardData(
      name: name ?? this.name,
      type: type ?? this.type,
      accentColor: accentColor ?? this.accentColor,
      metrics: metrics ?? this.metrics,
    );
  }
}

/// 统计指标项。
class VehicleCountMetricData {
  final String label;
  final int value;

  const VehicleCountMetricData({required this.label, required this.value});
}
