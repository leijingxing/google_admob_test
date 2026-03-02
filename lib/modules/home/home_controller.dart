import 'package:get/get.dart';

import '../../core/utils/user_manager.dart';
import '../../router/app_routes.dart';

/// 首页控制器，演示基础状态与登出行为。
class HomeController extends GetxController {
  /// 欢迎语。
  final welcomeText = 'Flutter 基础脚手架已就绪'.obs;

  /// 退出登录并返回登录页。
  Future<void> logout() async {
    await UserManager.logout();
    await Get.offAllNamed(Routes.authLogin);
  }
}
