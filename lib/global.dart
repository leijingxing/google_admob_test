import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'core/constants/storage.dart';
import 'core/env/env.dart';
import 'core/http/http_service.dart';
import 'core/utils/storage_util.dart';
import 'core/utils/user_manager.dart';

/// 全局 Talker 实例，用于日志记录与网络日志展示。
final talker = TalkerFlutter.init();

/// [功能]: 应用启动阶段的全局初始化入口。
/// [说明]:
///   - 只负责一次性初始化（环境、存储、网络、用户态）。
///   - 不承载具体业务逻辑，避免污染启动链路。
class Global {
  /// 是否首次打开应用。
  static bool isFirstOpen = false;

  /// [功能]: 初始化全局依赖。
  /// [输入]:
  ///   - [env]: 当前运行环境配置（开发/生产）。
  /// [业务逻辑]:
  ///   1. 初始化 Flutter 绑定与本地存储。
  ///   2. 初始化环境配置、用户状态、网络服务。
  ///   3. 记录首开标记与系统 UI 样式。
  static Future<void> init({required Env env}) async {
    WidgetsFlutterBinding.ensureInitialized();
    await StorageUtil.init();

    Environment().init(env);
    await UserManager.init();

    HttpService().init(
      getToken: () async => UserManager.token,
      onAuthError: (_) async => UserManager.logout(),
    );

    isFirstOpen = StorageUtil.getBool(StorageConstants.firstOpen) ?? true;
    if (isFirstOpen) {
      await StorageUtil.setBool(StorageConstants.firstOpen, false);
    }

    if (GetPlatform.isAndroid) {
      const style = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      );
      SystemChrome.setSystemUIOverlayStyle(style);
    }

    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
}
