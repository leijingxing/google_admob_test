import '../../core/http/http_service.dart';
import '../../core/http/paginated_parser.dart';
import '../../core/http/result.dart';
import '../models/vehicle_query/vehicle_query_models.dart';

/// 车辆综合查询仓库。
class VehicleQueryRepository {
  final HttpService _httpService = HttpService();

  /// 顶部统计：按车辆分类汇总。
  Future<Result<List<VehicleCategoryCountModel>>> getVehicleCount() {
    return _httpService.post<List<VehicleCategoryCountModel>>(
      '/api/closed-off/comprehensive/getVehicleCount',
      data: const <String, dynamic>{},
      parser: (json) => (json as List<dynamic>).map((item) => VehicleCategoryCountModel.fromJson(Map<String, dynamic>.from(item as Map))).toList(),
    );
  }

  /// 主列表分页。
  Future<Result<PaginatedResult<VehicleComprehensiveItemModel>>> getVehicleComprehensivePage({
    required int pageIndex,
    required int pageSize,
    String? keyword,
    int? carCategory,
    String? startTime,
    String? endTime,
  }) {
    final payload = buildPagePayload(pageIndex: pageIndex, pageSize: pageSize)
      ..addAll({'keyword': keyword, 'carCategory': carCategory, 'startTime': startTime, 'endTime': endTime})
      ..removeWhere((key, value) => value == null || value == '');
    return _httpService.post<PaginatedResult<VehicleComprehensiveItemModel>>(
      '/api/closed-off/comprehensive/getVehicleComprehensivePage',
      data: payload,
      parser: (json) => parsePaginatedResult(
        json: json,
        requestPageIndex: pageIndex,
        requestPageSize: pageSize,
        itemParser: (item) => VehicleComprehensiveItemModel.fromJson(item),
      ),
    );
  }

  /// 详情抽屉顶部统计。
  Future<Result<ComprehensiveDetailCountModel>> getComprehensiveDetailCount({required String carNumb, String? idCard}) {
    return _httpService.post<ComprehensiveDetailCountModel>(
      '/api/closed-off/comprehensive/getComprehensiveDetailCount',
      data: {'carNumb': carNumb, 'idCard': idCard}..removeWhere((key, value) => value == null || value == ''),
      parser: (json) => ComprehensiveDetailCountModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  /// 拉黑。
  Future<Result<void>> addBlackRecord({
    required String carNumb,
    required int carCategory,
    required String parkCheckDesc,
    required String validityBeginTime,
    required String validityEndTime,
  }) async {
    final result = await _httpService.post<dynamic>(
      '/api/closed-off/black',
      data: {
        'dto': {
          'carNumb': carNumb,
          'carCategory': carCategory,
          'parkCheckDesc': parkCheckDesc,
          'validityBeginTime': validityBeginTime,
          'validityEndTime': validityEndTime,
          'type': 2,
        },
        'extends': <String, dynamic>{},
      },
    );

    return result.when(success: (_) => const Success<void>(null), failure: (error) => Failure<void>(error));
  }

  /// 详情-授权记录分页。
  Future<Result<PaginatedResult<VehicleAuthorizationRecordModel>>> getAuthorizationRecordPage({
    required int pageIndex,
    required int pageSize,
    String? keyWords,
    String? strParkCheckTime,
    String? endParkCheckTime,
    String? strInDate,
    String? endInDate,
    String? carNumb,
    String? idCard,
    Object? type,
  }) {
    final payload = buildPagePayload(pageIndex: pageIndex, pageSize: pageSize)
      ..addAll({
        'keyWords': keyWords,
        'strParkCheckTime': strParkCheckTime,
        'endParkCheckTime': endParkCheckTime,
        'strInDate': strInDate,
        'endInDate': endInDate,
        'carNumb': carNumb,
        'idCard': idCard,
        'type': type,
      })
      ..removeWhere((key, value) => value == null || value == '');

    return _httpService.post<PaginatedResult<VehicleAuthorizationRecordModel>>(
      '/api/closed-off/comprehensive/getAuthorizationRecord',
      data: payload,
      parser: (json) => parsePaginatedResult(
        json: json,
        requestPageIndex: pageIndex,
        requestPageSize: pageSize,
        itemParser: (item) => VehicleAuthorizationRecordModel.fromJson(item),
      ),
    );
  }

  /// 详情-出入记录分页。
  Future<Result<PaginatedResult<VehicleAccessRecordModel>>> getAccessRecordPage({
    required int pageIndex,
    required int pageSize,
    String? keyWords,
    String? inDateBegin,
    String? inDateEnd,
    String? outDateBegin,
    String? outDateEnd,
    String? carNumb,
    String? idCard,
    Object? type,
  }) {
    final payload = buildPagePayload(pageIndex: pageIndex, pageSize: pageSize)
      ..addAll({
        'keyWords': keyWords,
        'inDateBegin': inDateBegin,
        'inDateEnd': inDateEnd,
        'outDateBegin': outDateBegin,
        'outDateEnd': outDateEnd,
        'carNumb': carNumb,
        'idCard': idCard,
        'type': type,
      })
      ..removeWhere((key, value) => value == null || value == '');

    return _httpService.post<PaginatedResult<VehicleAccessRecordModel>>(
      '/api/closed-off/accessRecord/page',
      data: payload,
      parser: (json) => parsePaginatedResult(
        json: json,
        requestPageIndex: pageIndex,
        requestPageSize: pageSize,
        itemParser: (item) => VehicleAccessRecordModel.fromJson(item),
      ),
    );
  }

  /// 详情-违规记录分页。
  Future<Result<PaginatedResult<VehicleViolationRecordModel>>> getViolationRecordPage({
    required int pageIndex,
    required int pageSize,
    String? keyword,
    String? warningStartTimeBegin,
    String? warningStartTimeEnd,
    String? carNum,
  }) {
    final payload = buildPagePayload(pageIndex: pageIndex, pageSize: pageSize)
      ..addAll({'keyword': keyword, 'warningStartTimeBegin': warningStartTimeBegin, 'warningStartTimeEnd': warningStartTimeEnd, 'carNum': carNum})
      ..removeWhere((key, value) => value == null || value == '');

    return _httpService.post<PaginatedResult<VehicleViolationRecordModel>>(
      '/api/risk-warning/riskWarning/page',
      data: payload,
      parser: (json) => parsePaginatedResult(
        json: json,
        requestPageIndex: pageIndex,
        requestPageSize: pageSize,
        itemParser: (item) => VehicleViolationRecordModel.fromJson(item),
      ),
    );
  }

  /// 详情-拉黑记录分页。
  Future<Result<PaginatedResult<VehicleBlackRecordModel>>> getBlackRecordPage({
    required int pageIndex,
    required int pageSize,
    String? keyword,
    String? carNumb,
    String? realName,
    Object? type,
  }) {
    final payload = buildPagePayload(pageIndex: pageIndex, pageSize: pageSize)
      ..addAll({'keyword': keyword, 'carNumb': carNumb, 'realName': realName, 'type': type})
      ..removeWhere((key, value) => value == null || value == '');

    return _httpService.post<PaginatedResult<VehicleBlackRecordModel>>(
      '/api/closed-off/blackBook/page',
      data: payload,
      parser: (json) => parsePaginatedResult(
        json: json,
        requestPageIndex: pageIndex,
        requestPageSize: pageSize,
        itemParser: (item) => VehicleBlackRecordModel.fromJson(item),
      ),
    );
  }
}
