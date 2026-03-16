import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'exception_confirmation_item_model.g.dart';

/// 异常确认列表项模型。
@JsonSerializable()
class ExceptionConfirmationItemModel {
  /// 主键 ID。
  @NullableStringSafeConverter()
  final String? id;

  /// 上报人 ID。
  @NullableStringSafeConverter()
  final String? reportUserId;

  /// 上报人名称。
  @NullableStringSafeConverter()
  final String? reportUserName;

  /// 上报时间。
  @NullableStringSafeConverter()
  final String? reportTime;

  /// 异常位置。
  @NullableStringSafeConverter()
  final String? exceptionLocation;

  /// 位置经纬度。
  @NullableStringSafeConverter()
  final String? locationData;

  /// 异常描述。
  @NullableStringSafeConverter()
  final String? exceptionDesc;

  /// 照片。
  @NullableStringListSafeConverter()
  final List<String>? exceptionImage;

  /// 确认人 ID。
  @NullableStringSafeConverter()
  final String? confirmerId;

  /// 确认人名称。
  @NullableStringSafeConverter()
  final String? confirmerName;

  /// 确认时间。
  @NullableStringSafeConverter()
  final String? confirmerTime;

  /// 是否有效(1.是，2.否)。
  @IntSafeConverter()
  final int isValid;

  /// 确认状态(1.已确认，2.待确认，其他.已撤销)。
  @IntSafeConverter()
  final int confirmStatus;

  /// 备注。
  @NullableStringSafeConverter()
  final String? remark;

  const ExceptionConfirmationItemModel({
    this.id,
    this.reportUserId,
    this.reportUserName,
    this.reportTime,
    this.exceptionLocation,
    this.locationData,
    this.exceptionDesc,
    this.exceptionImage,
    this.confirmerId,
    this.confirmerName,
    this.confirmerTime,
    this.isValid = 0,
    this.confirmStatus = 0,
    this.remark,
  });

  /// 从 JSON 创建实例。
  factory ExceptionConfirmationItemModel.fromJson(Map<String, dynamic> json) =>
      _$ExceptionConfirmationItemModelFromJson(json);

  /// 转为 JSON。
  Map<String, dynamic> toJson() => _$ExceptionConfirmationItemModelToJson(this);
}
