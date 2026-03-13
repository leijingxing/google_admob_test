import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/components/select/app_company_select_field.dart';
import '../../../../core/components/toast/toast_widget.dart';
import '../../../../data/models/overview/approval_black_white_list_model.dart';
import '../../../../data/models/overview/company_overview_model.dart';
import '../../../../data/models/overview/hazardous_waste_in_and_out_model.dart';
import '../../../../data/models/overview/overview_models.dart';
import '../../../../data/repository/overview_repository.dart';
import 'overview_statistics_models.dart';

/// 总览统计控制器：按区块维护筛选状态，便于后续分模块对接接口。
class OverviewStatisticsController extends GetxController {
  final OverviewRepository _repository = OverviewRepository();

  static const String yardSectionId = 'overview_yard_section';
  static const String approvalSectionId = 'overview_approval_section';
  static const String reservationSectionId = 'overview_reservation_section';
  static const String hazardousInSectionId = 'overview_hazardous_in_section';
  static const String hazardousOutSectionId = 'overview_hazardous_out_section';
  static const String enterpriseSectionId = 'overview_enterprise_section';

  /// 危化品入园统计筛选：日期范围。
  DateTimeRange? hazardousInRange;

  /// 危化品出园统计筛选：日期范围。
  DateTimeRange? hazardousOutRange;

  /// 园内统计筛选：日期范围。
  DateTimeRange? yardRange;

  /// 今日预约情况：选中企业。
  AppSelectedCompany? selectedReservationCompany;

  /// 企业情况概览：选中企业。
  AppSelectedCompany? selectedEnterpriseCompany;

  /// 审批统计数据。
  List<ApprovalStatRow> approvalRows = _defaultApprovalRows();

  /// 园内统计卡片。
  List<YardStatCardData> yardStats = _defaultYardStats();

  /// 危化品入园饼图数据。
  List<PiePoint> hazardousInPie = const <PiePoint>[];

  /// 危化品出园饼图数据。
  List<PiePoint> hazardousOutPie = const <PiePoint>[];

  /// 今日预约概览指标。
  List<ReservationSummaryMetric> get reservationSummaryMetrics => const [
    ReservationSummaryMetric(value: '0', label: '人员'),
    ReservationSummaryMetric(value: '245', label: '普通车辆'),
    ReservationSummaryMetric(value: '121', label: '危化车辆'),
    ReservationSummaryMetric(value: '0', label: '危废车辆'),
    ReservationSummaryMetric(value: '8/366', label: '待审批/已提交'),
  ];

  /// 今日预约折线数据。
  List<ReservationTrendSeries> get reservationTrendSeries => const [
    ReservationTrendSeries(
      label: '人员',
      color: Color(0xFF4C7DFF),
      points: [
        ReservationTrendPoint(time: '00:00', value: 0),
        ReservationTrendPoint(time: '02:00', value: 0),
        ReservationTrendPoint(time: '04:00', value: 0),
        ReservationTrendPoint(time: '06:00', value: 0),
        ReservationTrendPoint(time: '08:00', value: 0),
        ReservationTrendPoint(time: '10:00', value: 0),
        ReservationTrendPoint(time: '12:00', value: 0),
        ReservationTrendPoint(time: '14:00', value: 0),
        ReservationTrendPoint(time: '16:00', value: 0),
        ReservationTrendPoint(time: '18:00', value: 0),
        ReservationTrendPoint(time: '20:00', value: 0),
        ReservationTrendPoint(time: '22:00', value: 0),
      ],
    ),
    ReservationTrendSeries(
      label: '普通车辆',
      color: Color(0xFF59D3B4),
      points: [
        ReservationTrendPoint(time: '00:00', value: 6),
        ReservationTrendPoint(time: '02:00', value: 2),
        ReservationTrendPoint(time: '04:00', value: 0),
        ReservationTrendPoint(time: '06:00', value: 0),
        ReservationTrendPoint(time: '08:00', value: 24),
        ReservationTrendPoint(time: '10:00', value: 29),
        ReservationTrendPoint(time: '12:00', value: 16),
        ReservationTrendPoint(time: '13:00', value: 41),
        ReservationTrendPoint(time: '14:00', value: 31),
        ReservationTrendPoint(time: '15:00', value: 3),
        ReservationTrendPoint(time: '16:00', value: 0),
        ReservationTrendPoint(time: '22:00', value: 0),
      ],
    ),
    ReservationTrendSeries(
      label: '危化车辆',
      color: Color(0xFFE4A32A),
      points: [
        ReservationTrendPoint(time: '00:00', value: 0),
        ReservationTrendPoint(time: '02:00', value: 0),
        ReservationTrendPoint(time: '04:00', value: 0),
        ReservationTrendPoint(time: '06:00', value: 0),
        ReservationTrendPoint(time: '07:00', value: 8),
        ReservationTrendPoint(time: '08:00', value: 20),
        ReservationTrendPoint(time: '09:00', value: 15),
        ReservationTrendPoint(time: '10:00', value: 16),
        ReservationTrendPoint(time: '11:00', value: 14),
        ReservationTrendPoint(time: '12:00', value: 12),
        ReservationTrendPoint(time: '13:00', value: 6),
        ReservationTrendPoint(time: '14:00', value: 9),
        ReservationTrendPoint(time: '15:00', value: 0),
        ReservationTrendPoint(time: '22:00', value: 0),
      ],
    ),
    ReservationTrendSeries(
      label: '危废车辆',
      color: Color(0xFFFF7B2F),
      points: [
        ReservationTrendPoint(time: '00:00', value: 0),
        ReservationTrendPoint(time: '06:00', value: 0),
        ReservationTrendPoint(time: '12:00', value: 0),
        ReservationTrendPoint(time: '18:00', value: 0),
        ReservationTrendPoint(time: '22:00', value: 0),
      ],
    ),
  ];

