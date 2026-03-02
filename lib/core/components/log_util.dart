import 'package:flutter/foundation.dart';
import 'package:flutter_base/global.dart';

/// 日志级别枚举（保持不变，为了 API 兼容性）
enum LogLevel {
  verbose,
  debug,
  info,
  warning,
  error,
  wtf,
}

/// 统一日志工具类（由 Talker 驱动）
///
/// 功能特性：
/// 1. 底层使用 talker，支持 talker 的所有功能（如应用内查看器）
/// 2. 保持 AppLog 的静态方法 API 不变，对项目其他部分透明
/// 3. Release 模式下自动禁用日志
class AppLog {
  /// 私有构造函数防止实例化
  AppLog._();

  /// 初始化日志系统
  ///
  /// 这个方法被保留下来是为了兼容旧的调用（如 Global.init），
  /// 但 talker 的主要配置在其全局实例创建时完成。
  static void configure() {
    // 目前无需额外配置，全局 talker 实例已经配置好了。
  }

  // region 公共日志方法 (API 保持不变)
  /// 详细日志
  static void verbose(dynamic message, [dynamic error, StackTrace? stack]) {
    _log(LogLevel.verbose, message, error, stack);
  }

  /// 调试日志
  static void debug(dynamic message, [dynamic error, StackTrace? stack]) {
    _log(LogLevel.debug, message, error, stack);
  }

  /// 信息日志
  static void info(dynamic message, [dynamic error, StackTrace? stack]) {
    _log(LogLevel.info, message, error, stack);
  }

  /// 警告日志
  static void warning(dynamic message, [dynamic error, StackTrace? stack]) {
    _log(LogLevel.warning, message, error, stack);
  }

  /// 错误日志
  static void error(dynamic message, [dynamic error, StackTrace? stack]) {
    _log(LogLevel.error, message, error, stack);
  }

  /// 严重错误日志（What a Terrible Failure）
  static void wtf(dynamic message, [dynamic error, StackTrace? stack]) {
    _log(LogLevel.wtf, message, error, stack);
  }
  // endregion

  // region 私有核心方法
  /// 统一日志处理核心（使用 talker）
  static void _log(
    LogLevel level,
    dynamic message, [
    dynamic error,
    StackTrace? stack,
  ]) {
    // Release 模式下完全禁用日志
    if (kReleaseMode) return;

    final logMessage = message is Function() ? message() : message;

    // 使用全局 talker 实例记录日志
    switch (level) {
      case LogLevel.verbose:
        talker.verbose(logMessage, error, stack);
        break;
      case LogLevel.debug:
        talker.debug(logMessage, error, stack);
        break;
      case LogLevel.info:
        talker.info(logMessage, error, stack);
        break;
      case LogLevel.warning:
        talker.warning(logMessage, error, stack);
        break;
      case LogLevel.error:
        talker.error(logMessage, error, stack);
        break;
      case LogLevel.wtf:
        talker.critical(logMessage, error, stack);
        break;
    }
  }
  // endregion
}
