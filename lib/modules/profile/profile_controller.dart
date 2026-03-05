import 'package:get/get.dart';

import '../../data/models/auth/login_entity.dart';
import '../../../core/utils/user_manager.dart';

/// 个人页控制器。
class ProfileController extends GetxController {
  Worker? _profileWorker;

  /// 当前登录用户信息。
  LoginEntity? get profile => UserManager.user;

  @override
  void onInit() {
    super.onInit();
    _profileWorker = ever<LoginEntity?>(
      UserManager.userProfileStream,
      (_) => update(),
    );
  }

  @override
  void onClose() {
    _profileWorker?.dispose();
    super.onClose();
  }

  /// 退出登录。
  Future<void> logout() async {
    await UserManager.logout();
  }
}
