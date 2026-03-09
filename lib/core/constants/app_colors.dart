// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';


/// 应用色彩系统
/// 
/// 遵循设计规范，将颜色分为基础色盘、功能语义色和组件专用色。
/// 所有的视觉调整应优先在此文件中进行。
class AppColors {
  AppColors._();

  // --- 基础色盘 (Color Palette) ---
  
  /// 主品牌色通道 (蓝色系)
  static const Color blue50 = Color(0xFFF0F7FF);
  static const Color blue100 = Color(0xFFE2EEFF);
  static const Color blue200 = Color(0xFFD9E7FB);
  static const Color blue300 = Color(0xFFB8D5FF);
  static const Color blue400 = Color(0xFF66A3FF);
  static const Color blue500 = Color(0xFF007BFF); // 原 Primary
  static const Color blue600 = Color(0xFF0069D9);
  static const Color blue700 = Color(0xFF1E5EB8);
  static const Color blue800 = Color(0xFF1D4F91);
  static const Color blue900 = Color(0xFF103A6F);

  /// 灰度通道 (中性色)
  static const Color grey50 = Color(0xFFF8F9FA);
  static const Color grey100 = Color(0xFFF4F9FD);
  static const Color grey200 = Color(0xFFDEE2E6);
  static const Color grey300 = Color(0xFFCFDAEA);
  static const Color grey400 = Color(0xFFADB5BD);
  static const Color grey500 = Color(0xFF8191A8);
  static const Color grey600 = Color(0xFF6C757D);
  static const Color grey700 = Color(0xFF495057);
  static const Color grey800 = Color(0xFF343A40);
  static const Color grey900 = Color(0xFF212529);

  // --- 语义化颜色 (Semantic Colors) ---

  /// 主题核心色
  static const Color primary = blue500;
  static const Color secondary = grey600;

  /// 背景色
  static const Color background = Color(0xFFF5F8FC); // 统一页面背景
  static const Color surface = Colors.white;         // 容器表面色

  /// 状态色
  static const Color error = Color(0xFFDC3545);
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = blue500;

  /// 文本颜色
  static const Color textPrimary = grey900;          // 一级标题/正文
  static const Color textSecondary = grey600;        // 二级描述
  static const Color textHint = grey500;             // 提示文字/禁用态

  /// 边框与分割线
  static const Color border = Color(0xFFE2EAF6);     // 统一边框色
  static const Color divider = grey200;              // 分割线

  // --- 组件专用色 (Component Specific) ---

  /// 底部导航栏相关
  static const Color navUnselected = grey500;
  static const Color navShadow = Color(0x1A103A6F);  // 10% 透明度的 blue900

  /// 工作台/卡片相关
  static const Color headerTitle = blue800;
  static const Color headerSubtitle = Color(0xFF5E738E);
  static const Color featuredGradientStart = Color(0xFF1E5EB8);
  static const Color featuredGradientEnd = Color(0xFF3F84DB);
  
  // 保持旧代码兼容性
  static const Color meaningColorDanger = error;
  static const Color meaningColorSuccess = success;
  static const Color meaningColorWarning = Color(0xFFFA8442);
  static const Color meaningColorInfo = primary;
  
  static const Color meaning_color_danger = error;
  static const Color meaning_color_success = success;
  static const Color meaning_color_warning = meaningColorWarning;
  static const Color meaning_color_info = primary;
}
