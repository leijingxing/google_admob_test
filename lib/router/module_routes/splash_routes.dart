import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../modules/splash/splash_binding.dart';
import '../../modules/splash/splash_view.dart';

/// Splash 模块路由定义（集中维护于 router 目录）。
abstract class SplashRoutes {
  SplashRoutes._();

  /// 启动页视图。
  static Widget buildPage() => const SplashView();

  /// 启动页依赖。
  static Bindings buildBinding() => SplashBinding();

  /// 跳转到启动页并清空栈。
  static Future<T?>? offAll<T>() {
    return Get.offAll<T>(() => const SplashView(), binding: SplashBinding());
  }
}
