import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/utils/user_manager.dart';
import 'app_routes.dart';

/// [功能]: 路由登录态校验中间件。
/// [说明]:
///   - 需要登录的页面：未登录重定向到登录页。
///   - 不需要登录的页面：放行。
class AuthMiddleware extends GetMiddleware {
  AuthMiddleware({this.isLoginRequired = true});

  /// 当前路由是否要求登录。
  final bool isLoginRequired;

  @override
  /// 根据登录态决定是否重定向。
  RouteSettings? redirect(String? route) {
    if (!isLoginRequired) return null;
    return UserManager.isLogin ? null : const RouteSettings(name: Routes.authLogin);
  }
}
