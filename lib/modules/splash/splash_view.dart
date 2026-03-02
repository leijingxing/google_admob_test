import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'splash_controller.dart';

/// 启动页视图。
class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  /// 展示简单加载态，具体跳转由控制器处理。
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
