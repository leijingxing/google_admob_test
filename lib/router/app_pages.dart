import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../modules/admob_demo/admob_demo_binding.dart';
import '../modules/admob_demo/admob_demo_view.dart';

/// 路由入口（非命名路由）。
class AppPages {
  AppPages._();

  /// 应用首页。
  static Widget buildHome() => const AdmobDemoView();

  /// 应用首页依赖。
  static Bindings buildInitialBinding() => AdmobDemoBinding();
}
