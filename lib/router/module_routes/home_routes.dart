import 'package:get/get.dart';

import '../../modules/home/home_binding.dart';
import '../../modules/home/home_view.dart';
import '../app_auth_middleware.dart';

/// Home 模块路由名。
abstract class HomeRouteNames {
  HomeRouteNames._();

  static const home = '/home';
}

/// Home 模块路由定义。
abstract class HomeRoutes {
  HomeRoutes._();

  static final routes = <GetPage<dynamic>>[
    GetPage(
      name: HomeRouteNames.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
