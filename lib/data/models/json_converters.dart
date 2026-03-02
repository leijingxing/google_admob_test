import 'package:json_annotation/json_annotation.dart';

/// int 容错转换：支持 int/num/string/null，失败默认 0。
class IntSafeConverter implements JsonConverter<int, Object?> {
  const IntSafeConverter();

  @override
  int fromJson(Object? json) {
    if (json is int) return json;
    if (json is num) return json.toInt();
    if (json is String) return int.tryParse(json) ?? 0;
    return 0;
  }

  @override
  Object? toJson(int object) => object;
}

/// String 容错转换：null -> ''，其他类型转字符串。
class StringSafeConverter implements JsonConverter<String, Object?> {
  const StringSafeConverter();

  @override
  String fromJson(Object? json) => json?.toString() ?? '';

  @override
  Object? toJson(String object) => object;
}

/// 可空 String 容错转换：null 或空字符串 -> null。
class NullableStringSafeConverter
    implements JsonConverter<String?, Object?> {
  const NullableStringSafeConverter();

  @override
  String? fromJson(Object? json) {
    if (json == null) return null;
    final text = json.toString();
    return text.isEmpty ? null : text;
  }

  @override
  Object? toJson(String? object) => object;
}
