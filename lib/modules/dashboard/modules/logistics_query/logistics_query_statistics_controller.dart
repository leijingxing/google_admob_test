import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/components/log_util.dart';
import '../../../../core/components/toast/toast_widget.dart';
import '../../../../core/utils/dict_field_query_tool.dart';
import '../../../../data/models/logistics_query/logistics_query_models.dart';
import '../../../../data/repository/logistics_query_repository.dart';

/// 物流查询控制器：维护筛选条件、统计数据与列表查询。
class LogisticsQueryStatisticsController extends GetxController {
  final LogisticsQueryRepository _repository = LogisticsQueryRepository();

  static const List<String> _pageDictTypes = <String>[
    DictFieldQueryTool.goodsType,
    DictFieldQueryTool.loadType,
  ];

  /// 主列表关键字。
  final TextEditingController mainKeywordController = TextEditingController();

  /// 主列表开始/结束时间。
  DateTimeRange? mainDateRange;

  /// 主列表物资类型筛选。
  int? mainGoodsType;

  /// 主列表刷新触发器。
  final ValueNotifier<int> mainRefreshTrigger = ValueNotifier<int>(0);

  /// 顶部统计加载态。
  bool statsLoading = false;

  /// 顶部统计卡片。
  List<LogisticsCountCardData> countCards = _defaultCountCards();

  /// 货物类型文案。
  static String? goodsTypeText(int? goodsType, {bool fallbackRaw = false}) {
    if (goodsType == null) return null;
    final label = DictFieldQueryTool.goodsTypeLabel(goodsType, fallback: '');
    if (label.isNotEmpty) return label;
    return fallbackRaw ? '$goodsType' : null;
  }

  /// 装载类型文案。
  static String loadTypeText(int? loadType) {
    if (loadType == null) return '--';
    return DictFieldQueryTool.loadTypeLabel(loadType, fallback: '$loadType');
  }

  @override
  void onInit() {
    super.onInit();
    _preloadDictItems();
    loadLogisticsCountCards();
  }

  @override
  void onClose() {
    mainKeywordController.dispose();
    mainRefreshTrigger.dispose();
    super.onClose();
  }

  void _preloadDictItems() {
    unawaited(
      DictFieldQueryTool.ensureLoaded(dictTypes: _pageDictTypes).then((loaded) {
        if (!loaded) return;
        update();
      }),
    );
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
    mainGoodsType = null;
    mainRefreshTrigger.value++;
    update();
  }

  /// 修改主列表时间范围。
  void onMainDateRangeChanged(DateTimeRange? value) {
    mainDateRange = value;
    update();
  }

  /// 修改主列表物资类型。
  void onMainGoodsTypeChanged(int? value) {
    mainGoodsType = value;
    update();
  }

  /// 主列表分页加载。
  Future<List<LogisticsComprehensiveItemModel>> loadMainList(
    int pageIndex,
    int pageSize,
  ) async {
    final result = await _repository.getLogisticsPage(
      pageIndex: pageIndex,
      pageSize: pageSize,
      keyWords: mainKeywordController.text.trim(),
      strDate: rangeStartTime(mainDateRange),
      endDate: rangeEndTime(mainDateRange),
      goodsType: mainGoodsType,
    );

    return result.when(
      success: (data) => data.items,
      failure: (error) {
        AppLog.warning('物流主列表查询失败: ${error.message}');
        throw Exception(error.message);
      },
    );
  }

  /// 刷新顶部统计。
  Future<void> loadLogisticsCountCards() async {
    statsLoading = true;
    update();

    final result = await _repository.getLogisticsStatistics();
    result.when(
      success: _applyStatistics,
      failure: (error) {
        AppLog.warning('物流统计查询失败: ${error.message}');
        AppToast.showError(error.message);
        countCards = _defaultCountCards();
      },
    );

    statsLoading = false;
    update();
  }

