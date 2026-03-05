import '../../core/http/http_service.dart';
import '../../core/http/paginated_parser.dart';
import '../../core/http/result.dart';
import '../models/workbench/appointment_approval_item_model.dart';
import '../models/workbench/checkpoint_area_option_model.dart';

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
  }) async {
    final requestData = <String, dynamic>{
      'approvePageType': approvePageType,
      'pageIndex': current,
      'pageSize': size,
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

    final postResult = await _httpService
        .post<PaginatedResult<AppointmentApprovalItemModel>>(
          '/api/closed-off/reservation/reservationApprovePage',
          data: requestData,
          parser: (json) => parsePaginatedResult<AppointmentApprovalItemModel>(
            json: json,
            requestPageIndex: current,
            requestPageSize: size,
            itemParser: (itemJson) =>
                AppointmentApprovalItemModel.fromJson(itemJson),
          ),
        );

    if (postResult is Success<PaginatedResult<AppointmentApprovalItemModel>>) {
      return postResult;
    }

    final error =
        (postResult as Failure<PaginatedResult<AppointmentApprovalItemModel>>)
            .error;
    if (error.code != 405) {
      return postResult;
    }

    return _httpService.get<PaginatedResult<AppointmentApprovalItemModel>>(
      '/api/closed-off/reservation/reservationApprovePage',
      queryParameters: requestData,
      parser: (json) => parsePaginatedResult<AppointmentApprovalItemModel>(
        json: json,
        requestPageIndex: current,
        requestPageSize: size,
        itemParser: (itemJson) =>
            AppointmentApprovalItemModel.fromJson(itemJson),
      ),
    );
  }

  /// 获取预约审批详情。
  Future<Result<Map<String, dynamic>>> getReservationProgressInfo({
    required String id,
  }) {
    return _httpService.get<Map<String, dynamic>>(
      '/api/closed-off/reservation/reservationProgressInfo/$id',
      parser: (json) {
        if (json is Map) {
          return Map<String, dynamic>.from(json);
        }
        if (json is List && json.isNotEmpty && json.first is Map) {
          return Map<String, dynamic>.from(json.first as Map);
        }
        throw StateError('详情解析失败，期望 Map，实际为 ${json.runtimeType}');
      },
    );
  }

  /// 园区审批预约。
  Future<Result<void>> parkApproveReservation({
    required String id,
    required int parkCheckStatus,
    required String parkCheckDesc,
    required String validityBeginTime,
    required String validityEndTime,
    required List<String> inDistrictIds,
    required List<String> outDistrictIds,
    required List<String> inDeviceCodes,
    required List<String> outDeviceCodes,
    required int sampleCheck,
  }) async {
    final result = await _httpService.post<dynamic>(
      '/api/closed-off/reservation/parkApproveReservation',
      data: {
        'dto': {
          'id': id,
          'parkCheckStatus': parkCheckStatus,
          'parkCheckDesc': parkCheckDesc,
          'validityBeginTime': validityBeginTime,
          'validityEndTime': validityEndTime,
          'inDistrictId': inDistrictIds.join(','),
          'outDistrictId': outDistrictIds.join(','),
          'inDeviceCode': inDeviceCodes.join(','),
          'outDeviceCode': outDeviceCodes.join(','),
          'sampleCheck': sampleCheck,
        },
      },
    );
    return result.when(
      success: (_) => const Success<void>(null),
      failure: (error) => Failure<void>(error),
    );
  }

  /// 获取审批闸机列表（授权入口/授权出口）。
  Future<Result<List<CheckpointAreaOption>>> getCheckPointDevice({
    required int inOrOut,
    required int deviceType,
    String? validityBeginTime,
    String? validityEndTime,
  }) {
    final data = <String, dynamic>{
      'inOrOut': inOrOut,
      'deviceClass': [1],
      'deviceType': deviceType,
    };
    if ((validityBeginTime ?? '').isNotEmpty &&
        (validityEndTime ?? '').isNotEmpty) {
      data['approvalDate'] = [validityBeginTime, validityEndTime];
    }

    return _httpService.post<List<CheckpointAreaOption>>(
      '/api/closed-off/device/getCheckPointDevice',
      data: data,
      parser: (json) => (json is List ? json : const <dynamic>[])
          .map(
            (item) => CheckpointAreaOption.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }
}
