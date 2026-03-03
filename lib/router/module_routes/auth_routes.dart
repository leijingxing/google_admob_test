import 'package:get/get.dart';

import '../../modules/auth/auth_binding.dart';
import '../../modules/auth/auth_view.dart';
import '../app_auth_middleware.dart';

/// Auth 模块路由名。
abstract class AuthRouteNames {
  AuthRouteNames._();

  static const authLogin = '/auth/login';
}

/// Auth 模块路由定义。
abstract class AuthRoutes {
  AuthRoutes._();

  static final routes = <GetPage<dynamic>>[
    GetPage(
      name: AuthRouteNames.authLogin,
      page: () => const AuthView(),
      binding: AuthBinding(),
      middlewares: [AuthMiddleware(isLoginRequired: false)],
    ),
  ];
}
