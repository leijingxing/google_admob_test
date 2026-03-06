import '../../core/http/http_service.dart';
import '../../core/http/paginated_parser.dart';
import '../../core/http/result.dart';
import '../models/personnel_query/personnel_query_models.dart';

/// 人员综合查询仓库。
class PersonnelQueryRepository {
  final HttpService _httpService = HttpService();

  /// 顶部统计。
  Future<Result<PersonnelCountModel>> getPersonnelCount() {
    return _httpService.get<PersonnelCountModel>(
      '/api/closed-off/comprehensive/selPersonnelCount',
      queryParameters: const <String, dynamic>{},
      parser: (json) =>
          PersonnelCountModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  /// 主列表分页。
  Future<Result<PaginatedResult<PersonnelComprehensiveItemModel>>>
  getPersonnelComprehensivePage({
    required int pageIndex,
    required int pageSize,
    String? keyWords,
    String? startTime,
    String? endTime,
  }) {
    final payload = buildPagePayload(pageIndex: pageIndex, pageSize: pageSize)
      ..addAll({
        'keyWords': keyWords,
        'startTime': startTime,
        'endTime': endTime,
      })
      ..removeWhere((key, value) => value == null || value == '');

    return _httpService.post<PaginatedResult<PersonnelComprehensiveItemModel>>(
      '/api/closed-off/comprehensive/selPersonnelPage',
      data: payload,
      parser: (json) => parsePaginatedResult(
        json: json,
        requestPageIndex: pageIndex,
        requestPageSize: pageSize,
        itemParser: (item) => PersonnelComprehensiveItemModel.fromJson(item),
      ),
    );
  }
}
