import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:closed_off_app/core/env/env.dart';
import 'package:closed_off_app/core/http/result.dart';
import 'package:http_cache_hive_store/http_cache_hive_store.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

import '../../global.dart';
import 'http_auth_strategy.dart';
import 'http_error_mapper.dart';
import 'http_response_protocol.dart';

export 'http_paginated_result.dart';

/// 响应解析器：将接口 data 段转换为目标类型。
typedef ResponseParser<T> = T Function(dynamic json);

/// 网络请求统一服务，封装 Dio 初始化、缓存策略、日志与错误转换。
class HttpService {
  /// 私有构造函数
  HttpService._internal();

  /// 单例实例
  static final HttpService _instance = HttpService._internal();

  /// 工厂构造函数，返回单例实例
  factory HttpService() => _instance;

  late final Dio _dio;
  late final CacheOptions? _cacheOptions;
  final Map<String, Future<Result<dynamic>>> _inflightRequests =
      <String, Future<Result<dynamic>>>{};
  final HttpAuthStrategy _authStrategy = HttpAuthStrategy();
  final HttpErrorMapper _errorMapper = HttpErrorMapper();
  final HttpResponseProtocol _responseProtocol = HttpResponseProtocol();

  /// 仅在测试或调试场景使用，便于自定义 Adapter/拦截器
  @visibleForTesting
  Dio get testingClient => _dio;

  /// 初始化网络服务，必须在应用启动时调用
  ///
  /// [getToken] 一个返回用户 Token 的异步函数
  /// [onAuthError] 当发生认证错误 (401) 时触发的回调，通常用于跳转到登录页
  /// [cachePath] 缓存路径，如果提供，则开启网络缓存功能
  void init({
    Future<String?> Function()? getToken,
    Future<void> Function(DioException error)? onAuthError,
    String? cachePath,
  }) {
    _authStrategy.configure(getToken: getToken, onAuthError: onAuthError);

    final options = BaseOptions(
      baseUrl: Environment.currentEnv.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'authorization': 'Basic ZmFuOjEyMzQ1Ng==',
      },
    );
    _dio = Dio(options);

    // 配置缓存拦截器
    if (cachePath != null && cachePath.isNotEmpty) {
      _cacheOptions = CacheOptions(
        store: HiveCacheStore(cachePath),
        policy: CachePolicy.request,
        hitCacheOnErrorCodes: [401, 403],
        maxStale: const Duration(days: 7),
        priority: CachePriority.normal,
        keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      );
      _dio.interceptors.add(DioCacheInterceptor(options: _cacheOptions!));
    } else {
      _cacheOptions = null;
    }

