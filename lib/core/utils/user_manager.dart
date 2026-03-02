import 'package:get/get.dart';

import '../../router/app_routes.dart';
import '../constants/storage.dart';
import 'storage_util.dart';

/// [功能]: 管理用户登录态（token）和退出流程。
class UserManager {
  UserManager._();

  /// 当前 token，应用生命周期内缓存一份。
  static String? token;

  /// 启动时恢复本地登录态。
  static Future<void> init() async {
    token = StorageUtil.getString(StorageConstants.token);
  }

  /// 保存 token 到内存与本地存储。
  static Future<void> saveToken(String value) async {
    token = value;
    await StorageUtil.setString(StorageConstants.token, value);
  }

  /// 清理登录态并回到登录页。
  static Future<void> logout() async {
    token = null;
    await StorageUtil.remove(StorageConstants.token);
    if (Get.currentRoute != Routes.authLogin) {
      await Get.offAllNamed(Routes.authLogin);
    }
  }

  /// 是否已登录。
  static bool get isLogin => (token ?? '').isNotEmpty;
}
