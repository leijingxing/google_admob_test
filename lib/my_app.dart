import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'core/components/app_scroll_behavior.dart';
import 'core/components/hide_keyboard.dart';
import 'core/env/env.dart';
import 'core/theme/app_theme.dart';
import 'router/app_pages.dart';

/// 应用根组件，统一配置主题、路由和国际化。
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  /// 构建根应用容器。
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return HideKeyboard(
          child: GetMaterialApp(
            title: Environment.currentEnv.title,
            debugShowCheckedModeBanner: !kReleaseMode,
            theme: AppTheme.lightTheme,
            home: AppPages.buildHome(),
            initialBinding: AppPages.buildInitialBinding(),
            scrollBehavior: AppScrollBehavior(),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('zh', 'CN'), Locale('en', 'US')],
            navigatorObservers: [BotToastNavigatorObserver()],
            builder: BotToastInit(),
          ),
        );
      },
    );
  }
}
