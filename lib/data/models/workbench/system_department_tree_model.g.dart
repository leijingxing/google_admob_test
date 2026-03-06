// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_department_tree_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemDepartmentTreeModel _$SystemDepartmentTreeModelFromJson(
  Map<String, dynamic> json,
) => SystemDepartmentTreeModel(
  id: const NullableStringSafeConverter().fromJson(json['id']),
  departmentName: const NullableStringSafeConverter().fromJson(
    json['departmentName'],
  ),
  children:
      (json['children'] as List<dynamic>?)
          ?.map(
            (e) =>
                SystemDepartmentTreeModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <SystemDepartmentTreeModel>[],
);

Map<String, dynamic> _$SystemDepartmentTreeModelToJson(
  SystemDepartmentTreeModel instance,
) => <String, dynamic>{
  'id': const NullableStringSafeConverter().toJson(instance.id),
  'departmentName': const NullableStringSafeConverter().toJson(
    instance.departmentName,
  ),
  'children': instance.children.map((e) => e.toJson()).toList(),
};
