import 'package:dio/dio.dart';

import 'result.dart';

/// 统一处理接口业务协议：拦截业务失败并抽取 data 字段。
class HttpResponseProtocol {
  /// 校验业务响应是否成功，不成功则抛出 DioException。
  void validate(Response response) {
    final responseData = response.data;
    if (responseData is! Map<String, dynamic>) return;

    if (responseData.containsKey('success') &&
        responseData['success'] == false) {
      final errCodeStr = responseData['errCode']?.toString();
      final errCodeInt = int.tryParse(errCodeStr ?? '') ?? -1;
      final errMsg = responseData['message'] ?? '业务逻辑错误';
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: AppError(code: errCodeInt, message: errMsg.toString()),
      );
    }

    if (responseData.containsKey('code')) {
      final codeValue = responseData['code'];
      final code = codeValue is String
          ? int.tryParse(codeValue) ?? -1
          : codeValue;
      if (code != 0 && code != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: AppError(
            code: code is int ? code : -1,
            message: (responseData['message'] ?? '业务逻辑错误').toString(),
          ),
        );
      }
    }
  }

  /// 从响应中提取业务数据。
  dynamic unwrap(dynamic responseBody) {
    if (responseBody is Map && responseBody.containsKey('data')) {
      final data = responseBody['data'];
      final hasPaginationMeta =
          responseBody.containsKey('totalCount') ||
          responseBody.containsKey('totalPages') ||
          responseBody.containsKey('pageIndex') ||
          responseBody.containsKey('pageSize') ||
          responseBody.containsKey('total') ||
          responseBody.containsKey('pages') ||
          responseBody.containsKey('current') ||
          responseBody.containsKey('pageNum') ||
          responseBody.containsKey('pageNo') ||
          responseBody.containsKey('size');

      // 分页响应保留外层，避免丢失 total/page 信息。
      if (hasPaginationMeta && data is List) {
        return responseBody;
      }
      return data;
    }
    return responseBody;
  }
}
