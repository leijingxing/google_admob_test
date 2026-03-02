import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

/// 登录页视图。
class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  /// 构建账号密码登录表单。
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('登录')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GetBuilder<AuthController>(
            builder: (logic) {
              return Column(
                children: [
                  TextField(
                    controller: logic.usernameController,
                    decoration: const InputDecoration(
                      labelText: '用户名',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: logic.passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: '密码',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: logic.isLoading ? null : logic.onLogin,
                      child: Text(logic.isLoading ? '登录中...' : '登录'),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
