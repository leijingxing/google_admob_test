import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'module_routes/splash_routes.dart';

/// 路由入口（非命名路由）。
class AppPages {
  AppPages._();

  /// 应用首页。
  static Widget buildHome() => SplashRoutes.buildPage();

  /// 应用首页依赖。
  static Bindings buildInitialBinding() => SplashRoutes.buildBinding();
}
