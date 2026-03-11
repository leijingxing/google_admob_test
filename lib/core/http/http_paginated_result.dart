import 'package:meta/meta.dart';

/// 分页数据模型
@immutable
class PaginatedResult<T> {
  final List<T> items;
  final int total;

  /// 当前页码 (从1开始)
  final int currentPage;
  final int pageSize;

  /// 总页数
  final int pageCount;

  const PaginatedResult({
    required this.items,
    required this.total,
    required this.currentPage,
    required this.pageSize,
    required this.pageCount,
  });

  /// 是否有更多页面.
  /// 假设 currentPage 是 1-indexed.
  bool get hasMore => currentPage < pageCount;

  /// 从 JSON 和一个列表解析器函数创建实例
  /// [json] 是包含分页信息的 Map，例如：
  /// `{"data": [...], "totalCount": 100, "pageIndex": 1, "pageSize": 10, "totalPages": 10}`
  /// [itemParser] 是一个函数，用于将列表中的单个 item (Map) 转换为模型对象 `T`
  factory PaginatedResult.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic itemJson) itemParser,
  ) {
    final itemsList = json['data'] as List? ?? [];
    final parsedItems = itemsList.map((item) => itemParser(item)).toList();

    return PaginatedResult<T>(
      items: parsedItems,
      total: json['totalCount'] as int? ?? parsedItems.length,
      currentPage: json['pageIndex'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 10,
      pageCount: json['totalPages'] as int? ?? 0,
    );
  }
}
