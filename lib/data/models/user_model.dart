import 'package:json_annotation/json_annotation.dart';

import 'json_converters.dart';

part 'user_model.g.dart';

/// 用户模型示例（json_serializable）。
@JsonSerializable()
class UserModel {
  /// 用户 ID。
  @IntSafeConverter()
  final int id;

  /// 用户名。
  @StringSafeConverter()
  final String name;

  /// 账号。
  @NullableStringSafeConverter()
  final String? account;

  const UserModel({
    required this.id,
    required this.name,
    this.account,
  });

  /// 从 JSON 创建实例。
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// 转为 JSON。
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