  void _applyStatistics(List<LogisticsStatisticsItemModel> sourceData) {
    final byType = <int, LogisticsStatisticsItemModel>{
      for (final item in sourceData)
        if (item.hazardousType != 0) item.hazardousType: item,
    };

    countCards = _defaultCountCards().asMap().entries.map((entry) {
      final index = entry.key;
      final card = entry.value;
      final source =
          byType[card.type] ??
          (index < sourceData.length ? sourceData[index] : null);
      if (source == null) return card;

      return card.copyWith(
        metrics: [
          LogisticsCountMetricData(
            label: source.topOneName.trim().isEmpty ? '-' : source.topOneName,
            value: source.topOneAmount,
          ),
          LogisticsCountMetricData(
            label: source.topTwoName.trim().isEmpty ? '-' : source.topTwoName,
            value: source.topTwoAmount,
          ),
          LogisticsCountMetricData(
            label: source.topThreeName.trim().isEmpty
                ? '-'
                : source.topThreeName,
            value: source.topThreeAmount,
          ),
        ],
      );
    }).toList();
  }

  /// 详情抽屉统计。
  Future<LogisticsDetailCountModel> loadDetailCount({
    required String cas,
  }) async {
    final result = await _repository.getLogisticsDetailCount(cas: cas);
    return result.when(
      success: (data) => data,
      failure: (error) {
        AppLog.warning('物流详情统计查询失败: ${error.message}');
        throw Exception(error.message);
      },
    );
  }

  /// 详情-授权记录分页。
  Future<List<LogisticsAuthorizationRecordModel>> loadAuthorizationRecords(
    int pageIndex,
    int pageSize, {
    required String cas,
    String? keyWords,
    DateTimeRange? parkCheckTime,
    DateTimeRange? inDate,
  }) async {
    final result = await _repository.getAuthorizationRecordPage(
      pageIndex: pageIndex,
      pageSize: pageSize,
      cas: cas,
      keyWords: keyWords,
      strParkCheckTime: rangeStartTime(parkCheckTime),
      endParkCheckTime: rangeEndTime(parkCheckTime),
      strInDate: rangeStartTime(inDate),
      endInDate: rangeEndTime(inDate),
    );

    return result.when(
      success: (data) => data.items,
      failure: (error) {
        AppLog.warning('物流授权记录查询失败: ${error.message}');
        throw Exception(error.message);
      },
    );
  }

  /// 详情-出入记录分页。
  Future<List<LogisticsAccessRecordModel>> loadAccessRecords(
    int pageIndex,
    int pageSize, {
    required String cas,
    String? keyWords,
    DateTimeRange? inDate,
    DateTimeRange? outDate,
  }) async {
    final result = await _repository.getAccessRecordPage(
      pageIndex: pageIndex,
      pageSize: pageSize,
      cas: cas,
      keyWords: keyWords,
      strInDate: rangeStartTime(inDate),
      endInDate: rangeEndTime(inDate),
      strOutDate: rangeStartTime(outDate),
      endOutDate: rangeEndTime(outDate),
    );

    return result.when(
      success: (data) => data.items,
      failure: (error) {
        AppLog.warning('物流出入记录查询失败: ${error.message}');
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

  static List<LogisticsCountCardData> _defaultCountCards() {
    return const [
      LogisticsCountCardData(
        name: '危化',
        type: 1,
        accentColor: Color(0xFFEC5858),
      ),
      LogisticsCountCardData(
        name: '危废',
        type: 2,
        accentColor: Color(0xFFFFA126),
      ),
      LogisticsCountCardData(
        name: '普货',
        type: 4,
        accentColor: Color(0xFF37B6FF),
      ),
    ];
  }
}

/// 顶部统计卡片。
class LogisticsCountCardData {
  final String name;
  final int type;
  final Color accentColor;
  final List<LogisticsCountMetricData> metrics;

  const LogisticsCountCardData({
    required this.name,
    required this.type,
    required this.accentColor,
    this.metrics = const [
      LogisticsCountMetricData(label: '-', value: '0'),
      LogisticsCountMetricData(label: '-', value: '0'),
      LogisticsCountMetricData(label: '-', value: '0'),
    ],
  });

  LogisticsCountCardData copyWith({
    String? name,
    int? type,
    Color? accentColor,
    List<LogisticsCountMetricData>? metrics,
  }) {
    return LogisticsCountCardData(
      name: name ?? this.name,
      type: type ?? this.type,
      accentColor: accentColor ?? this.accentColor,
      metrics: metrics ?? this.metrics,
    );
  }
}

/// 统计指标项。
class LogisticsCountMetricData {
  final String label;
  final String value;

  const LogisticsCountMetricData({required this.label, required this.value});
}
