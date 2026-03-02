import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

/// 首页视图，展示脚手架入口信息。
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  /// 构建首页基础布局。
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
        actions: [
          TextButton(
            onPressed: controller.logout,
            child: const Text('退出登录'),
          ),
        ],
      ),
      body: Center(
        child: Obx(
          () => Text(
            controller.welcomeText.value,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}
