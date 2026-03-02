// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: const IntSafeConverter().fromJson(json['id']),
  name: const StringSafeConverter().fromJson(json['name']),
  account: const NullableStringSafeConverter().fromJson(json['account']),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': const IntSafeConverter().toJson(instance.id),
  'name': const StringSafeConverter().toJson(instance.name),
  'account': const NullableStringSafeConverter().toJson(instance.account),
};
