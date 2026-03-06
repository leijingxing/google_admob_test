import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'system_post_item_model.g.dart';

/// 系统岗位列表项。
@JsonSerializable()
class SystemPostItemModel {
  @NullableStringSafeConverter()
  final String? id;

  @NullableStringSafeConverter()
  final String? postName;

  @NullableStringSafeConverter()
  final String? departmentId;

  const SystemPostItemModel({this.id, this.postName, this.departmentId});

  factory SystemPostItemModel.fromJson(Map<String, dynamic> json) =>
      _$SystemPostItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$SystemPostItemModelToJson(this);
}
