import 'package:get/get.dart';

import '../../modules/profile/settings/settings_binding.dart';
import '../../modules/profile/settings/settings_view.dart';
import '../../modules/profile/version_info/version_info_binding.dart';
import '../../modules/profile/version_info/version_info_view.dart';

/// Profile 模块页面跳转封装（非命名路由）。
abstract class ProfileRoutes {
  ProfileRoutes._();

  /// 设置页。
  static Future<T?>? toSettings<T>() {
    return Get.to<T>(() => const SettingsView(), binding: SettingsBinding());
  }

  /// 版本信息页。
  static Future<T?>? toVersionInfo<T>() {
    return Get.to<T>(
      () => const VersionInfoView(),
      binding: VersionInfoBinding(),
    );
  }
}
