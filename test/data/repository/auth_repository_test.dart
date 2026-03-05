import 'package:closed_off_app/data/repository/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthRepository 参数校验', () {
    final repository = AuthRepository();

    test('getAccessToken 授权码为空时抛出异常', () async {
      await expectLater(
        repository.getAccessToken(''),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('授权码不能为空'),
          ),
        ),
      );
    });

    test('proxyLogin 关键参数为空时抛出异常', () async {
      await expectLater(
        repository.proxyLogin(
          state: '',
          authorizationUrl: '',
          captcha: '',
          username: '',
          password: '',
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('登录状态参数缺失'),
          ),
        ),
      );
    });
  });
}
