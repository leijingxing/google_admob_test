// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

/// 应用色彩
///
/// 在这里定义应用的所有颜色，方便统一管理和修改。
class AppColors {
  // 主题色
  static const Color primary = Color(0xFF007BFF);
  static const Color secondary = Color(0xFF6C757D);

  // 背景色
  static const Color background = Color(0xFFF4F9FD);
  static const Color surface = Colors.white;

  // 状态色
  static const Color error = Color(0xFFDC3545);
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF17A2B8);

  // 语义化颜色
  static const Color meaningColorDanger = error;
  static const Color meaningColorSuccess = success;
  static const Color meaningColorWarning = Color(0xFFFA8442);
  static const Color meaningColorInfo = primary;
  static const Color meaning_color_danger = meaningColorDanger;
  static const Color meaning_color_success = meaningColorSuccess;
  static const Color meaning_color_warning = meaningColorWarning;
  static const Color meaning_color_info = meaningColorInfo;

  // 文本颜色
  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF6C757D);

  // 边框颜色
  static const Color border = Color(0xFFDEE2E6);
}
