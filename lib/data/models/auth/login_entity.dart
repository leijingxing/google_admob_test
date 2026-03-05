import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'login_entity.g.dart';

/// 登录后的用户信息模型。
@JsonSerializable()
class LoginEntity {
  /// 用户 ID。
  @NullableStringSafeConverter()
  final String? id;

  /// 企业编码。
  @NullableStringSafeConverter()
  final String? companyCode;

  /// 是否管理员：0-否；1-是。
  @NullableStringSafeConverter()
  final String? isAdmin;

  /// 企业名称。
  @NullableStringSafeConverter()
  final String? companyName;

  /// 部门 ID。
  @NullableStringSafeConverter()
  final String? departmentId;

  /// 部门名称。
  @NullableStringSafeConverter()
  final String? departmentName;

  /// 用户账号。
  @NullableStringSafeConverter()
  final String? userAccount;

  /// 用户姓名。
  @NullableStringSafeConverter()
  final String? userName;

  /// 性别：1-女；2-男。
  @NullableStringSafeConverter()
  final String? sex;

  /// 电话。
  @NullableStringSafeConverter()
  final String? phone;

  /// 头像。
  @NullableStringSafeConverter()
  final String? headPortrait;

  /// 邮箱。
  @NullableStringSafeConverter()
  final String? mail;

  /// 企业或政府单位：1-政府；2-企业。
  @IntSafeConverter()
  final int enterprisesOrGovernments;

  /// 租户 ID。
  @NullableStringSafeConverter()
  final String? tenantId;

  const LoginEntity({
    this.id,
    this.companyCode,
    this.isAdmin,
    this.companyName,
    this.departmentId,
    this.departmentName,
    this.userAccount,
    this.userName,
    this.sex,
    this.phone,
    this.headPortrait,
    this.mail,
    this.enterprisesOrGovernments = 0,
    this.tenantId,
  });

  /// 从 JSON 创建实例。
  factory LoginEntity.fromJson(Map<String, dynamic> json) =>
      _$LoginEntityFromJson(json);

  /// 转为 JSON。
  Map<String, dynamic> toJson() => _$LoginEntityToJson(this);
}
