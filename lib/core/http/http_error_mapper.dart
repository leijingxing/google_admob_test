import 'package:dio/dio.dart';

import 'result.dart';

/// 将 Dio 层错误映射为统一的 AppError。
class HttpErrorMapper {
  /// 错误映射入口。
  AppError map(DioException error) {
    if (error.error is AppError) {
      return error.error as AppError;
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppError(code: -2, message: '网络连接超时，请检查您的网络设置');
      case DioExceptionType.badResponse:
        return _mapBadResponse(error);
      case DioExceptionType.cancel:
        return AppError(code: -3, message: '请求已取消');
      case DioExceptionType.unknown:
        if (error.message != null) {
          return AppError(code: -1, message: error.message!);
        }
        return AppError(code: -4, message: '请求错误，请稍后重试');
      default:
        return AppError(code: -1, message: '请求错误，请稍后重试');
    }
  }

  AppError _mapBadResponse(DioException error) {
    final statusCode = error.response?.statusCode ?? -1;
    final responseData = error.response?.data;
    if (responseData is Map && responseData['message'] != null) {
      return AppError(
        code: statusCode,
        message: responseData['message'].toString(),
      );
    }

    switch (statusCode) {
      case 401:
        return AppError(code: statusCode, message: '认证失败，请重新登录');
      case 403:
        return AppError(code: statusCode, message: '没有权限访问');
      case 404:
        return AppError(code: statusCode, message: '您访问的资源不存在');
      case 500:
      case 502:
      case 503:
        return AppError(code: statusCode, message: '服务器开小差了，请稍后再试');
      default:
        return AppError(code: statusCode, message: '请求失败');
    }
  }
}
