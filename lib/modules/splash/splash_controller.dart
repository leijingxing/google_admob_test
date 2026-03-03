import 'package:get/get.dart';

import '../../core/utils/user_manager.dart';
import '../../router/module_routes/auth_routes.dart';
import '../../router/module_routes/home_routes.dart';

/// 启动页控制器：短暂停留后按登录态跳转。
class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    // Global.init 已在 main_* 入口中 await 完成，进入 Splash 时后端服务已就绪。
    final next = UserManager.isLogin
        ? HomeRouteNames.home
        : AuthRouteNames.authLogin;
    Get.offAllNamed(next);
  }
}
