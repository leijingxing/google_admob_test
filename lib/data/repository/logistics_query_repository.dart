import '../../core/http/http_service.dart';
import '../../core/http/paginated_parser.dart';
import '../../core/http/result.dart';
import '../models/logistics_query/logistics_query_models.dart';

/// 物流综合查询仓库。
class LogisticsQueryRepository {
  final HttpService _httpService = HttpService();

  /// 主列表分页。
  Future<Result<PaginatedResult<LogisticsComprehensiveItemModel>>>
  getLogisticsPage({
    required int pageIndex,
    required int pageSize,
    String? keyWords,
    String? strDate,
    String? endDate,
    int? goodsType,
  }) {
    final payload = buildPagePayload(pageIndex: pageIndex, pageSize: pageSize)
      ..addAll({
        'keyWords': keyWords,
        'strDate': strDate,
        'endDate': endDate,
        'goodsType': goodsType,
      })
      ..removeWhere((key, value) => value == null || value == '');

    return _httpService.post<PaginatedResult<LogisticsComprehensiveItemModel>>(
      '/api/closed-off/comprehensive/sleLogisticsPage',
      data: payload,
      parser: (json) => parsePaginatedResult(
        json: json,
        requestPageIndex: pageIndex,
        requestPageSize: pageSize,
        itemParser: (item) => LogisticsComprehensiveItemModel.fromJson(item),
      ),
    );
  }

  /// 顶部统计。
  Future<Result<List<LogisticsStatisticsItemModel>>> getLogisticsStatistics() {
    return _httpService.get<List<LogisticsStatisticsItemModel>>(
      '/api/closed-off/comprehensive/sleLogisticsStatistics',
      queryParameters: const <String, dynamic>{},
      parser: (json) {
        if (json is! List) return const <LogisticsStatisticsItemModel>[];
        return json
            .whereType<Map>()
            .map(
              (item) => LogisticsStatisticsItemModel.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList();
      },
    );
  }

  /// 详情顶部统计。
  Future<Result<LogisticsDetailCountModel>> getLogisticsDetailCount({
    required String cas,
  }) {
    return _httpService.get<LogisticsDetailCountModel>(
      '/api/closed-off/comprehensive/getLogisticsDetailCount',
      queryParameters: {'cas': cas},
      parser: (json) => LogisticsDetailCountModel.fromJson(
        Map<String, dynamic>.from(json as Map),
      ),
    );
  }

  /// 详情-授权记录分页。
  Future<Result<PaginatedResult<LogisticsAuthorizationRecordModel>>>
  getAuthorizationRecordPage({
    required int pageIndex,
    required int pageSize,
    required String cas,
    String? keyWords,
    String? strParkCheckTime,
    String? endParkCheckTime,
    String? strInDate,
    String? endInDate,
  }) {
    final payload = buildPagePayload(pageIndex: pageIndex, pageSize: pageSize)
      ..addAll({
        'cas': cas,
        'keyWords': keyWords,
        'strParkCheckTime': strParkCheckTime,
        'endParkCheckTime': endParkCheckTime,
        'strInDate': strInDate,
        'endInDate': endInDate,
      })
      ..removeWhere((key, value) => value == null || value == '');

    return _httpService
        .post<PaginatedResult<LogisticsAuthorizationRecordModel>>(
          '/api/closed-off/comprehensive/selLogisticsDetails',
          data: payload,
          parser: (json) => parsePaginatedResult(
            json: json,
            requestPageIndex: pageIndex,
            requestPageSize: pageSize,
            itemParser: (item) =>
                LogisticsAuthorizationRecordModel.fromJson(item),
          ),
        );
  }

  /// 详情-出入记录分页。
  Future<Result<PaginatedResult<LogisticsAccessRecordModel>>>
  getAccessRecordPage({
    required int pageIndex,
    required int pageSize,
    required String cas,
    String? keyWords,
    String? strInDate,
    String? endInDate,
    String? strOutDate,
    String? endOutDate,
  }) {
    final payload = buildPagePayload(pageIndex: pageIndex, pageSize: pageSize)
      ..addAll({
        'cas': cas,
        'keyWords': keyWords,
        'strInDate': strInDate,
        'endInDate': endInDate,
        'strOutDate': strOutDate,
        'endOutDate': endOutDate,
      })
      ..removeWhere((key, value) => value == null || value == '');

    return _httpService.post<PaginatedResult<LogisticsAccessRecordModel>>(
      '/api/closed-off/comprehensive/selInOrOutRecord',
      data: payload,
      parser: (json) => parsePaginatedResult(
        json: json,
        requestPageIndex: pageIndex,
        requestPageSize: pageSize,
        itemParser: (item) => LogisticsAccessRecordModel.fromJson(item),
      ),
    );
  }
}
