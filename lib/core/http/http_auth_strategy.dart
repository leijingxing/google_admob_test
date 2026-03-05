import 'dart:async';

import 'package:dio/dio.dart';

import 'result.dart';

/// 统一处理认证注入与鉴权失败回调策略。
class HttpAuthStrategy {
  Future<String?> Function()? _getToken;
  Future<void> Function(DioException error)? _onAuthError;

  /// 配置认证依赖。
  void configure({
    Future<String?> Function()? getToken,
    Future<void> Function(DioException error)? onAuthError,
  }) {
    _getToken = getToken;
    _onAuthError = onAuthError;
  }

  /// 请求前注入 Token。
  Future<void> applyToken(RequestOptions options) async {
    if (_getToken == null) return;
    final token = await _getToken!();
    if (token == null || token.isEmpty) return;
    options.headers['Authorization'] = token;
  }

  /// 处理鉴权失败回调。
  void handleAuthError(DioException error) {
    if (_onAuthError == null) return;
    final appError = error.error;
    if (appError is AppError && appError.code == 1001) {
      unawaited(_onAuthError!(error));
      return;
    }
    if (error.response?.statusCode == 401) {
      unawaited(_onAuthError!(error));
    }
  }
}
