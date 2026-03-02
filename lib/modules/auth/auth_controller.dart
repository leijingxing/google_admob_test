import 'package:flutter/material.dart';
import 'package:flutter_base/core/components/toast/toast_widget.dart';
import 'package:get/get.dart';

import '../../core/utils/user_manager.dart';
import '../../data/repository/auth_repository.dart';
import '../../router/app_routes.dart';

/// 登录页控制器，负责表单校验与登录流程。
class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// 用户名输入控制器。
  final TextEditingController usernameController = TextEditingController();

  /// 密码输入控制器。
  final TextEditingController passwordController = TextEditingController();

  /// 是否正在提交登录。
  bool isLoading = false;

  /// 密码是否可见。
  bool passwordVisible = false;

  bool _isDisposed = false;

  @override
  void onInit() {
    super.onInit();
    // [CONSTRAINT]: 作为脚手架默认演示账号，便于快速联调。
    usernameController.text = 'jwhxadmin';
    passwordController.text = 'jwhxadmin';
  }

  /// 切换密码显示状态。
  void togglePasswordVisible() {
    passwordVisible = !passwordVisible;
    update();
  }

  /// 用户名校验。
  String? validateUsername(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return '请输入用户名';
    if (text.length < 2) return '用户名长度至少 2 位';
    return null;
  }

  /// 密码校验。
  String? validatePassword(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return '请输入密码';
    if (text.length < 6) return '密码长度至少 6 位';
    return null;
  }

  /// 提交登录，成功后进入首页。
  Future<void> onLogin() async {
    if (isLoading || _isDisposed) return;
    if (!(formKey.currentState?.validate() ?? false)) {
      AppToast.showWarning('请先填写完整的登录信息');
      return;
    }

    final startAt = DateTime.now();
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    isLoading = true;
    _safeUpdate();

    try {
      final result = await _authRepository.login(
        username: username,
        password: password,
      );

      final elapsed = DateTime.now().difference(startAt).inMilliseconds;
      if (elapsed < 420) {
        await Future<void>.delayed(Duration(milliseconds: 420 - elapsed));
      }

      if (_isDisposed || isClosed) return;

      await result.when(
        success: (loginResult) async {
          if (_isDisposed || isClosed) return;
          if (loginResult.accessToken.isEmpty) {
            AppToast.showWarning('登录失败，请稍后重试');
            return;
          }
          final token = loginResult.tokenType.isEmpty
              ? loginResult.accessToken
              : '${loginResult.tokenType} ${loginResult.accessToken}';
          await UserManager.saveToken(token);
          if (!_isDisposed && !isClosed && Get.currentRoute != Routes.home) {
            await Get.offAllNamed(Routes.home);
          }
        },
        failure: (error) async {
          if (!_isDisposed && !isClosed) {
            AppToast.showError(error.message);
          }
        },
      );
    } catch (_) {
      if (!_isDisposed && !isClosed) {
        AppToast.showError('登录异常，请稍后重试');
      }
    } finally {
      if (!_isDisposed && !isClosed) {
        isLoading = false;
        update();
      }
    }
  }

  @override
  void onClose() {
    _isDisposed = true;
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void _safeUpdate() {
    if (_isDisposed || isClosed) return;
    update();
  }
}
