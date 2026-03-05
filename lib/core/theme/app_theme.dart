import 'package:flutter/material.dart';

/// 应用主题集合，统一管理全局视觉配置。
class AppTheme {
  AppTheme._();
  static const Color _pageBackgroundColor = Color(0xFFF6F8FB);

  /// 浅色主题。
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
      useMaterial3: true,
      scaffoldBackgroundColor: _pageBackgroundColor,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: _pageBackgroundColor,
        surfaceTintColor: _pageBackgroundColor,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
    );
  }
}
