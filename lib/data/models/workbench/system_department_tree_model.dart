import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'system_department_tree_model.g.dart';

/// 系统部门树节点。
@JsonSerializable(explicitToJson: true)
class SystemDepartmentTreeModel {
  @NullableStringSafeConverter()
  final String? id;

  @NullableStringSafeConverter()
  final String? departmentName;

  final List<SystemDepartmentTreeModel> children;

  const SystemDepartmentTreeModel({
    this.id,
    this.departmentName,
    this.children = const <SystemDepartmentTreeModel>[],
  });

  factory SystemDepartmentTreeModel.fromJson(Map<String, dynamic> json) =>
      _$SystemDepartmentTreeModelFromJson(json);

  Map<String, dynamic> toJson() => _$SystemDepartmentTreeModelToJson(this);
}
