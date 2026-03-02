import 'package:json_annotation/json_annotation.dart';

import 'json_converters.dart';

part 'login_token_model.g.dart';

/// 登录响应模型。
@JsonSerializable()
class LoginTokenModel {
  /// 访问令牌。
  @StringSafeConverter()
  @JsonKey(name: 'access_token')
  final String accessToken;

  /// 令牌类型。
  @StringSafeConverter()
  @JsonKey(name: 'token_type')
  final String tokenType;

  /// 过期时间（秒）。
  @IntSafeConverter()
  @JsonKey(name: 'expires_in')
  final int expiresIn;

  /// 刷新令牌。
  @NullableStringSafeConverter()
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;

  /// 权限范围。
  @NullableStringSafeConverter()
  final String? scope;

  /// 唯一标识。
  @NullableStringSafeConverter()
  final String? jti;

  const LoginTokenModel({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    this.refreshToken,
    this.scope,
    this.jti,
  });

  /// 从 JSON 创建实例。
  factory LoginTokenModel.fromJson(Map<String, dynamic> json) =>
      _$LoginTokenModelFromJson(json);

  /// 转为 JSON。
  Map<String, dynamic> toJson() => _$LoginTokenModelToJson(this);
}
