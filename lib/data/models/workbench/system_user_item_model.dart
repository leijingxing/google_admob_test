import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'system_user_item_model.g.dart';

/// 系统人员列表项。
@JsonSerializable()
class SystemUserItemModel {
  @NullableStringSafeConverter()
  final String? id;

  @NullableStringSafeConverter()
  final String? userName;

  @NullableStringSafeConverter()
  final String? postName;

  @NullableStringSafeConverter()
  final String? phone;

  @NullableStringSafeConverter()
  final String? companyName;

  const SystemUserItemModel({
    this.id,
    this.userName,
    this.postName,
    this.phone,
    this.companyName,
  });

  factory SystemUserItemModel.fromJson(Map<String, dynamic> json) =>
      _$SystemUserItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$SystemUserItemModelToJson(this);
}
