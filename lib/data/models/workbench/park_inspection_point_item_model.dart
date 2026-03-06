import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'park_inspection_point_item_model.g.dart';

/// 园区巡检点位模型。
@JsonSerializable()
class ParkInspectionPointItemModel {
  @NullableStringSafeConverter()
  final String? id;

  @NullableStringSafeConverter()
  final String? pointId;

  @NullableStringSafeConverter()
  final String? pointName;

  @NullableStringSafeConverter()
  final String? position;

  @IntSafeConverter()
  final int checkRadius;

  const ParkInspectionPointItemModel({
    this.id,
    this.pointId,
    this.pointName,
    this.position,
    this.checkRadius = 0,
  });

  factory ParkInspectionPointItemModel.fromJson(Map<String, dynamic> json) =>
      _$ParkInspectionPointItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ParkInspectionPointItemModelToJson(this);
}
