import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class AppDimens {
  AppDimens._();

  static const double dp0 = 0;
  static double dp2 = 2.w;
  static double dp4 = 4.w;
  static double dp3 = 3.w;
  static double dp5 = 5.w;
  static double dp6 = 6.w;
  static double dp8 = 8.w;
  static double dp9 = 9.w;
  static double dp10 = 10.w;
  static double dp12 = 12.w;
  static double dp14 = 14.w;
  static double dp16 = 16.w;
  static double dp18 = 18.w;
  static double dp20 = 20.w;
  static double dp22 = 22.w;
  static double dp24 = 24.w;
  static double dp26 = 26.w;
  static double dp28 = 28.w;
  static double dp30 = 30.w;
  static double dp32 = 32.w;
  static double dp34 = 34.w;
  static double dp36 = 36.w;
  static double dp38 = 38.w;
  static double dp40 = 40.w;
  static double dp44 = 44.w;
  static double dp48 = 48.w;
  static double dp50 = 50.w;
  static double dp54 = 54.w;
  static double dp56 = 56.w;
  static double dp58 = 58.w;
  static double dp60 = 60.w;
  static double dp64 = 64.w;
  static double dp72 = 72.w;
  static double dp80 = 80.w;
  static double dp84 = 84.w;
  static double dp88 = 88.w;
  static double dp92 = 92.w;
  static double dp96 = 96.w;
  static double dp100 = 100.w;
  static double dp112 = 112.w;
  static double dp120 = 120.w;
  static double dp128 = 128.w;
  static double dp140 = 140.w;
  static double dp150 = 150.w;
  static double dp196 = 196.w;
  static double dp200 = 200.w;
  static double dp220 = 220.w;
  static double dp256 = 256.w;
  static double dp300 = 300.w;

  /// 文字尺寸
  static double sp5 = 5.sp;
  static double sp6 = 6.sp;
  static double sp8 = 8.sp;
  static double sp10 = 10.sp;
  static double sp11 = 11.sp;
  static double sp12 = 12.sp;
  static double sp13 = 13.sp;
  static double sp14 = 14.sp;
  static double sp15 = 15.sp;
  static double sp16 = 16.sp;
  static double sp18 = 18.sp;
  static double sp20 = 20.sp;
  static double sp22 = 22.sp;
  static double sp24 = 24.sp;
  static double sp26 = 26.sp;
  static double sp28 = 28.sp;
  static double sp30 = 30.sp;
  static double sp32 = 32.sp;
  static double sp36 = 36.sp;

  /// 屏幕高度
  static double get sh => ScreenUtil().screenHeight;

  /// 屏幕宽度
  static double get sw => ScreenUtil().screenWidth;

  /// 状态栏高度
  static double get sbh => ScreenUtil().statusBarHeight;

  /// 底部安全区距离
  static double get bbh => ScreenUtil().bottomBarHeight;

  /// 底部安全区距离(最少不能低于16.w)
  static double get bbhSafe => bbh < 16.w ? 16.w : bbh;

  /// 顶部安全区距离(最少不能低于16.w)
  static double get sbhSafe => sbh < 16.w ? 16.w : sbh;
}
