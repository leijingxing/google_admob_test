// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_post_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemPostItemModel _$SystemPostItemModelFromJson(Map<String, dynamic> json) =>
    SystemPostItemModel(
      id: const NullableStringSafeConverter().fromJson(json['id']),
      postName: const NullableStringSafeConverter().fromJson(json['postName']),
      departmentId: const NullableStringSafeConverter().fromJson(
        json['departmentId'],
      ),
    );

Map<String, dynamic> _$SystemPostItemModelToJson(
  SystemPostItemModel instance,
) => <String, dynamic>{
  'id': const NullableStringSafeConverter().toJson(instance.id),
  'postName': const NullableStringSafeConverter().toJson(instance.postName),
  'departmentId': const NullableStringSafeConverter().toJson(
    instance.departmentId,
  ),
};
