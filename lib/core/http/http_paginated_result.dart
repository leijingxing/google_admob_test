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
  /// [json] 是包含分页信息的 Map，例如：`{"records": [...], "total": 100, "current": 1, "size": 10, "pages": 10}`
  /// [itemParser] 是一个函数，用于将列表中的单个 item (Map) 转换为模型对象 `T`
  factory PaginatedResult.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic itemJson) itemParser,
  ) {
    final itemsList = json['records'] as List? ?? [];
    final parsedItems = itemsList.map((item) => itemParser(item)).toList();

    return PaginatedResult<T>(
      items: parsedItems,
      total: json['total'] as int? ?? 0,
      currentPage: json['current'] as int? ?? 1,
      pageSize: json['size'] as int? ?? 10,
      pageCount: json['pages'] as int? ?? 0,
    );
  }

  /// 判断 map 是否为分页结构，根据接口响应结构来调整
  static bool isPaginationStructure(Map<dynamic, dynamic> data) {
    final bool isPagination =
        data.containsKey('records') && data.containsKey('total');
    return isPagination;
  }
}
