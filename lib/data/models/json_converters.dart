import 'dart:convert';

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

/// double 容错转换：支持 double/int/num/string/null，失败默认 0。
class DoubleSafeConverter implements JsonConverter<double, Object?> {
  const DoubleSafeConverter();

  @override
  double fromJson(Object? json) {
    if (json is double) return json;
    if (json is int) return json.toDouble();
    if (json is num) return json.toDouble();
    if (json is String) return double.tryParse(json) ?? 0;
    return 0;
  }

  @override
  Object? toJson(double object) => object;
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
class NullableStringSafeConverter implements JsonConverter<String?, Object?> {
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

/// 可空字符串列表容错转换：
/// - null/空字符串 -> null
/// - List -> 过滤后转为 `List<String>`
/// - 逗号字符串或 JSON 数组字符串 -> `List<String>`
class NullableStringListSafeConverter
    implements JsonConverter<List<String>?, Object?> {
  const NullableStringListSafeConverter();

  @override
  List<String>? fromJson(Object? json) {
    if (json == null) return null;
    if (json is List) {
      final values = json
          .map((e) => e?.toString().trim() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
      return values.isEmpty ? null : values;
    }
    if (json is String) {
      final text = json.trim();
      if (text.isEmpty) return null;
      if (text.startsWith('[') && text.endsWith(']')) {
        try {
          final decoded = jsonDecode(text);
          if (decoded is List) {
            final values = decoded
                .map((e) => e?.toString().trim() ?? '')
                .where((e) => e.isNotEmpty)
                .toList();
            return values.isEmpty ? null : values;
          }
        } catch (_) {
          // ignore
        }
      }
      if (text.contains(',')) {
        final values = text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
        return values.isEmpty ? null : values;
      }
      return <String>[text];
    }
    final value = json.toString().trim();
    if (value.isEmpty) return null;
    return <String>[value];
  }

  @override
  Object? toJson(List<String>? object) => object;
}
