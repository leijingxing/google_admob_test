import '../../core/http/http_service.dart';
import '../../core/http/result.dart';
import '../models/overview/approval_black_white_list_model.dart';
import '../models/overview/approval_pending_statistics_model.dart';
import '../models/overview/company_overview_model.dart';
import '../models/overview/hazardous_waste_in_and_out_model.dart';
import '../models/overview/overview_models.dart';
import '../models/overview/park_inner_flow_statistics_model.dart';
import '../models/overview/today_reservation_model.dart';

/// 总览模块仓库。
class OverviewRepository {
  final HttpService _httpService = HttpService();

  /// 园内统计。
  Future<Result<List<ParkStatisticsModel>>> getParkStatistics({
    String? startTime,
    String? endTime,
  }) {
    return _httpService.post<List<ParkStatisticsModel>>(
      '/api/closed-off/parkOverview/parkStatistics',
      data: <String, dynamic>{'startTime': startTime, 'endTime': endTime}
        ..removeWhere((key, value) => value == null || value == ''),
      parser: (json) => (json is List ? json : const <dynamic>[])
          .map(
            (item) => ParkStatisticsModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }

  /// 待审批统计。
  Future<Result<ApprovalPendingStatisticsModel>> getApprovalPendingStatistics({
    String? startTime,
    String? endTime,
  }) {
    return _httpService.post<ApprovalPendingStatisticsModel>(
      '/api/closed-off/parkOverview/approvalPendingStatistics',
      data: <String, dynamic>{'startTime': startTime, 'endTime': endTime}
        ..removeWhere((key, value) => value == null || value == ''),
      parser: (json) => ApprovalPendingStatisticsModel.fromJson(
        Map<String, dynamic>.from(json as Map),
      ),
    );
  }

  /// 今日审批-黑白名单统计。
  Future<Result<ApprovalBlackWhiteListModel>> getTodayApprovalBlackWhiteList() {
    return _httpService.get<ApprovalBlackWhiteListModel>(
      '/api/closed-off/parkOverview/todayApprovalBlackWhiteList',
      parser: (json) => ApprovalBlackWhiteListModel.fromJson(
        Map<String, dynamic>.from(json as Map),
      ),
    );
  }

  /// 今日预约情况。
  Future<Result<TodayReservationModel>> getTodayReservation({
    String? companyId,
  }) {
    return _httpService.get<TodayReservationModel>(
      '/api/closed-off/parkOverview/todayReservation',
      queryParameters: <String, dynamic>{'companyId': companyId}
        ..removeWhere((key, value) => value == null || value == ''),
      parser: (json) => TodayReservationModel.fromJson(
        Map<String, dynamic>.from(json as Map),
      ),
    );
  }

  /// 园区内人车流统计。
  Future<Result<List<ParkInnerFlowStatisticsModel>>>
  getParkInnerFlowStatistics({
    required int type,
    String? strDateTime,
    String? endDateTime,
  }) {
    return _httpService.post<List<ParkInnerFlowStatisticsModel>>(
      '/api/closed-off/parkOverview/parkInnerFlowStatistics',
      data: <String, dynamic>{
        'type': type,
        'strDateTime': strDateTime,
        'endDateTime': endDateTime,
      }..removeWhere((key, value) => value == null || value == ''),
      parser: (json) => (json is List ? json : const <dynamic>[])
          .map(
            (item) => ParkInnerFlowStatisticsModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }

  /// 危化品出入园数量。
  Future<Result<List<HazardousWasteInAndOutModel>>> getHazardousWasteInAndOut({
    String? strDateTime,
    String? endDateTime,
    String? hazardousName,
    required String inOut,
  }) {
    return _httpService.post<List<HazardousWasteInAndOutModel>>(
      '/api/closed-off/parkOverview/hazardousWasteInAndOut',
      data: <String, dynamic>{
        'strDateTime': strDateTime,
        'endDateTime': endDateTime,
        'hazardousName': hazardousName,
        'inOut': inOut,
      }..removeWhere((key, value) => value == null || value == ''),
      parser: (json) => (json is List ? json : const <dynamic>[])
          .map(
            (item) => HazardousWasteInAndOutModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }

  /// 企业情况概览。
  Future<Result<List<CompanyOverviewModel>>> getCompanyOverview({
    String? companyId,
  }) {
    return _httpService.get<List<CompanyOverviewModel>>(
      '/api/closed-off/parkOverview/companyOverview',
      queryParameters: <String, dynamic>{'companyId': companyId}
        ..removeWhere((key, value) => value == null || value == ''),
      parser: (json) => (json is List ? json : const <dynamic>[])
          .map(
            (item) => CompanyOverviewModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }
}
