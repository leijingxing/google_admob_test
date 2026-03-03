import 'package:get/get.dart';

/// 首页控制器：管理底部 tab 状态。
class HomeController extends GetxController {
  int currentIndex = 0;

  /// 切换底部 tab。
  void switchTab(int index) {
    if (currentIndex == index) return;
    currentIndex = index;
    update();
  }
}
