import '../../core/http/result.dart';

/// 登录模块仓库层，统一管理鉴权相关数据请求。
class AuthRepository {
  /// 账号登录，当前脚手架默认返回 mock token。
  Future<Result<String>> login({
    required String username,
    required String password,
  }) async {
    // 脚手架默认返回模拟 token，实际项目替换为真实接口。
    if (username.isEmpty || password.isEmpty) {
      return Failure(AppError(code: -1, message: '用户名或密码不能为空'));
    }

    return Success('mock-token-${DateTime.now().millisecondsSinceEpoch}');
    // 示例真实请求：
    // return HttpService().post<String>(
    //   '/auth/login',
    //   data: {'username': username, 'password': password},
    //   parser: (json) => (json['token'] ?? '') as String,
    // );
  }

  /// 退出登录，预留服务端登出扩展点。
  Future<Result<void>> logout() async {
    // 如需服务端登出可在此调用 HttpService。
    return const Success(null);
  }
}
