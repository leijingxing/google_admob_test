// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginEntity _$LoginEntityFromJson(Map<String, dynamic> json) => LoginEntity(
  id: const NullableStringSafeConverter().fromJson(json['id']),
  companyCode: const NullableStringSafeConverter().fromJson(
    json['companyCode'],
  ),
  isAdmin: const NullableStringSafeConverter().fromJson(json['isAdmin']),
  companyName: const NullableStringSafeConverter().fromJson(
    json['companyName'],
  ),
  departmentId: const NullableStringSafeConverter().fromJson(
    json['departmentId'],
  ),
  departmentName: const NullableStringSafeConverter().fromJson(
    json['departmentName'],
  ),
  userAccount: const NullableStringSafeConverter().fromJson(
    json['userAccount'],
  ),
  userName: const NullableStringSafeConverter().fromJson(json['userName']),
  sex: const NullableStringSafeConverter().fromJson(json['sex']),
  phone: const NullableStringSafeConverter().fromJson(json['phone']),
  headPortrait: const NullableStringSafeConverter().fromJson(
    json['headPortrait'],
  ),
  mail: const NullableStringSafeConverter().fromJson(json['mail']),
  enterprisesOrGovernments: json['enterprisesOrGovernments'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['enterprisesOrGovernments']),
  tenantId: const NullableStringSafeConverter().fromJson(json['tenantId']),
);

Map<String, dynamic> _$LoginEntityToJson(LoginEntity instance) =>
    <String, dynamic>{
      'id': const NullableStringSafeConverter().toJson(instance.id),
      'companyCode': const NullableStringSafeConverter().toJson(
        instance.companyCode,
      ),
      'isAdmin': const NullableStringSafeConverter().toJson(instance.isAdmin),
      'companyName': const NullableStringSafeConverter().toJson(
        instance.companyName,
      ),
      'departmentId': const NullableStringSafeConverter().toJson(
        instance.departmentId,
      ),
      'departmentName': const NullableStringSafeConverter().toJson(
        instance.departmentName,
      ),
      'userAccount': const NullableStringSafeConverter().toJson(
        instance.userAccount,
      ),
      'userName': const NullableStringSafeConverter().toJson(instance.userName),
      'sex': const NullableStringSafeConverter().toJson(instance.sex),
      'phone': const NullableStringSafeConverter().toJson(instance.phone),
      'headPortrait': const NullableStringSafeConverter().toJson(
        instance.headPortrait,
      ),
      'mail': const NullableStringSafeConverter().toJson(instance.mail),
      'enterprisesOrGovernments': const IntSafeConverter().toJson(
        instance.enterprisesOrGovernments,
      ),
      'tenantId': const NullableStringSafeConverter().toJson(instance.tenantId),
    };
