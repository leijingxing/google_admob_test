import '../../core/http/http_service.dart';
import '../../core/http/result.dart';
import '../models/vehicle_query/vehicle_query_models.dart';

/// 车辆综合查询仓库。
class VehicleQueryRepository {
  final HttpService _httpService = HttpService();

  /// 顶部统计：按车辆分类汇总。
  Future<Result<List<VehicleCategoryCountModel>>> getVehicleCount() {
    return _httpService.post<List<VehicleCategoryCountModel>>(
      '/closed-off/comprehensive/getVehicleCount',
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
    final payload = _buildPagePayload(pageIndex: pageIndex, pageSize: pageSize)
      ..addAll({'keyword': keyword, 'carCategory': carCategory, 'startTime': startTime, 'endTime': endTime})
      ..removeWhere((key, value) => value == null || value == '');
    return _httpService.post<PaginatedResult<VehicleComprehensiveItemModel>>(
      '/api/closed-off/comprehensive/getVehicleComprehensivePage',
      data: payload,
      parser: (json) => _parsePage(json, (item) => VehicleComprehensiveItemModel.fromJson(item)),
    );
  }

  /// 详情抽屉顶部统计。
  Future<Result<ComprehensiveDetailCountModel>> getComprehensiveDetailCount({required String carNumb, String? idCard}) {
    return _httpService.post<ComprehensiveDetailCountModel>(
      '/closed-off/comprehensive/getComprehensiveDetailCount',
      data: {'carNumb': carNumb, 'idCard': idCard}..removeWhere((key, value) => value == null || value == ''),
      parser: (json) => ComprehensiveDetailCountModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  /// 拉黑。
  Future<Result<void>> addBlackRecord({required String carNumb, required int carCategory, required String parkCheckDesc, required String validityBeginTime, required String validityEndTime}) async {
    final result = await _httpService.post<dynamic>(
      '/closed-off/black',
      data: {
        'dto': {'carNumb': carNumb, 'carCategory': carCategory, 'parkCheckDesc': parkCheckDesc, 'validityBeginTime': validityBeginTime, 'validityEndTime': validityEndTime, 'type': 2},
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
    final payload = _buildPagePayload(pageIndex: pageIndex, pageSize: pageSize)
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
      '/closed-off/comprehensive/getAuthorizationRecord',
      data: payload,
      parser: (json) => _parsePage(json, (item) => VehicleAuthorizationRecordModel.fromJson(item)),
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
    final payload = _buildPagePayload(pageIndex: pageIndex, pageSize: pageSize)
      ..addAll({'keyWords': keyWords, 'inDateBegin': inDateBegin, 'inDateEnd': inDateEnd, 'outDateBegin': outDateBegin, 'outDateEnd': outDateEnd, 'carNumb': carNumb, 'idCard': idCard, 'type': type})
      ..removeWhere((key, value) => value == null || value == '');

    return _httpService.post<PaginatedResult<VehicleAccessRecordModel>>(
      '/closed-off/accessRecord/page',
      data: payload,
      parser: (json) => _parsePage(json, (item) => VehicleAccessRecordModel.fromJson(item)),
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
    final payload = _buildPagePayload(pageIndex: pageIndex, pageSize: pageSize)
      ..addAll({'keyword': keyword, 'warningStartTimeBegin': warningStartTimeBegin, 'warningStartTimeEnd': warningStartTimeEnd, 'carNum': carNum})
      ..removeWhere((key, value) => value == null || value == '');

    return _httpService.post<PaginatedResult<VehicleViolationRecordModel>>(
      '/risk-warning/riskWarning/page',
      data: payload,
      parser: (json) => _parsePage(json, (item) => VehicleViolationRecordModel.fromJson(item)),
    );
  }

  /// 详情-拉黑记录分页。
  Future<Result<PaginatedResult<VehicleBlackRecordModel>>> getBlackRecordPage({required int pageIndex, required int pageSize, String? keyword, String? carNumb, String? realName, Object? type}) {
    final payload = _buildPagePayload(pageIndex: pageIndex, pageSize: pageSize)
      ..addAll({'keyword': keyword, 'carNumb': carNumb, 'realName': realName, 'type': type})
      ..removeWhere((key, value) => value == null || value == '');

    return _httpService.post<PaginatedResult<VehicleBlackRecordModel>>(
      '/closed-off/blackBook/page',
      data: payload,
      parser: (json) => _parsePage(json, (item) => VehicleBlackRecordModel.fromJson(item)),
    );
  }

  Map<String, dynamic> _buildPagePayload({required int pageIndex, required int pageSize}) {
    return {'current': pageIndex, 'size': pageSize, 'pageNum': pageIndex, 'pageNo': pageIndex, 'pageSize': pageSize};
  }

  PaginatedResult<T> _parsePage<T>(dynamic json, T Function(Map<String, dynamic> item) itemParser) {
    final map = Map<String, dynamic>.from(json as Map);

    if (!PaginatedResult.isPaginationStructure(map)) {
      final records = (map['list'] ?? map['rows'] ?? <dynamic>[]) as List<dynamic>;
      final current = _toInt(map['current'] ?? map['pageNum'] ?? map['pageNo'], 1);
      final size = _toInt(map['size'] ?? map['pageSize'], 10);
      final total = _toInt(map['total'], records.length);
      final pages = _toInt(map['pages'] ?? map['pageCount'], 1);
      return PaginatedResult<T>(items: records.map((item) => itemParser(Map<String, dynamic>.from(item as Map))).toList(), total: total, currentPage: current, pageSize: size, pageCount: pages);
    }

    return PaginatedResult<T>.fromJson(map, (itemJson) => itemParser(Map<String, dynamic>.from(itemJson as Map)));
  }

  int _toInt(Object? value, int fallback) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }
}