    // 添加核心拦截器
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );

    // 在调试模式下添加日志拦截器
    if (kDebugMode) {
      _dio.interceptors.add(
        TalkerDioLogger(
          talker: talker,
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: false,
            printResponseHeaders: false,
            printResponseMessage: true,
          ),
        ),
      );
    }
  }

  // =======================================================================
  // >> 公共请求方法 <<
  // =======================================================================

  /// 发起 GET 请求
  Future<Result<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ResponseParser<T>? parser,
    CachePolicy cachePolicy = CachePolicy.noCache,
    Duration? cacheDuration,
    bool enableDedupe = false,
    String? dedupeKey,
  }) async {
    return _request<T>(
      path,
      method: 'GET',
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      parser: parser,
      cachePolicy: cachePolicy,
      cacheDuration: cacheDuration,
      enableDedupe: enableDedupe,
      dedupeKey: dedupeKey,
    );
  }

  /// 发起 POST 请求
  Future<Result<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ResponseParser<T>? parser,
    bool enableDedupe = true,
    String? dedupeKey,
  }) async {
    return _request<T>(
      path,
      method: 'POST',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      parser: parser,
      enableDedupe: enableDedupe,
      dedupeKey: dedupeKey,
    );
  }

  /// 发起 PUT 请求
  Future<Result<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ResponseParser<T>? parser,
    bool enableDedupe = true,
    String? dedupeKey,
  }) async {
    return _request<T>(
      path,
      method: 'PUT',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      parser: parser,
      enableDedupe: enableDedupe,
      dedupeKey: dedupeKey,
    );
  }

  /// 发起 DELETE 请求
  Future<Result<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ResponseParser<T>? parser,
    bool enableDedupe = true,
    String? dedupeKey,
  }) async {
    return _request<T>(
      path,
      method: 'DELETE',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      parser: parser,
      enableDedupe: enableDedupe,
      dedupeKey: dedupeKey,
    );
  }

  // =======================================================================
  // >> 核心请求逻辑 <<
  // =======================================================================

  /// 统一请求入口，组装 Options、触发 Dio 请求并返回 `Result<T>`
  Future<Result<T>> _request<T>(
    String path, {
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ResponseParser<T>? parser,
    CachePolicy cachePolicy = CachePolicy.noCache,
    Duration? cacheDuration,
    ProgressCallback? onSendProgress,
    bool enableDedupe = false,
    String? dedupeKey,
  }) async {
    if (!enableDedupe) {
      return _doRequest<T>(
        path,
        method: method,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        parser: parser,
        cachePolicy: cachePolicy,
        cacheDuration: cacheDuration,
        onSendProgress: onSendProgress,
      );
    }

    final String requestKey =
        dedupeKey ??
        _buildDedupeKey(
          method: method,
          path: path,
          queryParameters: queryParameters,
          data: data,
        );

    final Future<Result<dynamic>>? inflight = _inflightRequests[requestKey];
    if (inflight != null) {
      final reused = await inflight;
      return reused as Result<T>;
    }

    final Future<Result<T>> task = _doRequest<T>(
      path,
      method: method,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      parser: parser,
      cachePolicy: cachePolicy,
      cacheDuration: cacheDuration,
      onSendProgress: onSendProgress,
    );

    _inflightRequests[requestKey] = task.then<Result<dynamic>>(
      (value) => value,
    );
    try {
      return await task;
    } finally {
      _inflightRequests.remove(requestKey);
    }
  }

  /// 真实请求执行逻辑：发起请求、解析响应并统一映射错误
  Future<Result<T>> _doRequest<T>(
    String path, {
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ResponseParser<T>? parser,
    CachePolicy cachePolicy = CachePolicy.noCache,
    Duration? cacheDuration,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      Options requestOptions = options ?? Options();
      requestOptions.method = method;

      // 设置缓存策略
      if (_cacheOptions != null) {
        final effectiveCacheOptions = _cacheOptions.copyWith(
          policy: cachePolicy,
          maxStale: cacheDuration,
        );
        requestOptions = effectiveCacheOptions.toOptions()..method = method;
      }

      final response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: requestOptions,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );

      final responseData = _responseProtocol.unwrap(response.data);

      if (parser != null) {
        return Success(parser(responseData));
      }

      if (responseData is T) {
        return Success(responseData);
      }
      if (T == dynamic || T.toString().startsWith('Map<')) {
        return Success(responseData as T);
      }
      return Failure(
        AppError(code: -1, message: '未提供解析器(parser)，无法将响应转换为 ${T.toString()}'),
      );
    } on DioException catch (e) {
      return Failure(_errorMapper.map(e));
    } on AppError catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(AppError(code: -1, message: '未知错误: $e'));
    }
  }

  /// 构造默认去重 key（method + path + query + data）
  String _buildDedupeKey({
    required String method,
    required String path,
    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) {
    return '$method|$path|q=${queryParameters.toString()}|d=${data.toString()}';
  }

  // =======================================================================
  // >> 拦截器 <<
  // =======================================================================

  /// 请求拦截：注入 Token、统一 Header
  void _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    await _authStrategy.applyToken(options);
    return handler.next(options);
  }

  /// 响应拦截：基于约定 code 字段判定业务成功
  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      _responseProtocol.validate(response);
      return handler.next(response);
    } on DioException catch (error) {
      return handler.reject(error, true);
    }
  }

  /// 异常拦截：处理 401 回调并交给统一错误转换
  void _onError(DioException err, ErrorInterceptorHandler handler) {
    _authStrategy.handleAuthError(err);
    return handler.next(err);
  }
}

