import 'dart:convert';

import '../../core/http/http_service.dart';
import '../../core/http/result.dart';
import '../models/login_token_model.dart';

/// 登录模块仓库层，统一管理鉴权相关数据请求。
class AuthRepository {
  /// 账号登录，调用真实鉴权接口。
  Future<Result<LoginTokenModel>> login({
    required String username,
    required String password,
  }) async {
    if (username.isEmpty || password.isEmpty) {
      return Failure(AppError(code: -1, message: '用户名或密码不能为空'));
    }

    final encodedPassword = base64Encode(utf8.encode(password));
    return HttpService().post<LoginTokenModel>(
      '/auth/oauth/token',
      data: {
        'type': 1,
        'grant_type': 'password',
        'username': username,
        'password': encodedPassword,
      },
      parser: (json) =>
          LoginTokenModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  /// 退出登录，预留服务端登出扩展点。
  Future<Result<void>> logout() async {
    // 如需服务端登出可在此调用 HttpService。
    return const Success(null);
  }
}
