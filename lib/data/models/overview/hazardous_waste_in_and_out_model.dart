import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'hazardous_waste_in_and_out_model.g.dart';

/// 危化品出入园数量条目。
@JsonSerializable()
class HazardousWasteInAndOutModel {
  /// 危化品名称。
  @StringSafeConverter()
  final String goodsName;

  /// 数量。
  @IntSafeConverter()
  final int count;

  const HazardousWasteInAndOutModel({this.goodsName = '', this.count = 0});

  factory HazardousWasteInAndOutModel.fromJson(Map<String, dynamic> json) =>
      _$HazardousWasteInAndOutModelFromJson(json);

  Map<String, dynamic> toJson() => _$HazardousWasteInAndOutModelToJson(this);
}
