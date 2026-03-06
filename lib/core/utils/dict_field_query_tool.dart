import '../components/log_util.dart';
import '../http/http_service.dart';

/// 字典字段项。
class DictFieldItem {
  final String itemValue;
  final String label;
  final String category;
  final String dictType;

  const DictFieldItem({required this.itemValue, required this.label, required this.category, required this.dictType});

  factory DictFieldItem.fromJson(Map<String, dynamic> json) {
    return DictFieldItem(
      itemValue: '${json['itemValue'] ?? ''}'.trim(),
      label: '${json['label'] ?? ''}'.trim(),
      category: '${json['category'] ?? ''}'.trim(),
      dictType: '${json['dictType'] ?? ''}'.trim(),
    );
  }
}

/// 公共字段查询工具：
/// 通过 system/dictItem/list 接口拉取字典项并提供统一查询能力。
class DictFieldQueryTool {
  DictFieldQueryTool._();

  static final HttpService _httpService = HttpService();

  /// 综合查询类型：车辆查询/人员查询/物流查询。
  static const String integratedQuery = 'closed-off-mgt_integrated_query';

  /// 装载类型字典。
  static const String loadType = 'closed-off-mgt_load_type';

  /// 车辆类型字典。
  static const String carType = 'closedoff_car_type';

  /// 车牌颜色字典。
  static const String carNumbColour = 'closed_off_mgt_car_numb_colour';

  /// 有效状态字典。
  static const String validityStatus = 'closed-off-mgt_validity_status';

  /// 危险品类型字典。
  static const String hazardousType = 'closed-off-mgt_hazardous_type';

  static final Map<String, List<DictFieldItem>> _dictItemsByType = <String, List<DictFieldItem>>{};

  /// 获取指定字典类型下的全部项。
  static List<DictFieldItem> items(String dictType) {
    return _dictItemsByType[dictType] ?? const <DictFieldItem>[];
  }

  /// 按需加载指定字典类型。
  static Future<bool> ensureLoaded({required List<String> dictTypes}) async {
    final normalizedTypes = dictTypes.map((e) => e.trim()).where((e) => e.isNotEmpty).toSet().toList()..sort();
    if (normalizedTypes.isEmpty) return true;

    // 每次 ensureLoaded 都重新请求，不复用已有缓存。
    for (final type in normalizedTypes) {
      _dictItemsByType.remove(type);
    }
    return _fetchAndCache(normalizedTypes);
  }

  /// 根据字典类型与字段值查询文案，查询不到时返回 [fallback]。
  static String labelOf(String dictType, Object? itemValue, {String fallback = '--'}) {
    final value = _normalize(itemValue);
    if (value.isEmpty) return fallback;
    for (final item in items(dictType)) {
      if (item.itemValue == value) {
        return item.label;
      }
    }
    return fallback;
  }

  /// 查询综合类型文案。
  static String integratedQueryLabel(Object? itemValue, {String fallback = '--'}) {
    return labelOf(integratedQuery, itemValue, fallback: fallback);
  }

  /// 查询装载类型文案。
  static String loadTypeLabel(Object? itemValue, {String fallback = '--'}) {
    return labelOf(loadType, itemValue, fallback: fallback);
  }

  /// 查询车辆类型文案。
  static String carTypeLabel(Object? itemValue, {String fallback = '--'}) {
    return labelOf(carType, itemValue, fallback: fallback);
  }

  /// 查询车牌颜色文案。
  static String carNumbColourLabel(Object? itemValue, {String fallback = '--'}) {
    return labelOf(carNumbColour, itemValue, fallback: fallback);
  }

  /// 查询有效状态文案。
  static String validityStatusLabel(Object? itemValue, {String fallback = '--'}) {
    return labelOf(validityStatus, itemValue, fallback: fallback);
  }

  /// 查询危化品类型文案。
  static String hazardousTypeLabel(Object? itemValue, {String fallback = '--'}) {
    return labelOf(hazardousType, itemValue, fallback: fallback);
  }

  /// 根据字典类型与文案查询字段值，查询不到返回 null。
  static String? valueOfLabel(String dictType, String? label) {
    final target = (label ?? '').trim();
    if (target.isEmpty) return null;
    for (final item in items(dictType)) {
      if (item.label == target) {
        return item.itemValue;
      }
    }
    return null;
  }

  /// 将字典类型转成 int -> label 结构，便于旧代码平滑接入。
  static Map<int, String> intLabelMap(String dictType) {
    final map = <int, String>{};
    for (final item in items(dictType)) {
      final value = int.tryParse(item.itemValue);
      if (value == null) continue;
      map[value] = item.label;
    }
    return map;
  }

  static String _normalize(Object? value) {
    if (value == null) return '';
    return value.toString().trim();
  }

  static Future<bool> _fetchAndCache(List<String> dictTypes) async {
    final result = await _httpService.get<Map<String, List<DictFieldItem>>>('/api/system/dictItem/list', queryParameters: {'dictType': dictTypes.join(',')}, parser: _parseDictItems);

    return result.when(
      success: (data) {
        for (final type in dictTypes) {
          _dictItemsByType[type] = data[type] ?? const <DictFieldItem>[];
        }
        return true;
      },
      failure: (error) {
        AppLog.warning(
          '字典接口加载失败: /api/system/dictItem/list, '
          'dictType=${dictTypes.join(",")}, msg=${error.message}',
        );
        return false;
      },
    );
  }

  static Map<String, List<DictFieldItem>> _parseDictItems(dynamic json) {
    if (json is! Map) return const <String, List<DictFieldItem>>{};
    final parsed = <String, List<DictFieldItem>>{};
    final source = Map<String, dynamic>.from(json);
    for (final entry in source.entries) {
      final dictType = entry.key.trim();
      if (dictType.isEmpty) continue;
      final rawList = entry.value;
      if (rawList is! List) {
        parsed[dictType] = const <DictFieldItem>[];
        continue;
      }
      parsed[dictType] = rawList.whereType<Map>().map((item) => DictFieldItem.fromJson(Map<String, dynamic>.from(item))).toList();
    }
    return parsed;
  }
}