  /// 企业情况概览列表。
  List<EnterpriseOverviewItem> enterpriseOverviewItems =
      _defaultEnterpriseOverviewItems();

  @override
  void onInit() {
    super.onInit();
    unawaited(loadYardStatistics());
    unawaited(loadApprovalStatistics());
    unawaited(loadHazardousInStatistics());
    unawaited(loadHazardousOutStatistics());
    unawaited(loadEnterpriseOverview());
  }

  /// 更新今日预约情况企业筛选。
  void onReservationCompanyChanged(AppSelectedCompany? value) {
    selectedReservationCompany = value;
    update([reservationSectionId]);
  }

  /// 更新企业情况概览企业筛选。
  void onEnterpriseCompanyChanged(AppSelectedCompany? value) {
    selectedEnterpriseCompany = value;
    update([enterpriseSectionId]);
    unawaited(loadEnterpriseOverview());
  }

  /// 刷新今日预约情况。
  void refreshReservationTrend() {
    update([reservationSectionId]);
  }

  /// 更新入园统计时间范围。
  void onHazardousInRangeChanged(DateTimeRange? value) {
    hazardousInRange = value;
    update([hazardousInSectionId]);
    unawaited(loadHazardousInStatistics());
  }

  /// 更新出园统计时间范围。
  void onHazardousOutRangeChanged(DateTimeRange? value) {
    hazardousOutRange = value;
    update([hazardousOutSectionId]);
    unawaited(loadHazardousOutStatistics());
  }

  /// 更新园内统计时间范围。
  void onYardRangeChanged(DateTimeRange? value) {
    yardRange = value;
    update([yardSectionId]);
    unawaited(loadYardStatistics());
  }

  /// 拉取园内统计。
  Future<void> loadYardStatistics() async {
    final result = await _repository.getParkStatistics(
      startTime: _rangeStartTime(yardRange),
      endTime: _rangeEndTime(yardRange),
    );

    result.when(
      success: (data) {
        yardStats = _buildYardStats(data);
        update([yardSectionId]);
      },
      failure: (error) {
        AppToast.showError(error.message);
      },
    );
  }

  /// 拉取审批统计。
  Future<void> loadApprovalStatistics() async {
    final result = await _repository.getTodayApprovalBlackWhiteList();

    result.when(
      success: (data) {
        approvalRows = _buildApprovalRows(data);
        update([approvalSectionId]);
      },
      failure: (error) {
        AppToast.showError(error.message);
      },
    );
  }

  /// 拉取危化品入园统计。
  Future<void> loadHazardousInStatistics() async {
    final result = await _repository.getHazardousWasteInAndOut(
      strDateTime: _rangeStartTime(hazardousInRange),
      endDateTime: _rangeEndTime(hazardousInRange),
      inOut: '1',
    );

    result.when(
      success: (data) {
        hazardousInPie = _buildHazardousPie(data);
        update([hazardousInSectionId]);
      },
      failure: (error) {
        AppToast.showError(error.message);
      },
    );
  }

  /// 拉取危化品出园统计。
  Future<void> loadHazardousOutStatistics() async {
    final result = await _repository.getHazardousWasteInAndOut(
      strDateTime: _rangeStartTime(hazardousOutRange),
      endDateTime: _rangeEndTime(hazardousOutRange),
      inOut: '0',
    );

    result.when(
      success: (data) {
        hazardousOutPie = _buildHazardousPie(data);
        update([hazardousOutSectionId]);
      },
      failure: (error) {
        AppToast.showError(error.message);
      },
    );
  }

  /// 拉取企业情况概览。
  Future<void> loadEnterpriseOverview() async {
    final result = await _repository.getCompanyOverview(
      companyId: selectedEnterpriseCompany?.id,
    );

    result.when(
      success: (data) {
        enterpriseOverviewItems = _buildEnterpriseOverviewItems(data);
        update([enterpriseSectionId]);
      },
      failure: (error) {
        AppToast.showError(error.message);
      },
    );
  }

