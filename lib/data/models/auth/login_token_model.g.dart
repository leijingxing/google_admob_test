// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginTokenModel _$LoginTokenModelFromJson(Map<String, dynamic> json) =>
    LoginTokenModel(
      accessToken: const StringSafeConverter().fromJson(json['access_token']),
      tokenType: const StringSafeConverter().fromJson(json['token_type']),
      expiresIn: const IntSafeConverter().fromJson(json['expires_in']),
      refreshToken: const NullableStringSafeConverter().fromJson(
        json['refresh_token'],
      ),
      scope: const NullableStringSafeConverter().fromJson(json['scope']),
      jti: const NullableStringSafeConverter().fromJson(json['jti']),
    );

Map<String, dynamic> _$LoginTokenModelToJson(LoginTokenModel instance) =>
    <String, dynamic>{
      'access_token': const StringSafeConverter().toJson(instance.accessToken),
      'token_type': const StringSafeConverter().toJson(instance.tokenType),
      'expires_in': const IntSafeConverter().toJson(instance.expiresIn),
      'refresh_token': const NullableStringSafeConverter().toJson(
        instance.refreshToken,
      ),
      'scope': const NullableStringSafeConverter().toJson(instance.scope),
      'jti': const NullableStringSafeConverter().toJson(instance.jti),
    };
