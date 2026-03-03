import 'package:get/get.dart';

import '../../core/utils/user_manager.dart';
import '../../router/app_routes.dart';

/// 启动页控制器：短暂停留后按登录态跳转。
class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    // Global.init 已在 main_* 入口中 await 完成，进入 Splash 时后端服务已就绪。
    final next = UserManager.isLogin ? Routes.home : Routes.authLogin;
    Get.offAllNamed(next);
  }
}
