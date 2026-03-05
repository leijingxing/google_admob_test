import 'package:closed_off_app/modules/auth/auth_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthController 本地校验', () {
    late AuthController controller;

    setUp(() {
      controller = AuthController();
      controller.onInit();
    });

    tearDown(() {
      controller.onClose();
    });

    test('onInit 预置默认账号密码', () {
      expect(controller.usernameController.text, 'jwhxadmin');
      expect(controller.passwordController.text, 'jwhxadmin');
    });

    test('validateUsername 按规则校验', () {
      expect(controller.validateUsername(''), '请输入用户名');
      expect(controller.validateUsername('a'), '用户名长度至少 2 位');
      expect(controller.validateUsername('ab'), isNull);
    });

    test('validatePassword 按规则校验', () {
      expect(controller.validatePassword(''), '请输入密码');
      expect(controller.validatePassword('12345'), '密码长度至少 6 位');
      expect(controller.validatePassword('123456'), isNull);
    });
  });
}

