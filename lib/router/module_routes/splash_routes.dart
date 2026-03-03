import 'package:get/get.dart';

import '../../modules/splash/splash_binding.dart';
import '../../modules/splash/splash_view.dart';

/// Splash 模块路由名。
abstract class SplashRouteNames {
  SplashRouteNames._();

  static const splash = '/splash';
}

/// Splash 模块路由定义（集中维护于 router 目录）。
abstract class SplashRoutes {
  SplashRoutes._();

  static final routes = <GetPage<dynamic>>[
    GetPage(
      name: SplashRouteNames.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
  ];
}
