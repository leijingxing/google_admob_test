import '../../core/http/http_service.dart';
import '../../core/http/result.dart';
import '../models/workbench/appointment_approval_item_model.dart';

/// 工作台模块数据仓库：统一处理工作台相关接口。
class WorkbenchRepository {
  final HttpService _httpService = HttpService();

  /// 获取任务进度跟踪百分比。
  ///
  /// 对齐前端 Vue 接口：
  /// `POST /api/closed-off/workbenchStatistics/taskProgressStatistics`
  /// 接口 `data` 预期为数字百分比（如 60）。
  Future<Result<double>> getTaskProgressPercent() {
    return _httpService.post<double>(
      '/api/closed-off/workbenchStatistics/taskProgressStatistics',
      data: const {},
      parser: (json) {
        if (json is num) {
          return json.toDouble();
        }
        if (json is String) {
          return double.tryParse(json) ?? 0;
        }
        return 0;
      },
    );
  }

  /// 获取预约审批分页列表。
  ///
  /// [approvePageType]：2-园区待审批；3-园区已审批。
  Future<Result<PaginatedResult<AppointmentApprovalItemModel>>>
  getReservationApprovePage({
    required int approvePageType,
    int current = 1,
    int size = 20,
    int? reservationType,
    int? parkCheckStatus,
    String? keywords,
    String? beginTime,
    String? endTime,
  }) {
    final requestData = <String, dynamic>{
      'approvePageType': approvePageType,
      'current': current,
      'size': size,
      'reservationType': reservationType,
      'parkCheckStatus': parkCheckStatus,
      'keywords': keywords,
      'beginTime': beginTime,
      'endTime': endTime,
    };
    requestData.removeWhere((_, value) {
      if (value == null) return true;
      if (value is String && value.isEmpty) return true;
      return false;
    });

    return _httpService.post<PaginatedResult<AppointmentApprovalItemModel>>(
      '/api/closed-off/reservation/reservationApprovePage',
      data: requestData,
      parser: (json) => PaginatedResult<AppointmentApprovalItemModel>.fromJson(
        Map<String, dynamic>.from(json as Map),
        (itemJson) => AppointmentApprovalItemModel.fromJson(
          Map<String, dynamic>.from(itemJson as Map),
        ),
      ),
    );
  }
}
