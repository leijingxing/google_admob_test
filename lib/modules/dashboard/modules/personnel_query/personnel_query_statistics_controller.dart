import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/components/log_util.dart';
import '../../../../core/components/toast/toast_widget.dart';
import '../../../../core/utils/dict_field_query_tool.dart';
import '../../../../data/models/personnel_query/personnel_query_models.dart';
import '../../../../data/models/vehicle_query/vehicle_query_models.dart';
import '../../../../data/repository/personnel_query_repository.dart';
import '../../../../data/repository/vehicle_query_repository.dart';

/// 人员查询控制器：维护筛选条件、统计数据与列表查询。
class PersonnelQueryStatisticsController extends GetxController {
  final PersonnelQueryRepository _repository = PersonnelQueryRepository();
  final VehicleQueryRepository _detailRepository = VehicleQueryRepository();

  static const List<String> _pageDictTypes = <String>[
    DictFieldQueryTool.validityStatus,
  ];

  /// 主列表关键字。
  final TextEditingController mainKeywordController = TextEditingController();

  /// 主列表开始/结束时间。
  DateTimeRange? mainDateRange;

  /// 主列表刷新触发器。
  final ValueNotifier<int> mainRefreshTrigger = ValueNotifier<int>(0);

  /// 顶部统计加载态。
  bool statsLoading = false;

  /// 顶部统计。
  PersonnelCountModel countData = const PersonnelCountModel();

  /// 有效状态文案（统一由字典工具提供）。
  static String validityStatusText(int? validityStatus) {
    if (validityStatus == null) return '--';
    return DictFieldQueryTool.validityStatusLabel(
      validityStatus,
      fallback: '$validityStatus',
    );
  }

  @override
  void onInit() {
    super.onInit();
    _preloadDictItems();
    loadPersonnelCount();
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
    mainRefreshTrigger.value++;
    update();
  }

  /// 修改主列表时间范围。
  void onMainDateRangeChanged(DateTimeRange? value) {
    mainDateRange = value;
    update();
  }

  /// 主列表分页加载。
  Future<List<PersonnelComprehensiveItemModel>> loadMainList(
    int pageIndex,
    int pageSize,
  ) async {
    final result = await _repository.getPersonnelComprehensivePage(
      pageIndex: pageIndex,
      pageSize: pageSize,
      keyWords: mainKeywordController.text.trim(),
      startTime: rangeStartTime(mainDateRange),
      endTime: rangeEndTime(mainDateRange),
    );

    return result.when(
      success: (data) => data.items,
      failure: (error) {
        AppLog.warning('人员主列表查询失败: ${error.message}');
        throw Exception(error.message);
      },
    );
  }

  /// 刷新顶部统计。
  Future<void> loadPersonnelCount() async {
    statsLoading = true;
    update();

    final result = await _repository.getPersonnelCount();
    result.when(
      success: (data) {
        countData = data;
      },
      failure: (error) {
        AppLog.warning('人员统计查询失败: ${error.message}');
        AppToast.showError(error.message);
        countData = const PersonnelCountModel();
      },
    );

    statsLoading = false;
    update();
  }

  /// 详情抽屉统计。
  Future<ComprehensiveDetailCountModel> loadDetailCount({
    required String idCard,
  }) async {
    final result = await _detailRepository.getComprehensiveDetailCount(
      carNumb: '',
      idCard: idCard,
    );

    return result.when(
      success: (data) => data,
      failure: (error) {
        AppLog.warning('人员详情统计查询失败: ${error.message}');
        throw Exception(error.message);
      },
    );
  }

  /// 详情-授权记录分页。
  Future<List<VehicleAuthorizationRecordModel>> loadAuthorizationRecords(
    int pageIndex,
    int pageSize, {
    required String idCard,
    String? keyWords,
    DateTimeRange? parkCheckTime,
    DateTimeRange? inDate,
  }) async {
    final result = await _detailRepository.getAuthorizationRecordPage(
      pageIndex: pageIndex,
      pageSize: pageSize,
      keyWords: keyWords,
      strParkCheckTime: rangeStartTime(parkCheckTime),
      endParkCheckTime: rangeEndTime(parkCheckTime),
      strInDate: rangeStartTime(inDate),
      endInDate: rangeEndTime(inDate),
      carNumb: '',
      idCard: idCard,
      type: null,
    );

    return result.when(
      success: (data) => data.items,
      failure: (error) {
        AppLog.warning('人员授权记录查询失败: ${error.message}');
        throw Exception(error.message);
      },
    );
  }

  /// 详情-出入记录分页。
  Future<List<VehicleAccessRecordModel>> loadAccessRecords(
    int pageIndex,
    int pageSize, {
    required String idCard,
    String? keyWords,
    DateTimeRange? inDate,
    DateTimeRange? outDate,
    Object? type = 1,
  }) async {
    final result = await _detailRepository.getAccessRecordPage(
      pageIndex: pageIndex,
      pageSize: pageSize,
      keyWords: keyWords,
      inDateBegin: rangeStartTime(inDate),
      inDateEnd: rangeEndTime(inDate),
      outDateBegin: rangeStartTime(outDate),
      outDateEnd: rangeEndTime(outDate),
      carNumb: '',
      idCard: idCard,
      type: type,
    );

    return result.when(
      success: (data) => data.items,
      failure: (error) {
        AppLog.warning('人员出入记录查询失败: ${error.message}');
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
    final result = await _detailRepository.getViolationRecordPage(
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
        AppLog.warning('人员违规记录查询失败: ${error.message}');
        throw Exception(error.message);
      },
    );
  }

  /// 详情-拉黑记录分页。
  Future<List<VehicleBlackRecordModel>> loadBlackRecords(
    int pageIndex,
    int pageSize, {
    String? keyword,
    String? realName,
    Object? type = 1,
  }) async {
    final result = await _detailRepository.getBlackRecordPage(
      pageIndex: pageIndex,
      pageSize: pageSize,
      keyword: keyword,
      carNumb: '',
      realName: realName,
      type: type,
    );

    return result.when(
      success: (data) => data.items,
      failure: (error) {
        AppLog.warning('人员拉黑记录查询失败: ${error.message}');
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
}
