import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/user_manager.dart';
import '../../data/repository/auth_repository.dart';
import '../../router/app_routes.dart';

/// 登录页控制器，负责表单校验与登录流程。
class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  /// 用户名输入控制器。
  final TextEditingController usernameController = TextEditingController();

  /// 密码输入控制器。
  final TextEditingController passwordController = TextEditingController();

  /// 是否正在提交登录。
  bool isLoading = false;

  /// 提交登录，成功后进入首页。
  Future<void> onLogin() async {
    if (isLoading) return;

    isLoading = true;
    update();

    final result = await _authRepository.login(
      username: usernameController.text.trim(),
      password: passwordController.text.trim(),
    );

    isLoading = false;
    update();

    await result.when(
      success: (token) async {
        if (token.isEmpty) {
          Get.snackbar('提示', '登录失败');
          return;
        }
        await UserManager.saveToken(token);
        await Get.offAllNamed(Routes.home);
      },
      failure: (error) async {
        Get.snackbar('提示', error.message);
      },
    );
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
