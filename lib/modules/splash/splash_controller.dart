import 'package:get/get.dart';

import '../../core/utils/user_manager.dart';
import '../../router/app_routes.dart';

/// 启动页控制器：短暂停留后按登录态跳转。
class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    Future<void>.delayed(const Duration(milliseconds: 100), () {
      final next = UserManager.isLogin ? Routes.home : Routes.authLogin;
      Get.offAllNamed(next);
    });
  }
}
