import 'package:flutter/material.dart';
import 'package:closed_off_app/core/env/dev_env.dart';
import 'package:closed_off_app/global.dart';

import 'my_app.dart';

/// 开发环境入口：初始化全局依赖后启动应用。
Future<void> main() async {
  await Global.init(env: DevEnv());
  runApp(const MyApp());
}

