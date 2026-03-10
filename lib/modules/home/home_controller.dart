import 'package:get/get.dart';

import '../profile/version_info/pgyer_update_service.dart';

/// 首页控制器：管理底部 tab 状态。
class HomeController extends GetxController {
  int currentIndex = 0;
  late final PgyerUpdateService _pgyerUpdateService;
  bool _hasCheckedUpdate = false;

  @override
  void onInit() {
    super.onInit();
    _pgyerUpdateService = PgyerUpdateService();
  }

  @override
  void onReady() {
    super.onReady();
    _checkUpdateIfNeeded();
  }

  /// 切换底部 tab。
  void switchTab(int index) {
    if (currentIndex == index) return;
    currentIndex = index;
    update();
  }

  Future<void> _checkUpdateIfNeeded() async {
    if (_hasCheckedUpdate) return;
    _hasCheckedUpdate = true;
    await _pgyerUpdateService.checkAndUpdate(showToastWhenLatest: false);
  }
}
