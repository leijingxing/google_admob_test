import 'package:hive_flutter/hive_flutter.dart';

/// [功能]: 本地键值存储工具。
/// [说明]: 统一封装 Hive 的读写，避免业务层直接操作 Box。
class StorageUtil {
  StorageUtil._();

  static const _boxName = 'app_box';
  static late Box _box;

  /// 初始化存储容器。
  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  /// 读取布尔值。
  static bool? getBool(String key) => _box.get(key) as bool?;

  /// 写入布尔值。
  static Future<void> setBool(String key, bool value) => _box.put(key, value);

  /// 读取字符串。
  static String? getString(String key) => _box.get(key) as String?;

  /// 写入字符串。
  static Future<void> setString(String key, String value) => _box.put(key, value);

  /// 删除指定 key。
  static Future<void> remove(String key) => _box.delete(key);
}
