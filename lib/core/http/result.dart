/// 自定义网络错误类
class AppError implements Exception {
  final int code;
  final String message;

  AppError({required this.code, required this.message});

  @override
  String toString() => 'AppError(code: $code, message: $message)';
}

/// 使用 sealed class 表示网络请求结果，提高类型安全性
sealed class Result<T> {
  const Result();

  /// 便捷的模式匹配方法，简化调用方处理分支逻辑
  R when<R>({
    required R Function(T data) success,
    required R Function(AppError error) failure,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).data);
    } else {
      return failure((this as Failure<T>).error);
    }
  }
}

/// 请求成功
class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);
}

/// 请求失败
class Failure<T> extends Result<T> {
  final AppError error;

  const Failure(this.error);
}
