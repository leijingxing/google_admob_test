import 'http_paginated_result.dart';

/// 通用分页请求参数构建：
/// 同时兼容不同后端常见字段命名。
Map<String, dynamic> buildPagePayload({
  required int pageIndex,
  required int pageSize,
}) {
  return {
    'current': pageIndex,
    'size': pageSize,
    'pageNum': pageIndex,
    'pageIndex': pageIndex,
    'pageSize': pageSize,
  };
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
    final records = _normalizeRecords(json);
    final items = records.map((item) => itemParser(_toMap(item))).toList();
    return PaginatedResult<T>(
      items: items,
      total: items.length,
      currentPage: requestPageIndex,
      pageSize: requestPageSize,
      pageCount: requestPageIndex + (items.length < requestPageSize ? 0 : 1),
    );
  }

  final map = _toMap(json);
  final records = _normalizeRecords(
    map['records'] ??
        map['list'] ??
        map['rows'] ??
        map['data'] ??
        const <dynamic>[],
  );
  final items = records.map((item) => itemParser(_toMap(item))).toList();

  final current = _toInt(
    map['current'] ?? map['pageIndex'] ?? map['pageNum'] ?? map['pageNo'],
    requestPageIndex,
  );
  final size = _toInt(map['size'] ?? map['pageSize'], requestPageSize);
  final total = _toInt(map['total'] ?? map['totalCount'], items.length);
  final pages = _toInt(
    map['pages'] ?? map['totalPages'] ?? map['pageCount'],
    current + (items.length < size ? 0 : 1),
  );

  return PaginatedResult<T>(
    items: items,
    total: total,
    currentPage: current,
    pageSize: size,
    pageCount: pages,
  );
}

List<dynamic> _normalizeRecords(dynamic raw) {
  if (raw is! List) return const <dynamic>[];
  if (raw.isNotEmpty && raw.every((e) => e is List)) {
    return raw.expand<dynamic>((e) => e as List).toList();
  }
  return raw;
}

Map<String, dynamic> _toMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  throw StateError('分页解析失败，期望 Map 结构，实际是 ${value.runtimeType}');
}

int _toInt(Object? value, int fallback) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}
