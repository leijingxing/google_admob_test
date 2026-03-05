import 'package:get/get.dart';

import 'module_routes/auth_routes.dart';
import 'module_routes/home_routes.dart';
import 'module_routes/splash_routes.dart';

/// 路由注册中心，维护初始路由与页面绑定关系。
class AppPages {
  AppPages._();

  /// 应用初始路由。
  static const initial = SplashRouteNames.splash;

  /// 所有页面定义。
  static final routes  = <GetPage<dynamic>>[
    ...SplashRoutes.routes,
    ...AuthRoutes.routes,
    ...HomeRoutes.routes,
  ];
}
