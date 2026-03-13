import '../../core/http/http_service.dart';
import '../../core/http/result.dart';
import '../models/overview/overview_models.dart';

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
}
