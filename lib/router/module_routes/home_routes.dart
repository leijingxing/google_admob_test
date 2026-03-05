import 'package:get/get.dart';

import '../../modules/home/home_binding.dart';
import '../../modules/home/home_view.dart';

/// Home 模块路由定义。
abstract class HomeRoutes {
  HomeRoutes._();

  /// 跳转到首页并清空栈。
  static Future<T?>? offAll<T>() {
    return Get.offAll<T>(() => const HomeView(), binding: HomeBinding());
  }

  /// 跳转到首页（保留返回栈）。
  static Future<T?>? to<T>() {
    return Get.to<T>(() => const HomeView(), binding: HomeBinding());
  }
}
