import 'package:get/get.dart';

import '../modules/auth/auth_binding.dart';
import '../modules/auth/auth_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/splash/splash_binding.dart';
import '../modules/splash/splash_view.dart';
import 'app_auth_middleware.dart';
import 'app_routes.dart';

/// 路由注册中心，维护初始路由与页面绑定关系。
class AppPages {
  AppPages._();

  /// 应用初始路由。
  static const initial = Routes.splash;

  /// 所有页面定义。
  static final routes = <GetPage<dynamic>>[
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.authLogin,
      page: () => const AuthView(),
      binding: AuthBinding(),
      middlewares: [AuthMiddleware(isLoginRequired: false)],
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
