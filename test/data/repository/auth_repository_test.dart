import 'package:flutter_base/core/http/result.dart';
import 'package:flutter_base/data/models/login_token_model.dart';
import 'package:flutter_base/data/repository/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthRepository.login', () {
    final repository = AuthRepository();

    test('用户名为空时返回 Failure', () async {
      final result = await repository.login(username: '', password: '123456');

      expect(result, isA<Failure<LoginTokenModel>>());
      result.when(
        success: (_) => fail('预期失败，但返回了成功'),
        failure: (error) {
          expect(error.code, -1);
          expect(error.message, '用户名或密码不能为空');
        },
      );
    });

    test('密码为空时返回 Failure', () async {
      final result = await repository.login(username: 'admin', password: '');

      expect(result, isA<Failure<LoginTokenModel>>());
      result.when(
        success: (_) => fail('预期失败，但返回了成功'),
        failure: (error) {
          expect(error.code, -1);
          expect(error.message, '用户名或密码不能为空');
        },
      );
    });
  });
}
