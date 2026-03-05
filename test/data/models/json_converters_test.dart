import 'package:closed_off_app/data/models/json_converters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('IntSafeConverter', () {
    const converter = IntSafeConverter();

    test('支持 int/num/string 输入', () {
      expect(converter.fromJson(12), 12);
      expect(converter.fromJson(12.9), 12);
      expect(converter.fromJson('34'), 34);
    });

    test('非法输入回退为 0', () {
      expect(converter.fromJson('abc'), 0);
      expect(converter.fromJson(null), 0);
    });
  });

  group('StringSafeConverter', () {
    const converter = StringSafeConverter();

    test('null 回退为空字符串', () {
      expect(converter.fromJson(null), '');
    });

    test('其他类型转字符串', () {
      expect(converter.fromJson(123), '123');
      expect(converter.fromJson(true), 'true');
    });
  });

  group('NullableStringSafeConverter', () {
    const converter = NullableStringSafeConverter();

    test('null 或空字符串回退为 null', () {
      expect(converter.fromJson(null), isNull);
      expect(converter.fromJson(''), isNull);
    });

    test('非空值转字符串', () {
      expect(converter.fromJson('token'), 'token');
      expect(converter.fromJson(99), '99');
    });
  });
}

