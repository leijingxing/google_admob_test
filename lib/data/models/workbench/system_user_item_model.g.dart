// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_user_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemUserItemModel _$SystemUserItemModelFromJson(Map<String, dynamic> json) =>
    SystemUserItemModel(
      id: const NullableStringSafeConverter().fromJson(json['id']),
      userName: const NullableStringSafeConverter().fromJson(json['userName']),
      postName: const NullableStringSafeConverter().fromJson(json['postName']),
      phone: const NullableStringSafeConverter().fromJson(json['phone']),
      companyName: const NullableStringSafeConverter().fromJson(
        json['companyName'],
      ),
    );

Map<String, dynamic> _$SystemUserItemModelToJson(
  SystemUserItemModel instance,
) => <String, dynamic>{
  'id': const NullableStringSafeConverter().toJson(instance.id),
  'userName': const NullableStringSafeConverter().toJson(instance.userName),
  'postName': const NullableStringSafeConverter().toJson(instance.postName),
  'phone': const NullableStringSafeConverter().toJson(instance.phone),
  'companyName': const NullableStringSafeConverter().toJson(
    instance.companyName,
  ),
};
