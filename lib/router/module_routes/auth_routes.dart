import 'package:get/get.dart';

import '../../modules/auth/auth_binding.dart';
import '../../modules/auth/auth_view.dart';

/// Auth 模块路由定义。
abstract class AuthRoutes {
  AuthRoutes._();

  /// 跳转到登录页并清空栈。
  static Future<T?>? offAll<T>() {
    return Get.offAll<T>(() => const AuthView(), binding: AuthBinding());
  }

  /// 跳转到登录页（保留返回栈）。
  static Future<T?>? to<T>() {
    return Get.to<T>(() => const AuthView(), binding: AuthBinding());
  }
}
