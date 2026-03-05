import '../../core/env/env.dart';
import '../../core/http/http_service.dart';
import '../../core/http/result.dart';

/// 登录模块仓库层，统一管理鉴权相关数据请求。
class AuthRepository {
  final HttpService _httpService = HttpService();

  /// 获取登录验证码。
  Future<Result<Map<String, dynamic>>> getVerifyCode() {
    return _httpService.get<Map<String, dynamic>>(
      '/api/oauth2/proxy/captcha',
      queryParameters: {
        'appCode': Environment.currentEnv.appCode,
        'debug': true,
      },
      parser: (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  /// 获取认证地址。
  Future<String> getAuthorizationUrl() async {
    final result = await _httpService.get<dynamic>(
      '/api/oauth2/getAuthorizationUrl',
      queryParameters: {
        'appCode': Environment.currentEnv.appCode,
        'web_redirect_uri': '',
      },
    );
    return result.when(
      success: (data) => data.toString(),
      failure: (error) => throw Exception(error.message),
    );
  }

  /// 代理登录获取授权码。
  Future<String> proxyLogin({
    required String state,
    required String authorizationUrl,
    required String captcha,
    required String username,
    required String password,
  }) async {
    if (state.isEmpty || authorizationUrl.isEmpty) {
      throw Exception('登录状态参数缺失');
    }
    if (captcha.isEmpty || username.isEmpty || password.isEmpty) {
      throw Exception('用户名、密码或验证码不能为空');
    }

    final result = await _httpService.post<dynamic>(
      '/api/oauth2/proxy/authCode',
      data: {
        'appCode': Environment.currentEnv.appCode,
        'state': state,
        'authorizationUrl': authorizationUrl,
        'captcha': captcha,
        'username': username,
        'password': password,
      },
    );
    return result.when(
      success: (data) => data.toString(),
      failure: (error) => throw Exception(error.message),
    );
  }

  /// 通过授权码换取 token。
  Future<String> getAccessToken(String code) async {
    if (code.isEmpty) {
      throw Exception('授权码不能为空');
    }

    final result = await _httpService.get<Map<String, dynamic>>(
      '/api/oauth2/getAccessToken',
      queryParameters: {
        'appCode': Environment.currentEnv.appCode,
        'code': code,
      },
      parser: (json) => Map<String, dynamic>.from(json as Map),
    );

    return result.when(
      success: (data) {
        final tokenValue = data['tokenValue'];
        if (tokenValue == null || tokenValue.toString().isEmpty) {
          throw Exception('tokenValue 为空');
        }
        return tokenValue.toString();
      },
      failure: (error) => throw Exception(error.message),
    );
  }

  /// 退出登录，预留服务端登出扩展点。
  Future<Result<void>> logout() async {
    // 如需服务端登出可在此调用 HttpService。
    return const Success(null);
  }
}
