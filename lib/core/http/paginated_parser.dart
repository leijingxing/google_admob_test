import 'http_paginated_result.dart';

/// 通用分页请求参数构建：
/// 同时兼容不同后端常见字段命名。
Map<String, dynamic> buildPagePayload({required int pageIndex, required int pageSize}) {
  return {'current': pageIndex, 'size': pageSize, 'pageNum': pageIndex, 'pageIndex': pageIndex, 'pageSize': pageSize};
}

/// 通用分页解析器：
/// - 兼容 HttpService unwrap 后仅返回 data(List) 的场景
/// - 兼容直接返回分页 Map 的场景
PaginatedResult<T> parsePaginatedResult<T>({
  required dynamic json,
  required int requestPageIndex,
  required int requestPageSize,
  required T Function(Map<String, dynamic> item) itemParser,
}) {
  if (json is List) {
    final items = json.map((item) => itemParser(Map<String, dynamic>.from(item as Map))).toList();
    return PaginatedResult<T>(
      items: items,
      total: items.length,
      currentPage: requestPageIndex,
      pageSize: requestPageSize,
      pageCount: requestPageIndex + (items.length < requestPageSize ? 0 : 1),
    );
  }

  final map = Map<String, dynamic>.from(json as Map);
  final records = (map['records'] ?? map['list'] ?? map['rows'] ?? map['data'] ?? <dynamic>[]) as List<dynamic>;
  final items = records.map((item) => itemParser(Map<String, dynamic>.from(item as Map))).toList();

  final current = _toInt(map['current'] ?? map['pageIndex'] ?? map['pageNum'] ?? map['pageNo'], requestPageIndex);
  final size = _toInt(map['size'] ?? map['pageSize'], requestPageSize);
  final total = _toInt(map['total'] ?? map['totalCount'], items.length);
  final pages = _toInt(map['pages'] ?? map['totalPages'] ?? map['pageCount'], current + (items.length < size ? 0 : 1));

  return PaginatedResult<T>(items: items, total: total, currentPage: current, pageSize: size, pageCount: pages);
}

int _toInt(Object? value, int fallback) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}
