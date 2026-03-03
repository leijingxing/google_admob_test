import 'package:flutter_base/core/http/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result.when', () {
    test('Success 分支应返回 success 回调结果', () {
      const Result<int> result = Success<int>(42);

      final text = result.when(
        success: (value) => 'ok:$value',
        failure: (error) => 'fail:${error.code}',
      );

      expect(text, 'ok:42');
    });

    test('Failure 分支应返回 failure 回调结果', () {
      final Result<int> result = Failure<int>(
        AppError(code: 401, message: 'unauthorized'),
      );

      final text = result.when(
        success: (value) => 'ok:$value',
        failure: (error) => 'fail:${error.code}:${error.message}',
      );

      expect(text, 'fail:401:unauthorized');
    });
  });
}
