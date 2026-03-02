import 'package:flutter/material.dart';

/// 应用主题集合，统一管理全局视觉配置。
class AppTheme {
  AppTheme._();

  /// 浅色主题。
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF6F8FB),
      appBarTheme: const AppBarTheme(centerTitle: true),
    );
  }
}
