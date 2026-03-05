import 'package:closed_off_app/modules/auth/auth_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthController 基础状态', () {
    late AuthController controller;

    setUp(() {
      controller = AuthController();
    });

    tearDown(() {
      controller.onClose();
    });

    test('onInit 默认不显示密码', () {
      expect(controller.passwordObscure.value, isTrue);
    });

    test('togglePasswordVisible 可切换密码显示状态', () {
      controller.togglePasswordVisible();
      expect(controller.passwordObscure.value, isFalse);
      controller.togglePasswordVisible();
      expect(controller.passwordObscure.value, isTrue);
    });

    test('isPopPage 在未记录时间时返回 false', () {
      expect(controller.isPopPage(), isFalse);
    });
  });
}
