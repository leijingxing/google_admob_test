import 'package:flutter_base/core/http/result.dart';
import 'package:flutter_base/generated/json/base/json_convert_content.dart';

import '../components/log_util.dart';
import 'http_paginated_result.dart';

/// 核心解析函数，HttpService 将调用这个方法
/// 它会根据泛型 T 自动选择正确的解析方式
T parseData<T>(dynamic data) {
  try {
    // 如果期望的类型是 dynamic 或者基本类型，直接返回
    if (T == dynamic || data is T) {
      return data;
    }
    if (data is Map && PaginatedResult.isPaginationStructure(data)) {
      data = data['records'];
    }

    // 调用代码生成工具提供的核心方法
    final result = JsonConvert.fromJsonAsT<T>(data);

    if (result == null) {
      // 如果结果为 null，但 T 不是可空类型，这可能是解析错误
      if (null is! T) {
        throw AppError(code: -100, message: '数据解析失败: 无法将JSON转换为 $T');
      }
    }
    return result as T;
  } catch (e) {
    AppLog.error('数据解析错误: $e');
    throw AppError(
      code: -100,
      message: '数据解析失败: $e',
    );
  }
}