  static List<YardStatCardData> _buildYardStats(
    List<ParkStatisticsModel> data,
  ) {
    final byType = <int, ParkStatisticsModel>{
      for (final item in data) item.type: item,
    };

    return [
      _buildVehicleStatCard('危化车辆统计', byType[3]),
      _buildGoodsStatCard('危化品统计(吨/立方)', byType[3]),
      _buildVehicleStatCard('危废车辆统计', byType[4]),
      _buildGoodsStatCard('危废物统计(吨/立方)', byType[4]),
      _buildVehicleStatCard('普通车统计', byType[2]),
      _buildVehicleStatCard('货车统计', byType[5]),
      _buildGoodsStatCard('货物统计(吨/立方)', byType[5]),
      YardStatCardData(
        title: '人员统计',
        metrics: [
          YardMetric(
            value: '${byType[1]?.currentInParkCount ?? 0}',
            label: '当前在园',
          ),
        ],
      ),
    ];
  }

  static YardStatCardData _buildVehicleStatCard(
    String title,
    ParkStatisticsModel? model,
  ) {
    return YardStatCardData(
      title: title,
      metrics: [
        YardMetric(value: '${model?.currentInParkCount ?? 0}', label: '当前在园'),
        YardMetric(
          value: '${model?.inParkCount ?? 0}/${model?.outParkCount ?? 0}',
          label: '入/出园车辆',
        ),
        YardMetric(
          value: '${model?.inCount ?? 0}/${model?.outCount ?? 0}',
          label: '入/出园次数',
        ),
      ],
    );
  }

  static YardStatCardData _buildGoodsStatCard(
    String title,
    ParkStatisticsModel? model,
  ) {
    return YardStatCardData(
      title: title,
      metrics: [
        YardMetric(value: _formatNumber(model?.inGoodsAmount), label: '入园'),
        YardMetric(value: _formatNumber(model?.outGoodsAmount), label: '出园'),
        YardMetric(
          value: _formatNumber(model?.totalInGoodsAmount),
          label: '累计入园',
        ),
        YardMetric(
          value: _formatNumber(model?.totalOutGoodsAmount),
          label: '累计出园',
        ),
        YardMetric(value: '${model?.typeCount ?? 0}', label: '种类'),
      ],
    );
  }

  static List<YardStatCardData> _defaultYardStats() =>
      _buildYardStats(const <ParkStatisticsModel>[]);

  static List<ApprovalStatRow> _buildApprovalRows(
    ApprovalBlackWhiteListModel model,
  ) {
    return [
      ApprovalStatRow(
        title: '今日已审批',
        icon: Icons.task_alt_rounded,
        leftLabel: '企业',
        leftValue: '${model.companyApprovalCount}',
        rightLabel: '园区',
        rightValue: '${model.parkApprovalCount}',
      ),
      ApprovalStatRow(
        title: '今日新增黑名单',
        icon: Icons.person_off_rounded,
        leftLabel: '人员',
        leftValue: '${model.personBlackListCount}',
        rightLabel: '车辆',
        rightValue: '${model.carBlackListCount}',
      ),
      ApprovalStatRow(
        title: '今日新增白名单',
        icon: Icons.verified_user_rounded,
        leftLabel: '人员',
        leftValue: '${model.personWhiteListCount}',
        rightLabel: '车辆',
        rightValue: '${model.carWhiteListCount}',
      ),
    ];
  }

  static List<ApprovalStatRow> _defaultApprovalRows() =>
      _buildApprovalRows(const ApprovalBlackWhiteListModel());

  static List<PiePoint> _buildHazardousPie(
    List<HazardousWasteInAndOutModel> data,
  ) {
    return data
        .map(
          (item) => PiePoint(
            name: item.goodsName.isEmpty ? '未命名' : item.goodsName,
            value: item.count,
          ),
        )
        .toList();
  }

  static List<EnterpriseOverviewItem> _buildEnterpriseOverviewItems(
    List<CompanyOverviewModel> data,
  ) {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final phone = item.responsibleMobile.isNotEmpty
          ? item.responsibleMobile
          : item.responsiblePhone;
      return EnterpriseOverviewItem(
        index: index + 1,
        companyName: item.companyName,
        ownerName: item.responsiblePerson,
        phone: phone.isEmpty ? '--' : phone,
        pendingCount: '${item.approvalPendingCount}',
        approvedCount: '${item.approvalApprovedCount}',
        newBlacklistCount: '${item.blackListCount}',
        newWhitelistCount: '${item.whiteListCount}',
        onDutyEmployeeCount: item.onDutyPersonName.isEmpty
            ? '--'
            : item.onDutyPersonName,
      );
    }).toList();
  }

  static List<EnterpriseOverviewItem> _defaultEnterpriseOverviewItems() =>
      const <EnterpriseOverviewItem>[];

  String? _rangeStartTime(DateTimeRange? range) {
    if (range == null) return null;
    return _formatDateTime(
      DateTime(range.start.year, range.start.month, range.start.day, 0, 0, 0),
    );
  }

  String? _rangeEndTime(DateTimeRange? range) {
    if (range == null) return null;
    return _formatDateTime(
      DateTime(range.end.year, range.end.month, range.end.day, 23, 59, 59),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final year = dateTime.year.toString().padLeft(4, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final second = dateTime.second.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute:$second';
  }

  static String _formatNumber(num? value) {
    final safeValue = value ?? 0;
    if (safeValue == safeValue.toInt()) {
      return safeValue.toInt().toString();
    }
    return safeValue.toStringAsFixed(2);
  }
}
