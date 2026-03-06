import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'spot_inspection_item_model.g.dart';

/// 车辆抽检列表项模型。
@JsonSerializable()
class SpotInspectionItemModel {
  @NullableStringSafeConverter()
  final String? id;

  @NullableStringSafeConverter()
  final String? reservationId;

  @NullableStringSafeConverter()
  final String? carNumb;

  @NullableStringSafeConverter()
  final String? checkTemplateName;

  @NullableStringSafeConverter()
  final String? securityCheckTime;

  @NullableStringSafeConverter()
  final String? createBy;

  /// 1-通过；0-不通过；空-待抽检。
  @NullableStringSafeConverter()
  final String? securityCheckResults;

  @NullableStringSafeConverter()
  final String? goodsTypeName;

  @NullableStringSafeConverter()
  final String? goodsName;

  @NullableStringSafeConverter()
  final String? estimatedInTime;

  @NullableStringSafeConverter()
  final String? reservationTime;

  @NullableStringSafeConverter()
  final String? parkStatus;

  @NullableStringSafeConverter()
  final String? parkStatusName;

  const SpotInspectionItemModel({
    this.id,
    this.reservationId,
    this.carNumb,
    this.checkTemplateName,
    this.securityCheckTime,
    this.createBy,
    this.securityCheckResults,
    this.goodsTypeName,
    this.goodsName,
    this.estimatedInTime,
    this.reservationTime,
    this.parkStatus,
    this.parkStatusName,
  });

  factory SpotInspectionItemModel.fromJson(Map<String, dynamic> json) =>
      _$SpotInspectionItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$SpotInspectionItemModelToJson(this);
}
