import 'package:flutter/material.dart';
import 'package:closed_off_app/core/env/prod_env.dart';
import 'package:closed_off_app/global.dart';

import 'my_app.dart';

/// 生产环境入口：加载生产配置并启动应用。
Future<void> main() async {
  await Global.init(env: ProdEnv());
  runApp(const MyApp());
}

