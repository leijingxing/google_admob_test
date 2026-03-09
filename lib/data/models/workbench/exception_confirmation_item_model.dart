import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'exception_confirmation_item_model.g.dart';

/// 异常确认列表项模型。
@JsonSerializable()
class ExceptionConfirmationItemModel {
  @NullableStringSafeConverter()
  final String? id;

  @NullableStringSafeConverter()
  final String? reportUserName;

  @NullableStringSafeConverter()
  final String? reportTime;

  @NullableStringSafeConverter()
  final String? exceptionLocation;

  @NullableStringSafeConverter()
  final String? locationData;

  @NullableStringSafeConverter()
  final String? exceptionDesc;

  @NullableStringListSafeConverter()
  final List<String>? exceptionImage;

  @NullableStringSafeConverter()
  final String? confirmerId;

  @NullableStringSafeConverter()
  final String? confirmerName;

  @NullableStringSafeConverter()
  final String? confirmerTime;

  @IntSafeConverter()
  final int isValid;

  @IntSafeConverter()
  final int confirmStatus;

  @NullableStringSafeConverter()
  final String? remark;

  const ExceptionConfirmationItemModel({
    this.id,
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

  factory ExceptionConfirmationItemModel.fromJson(Map<String, dynamic> json) =>
      _$ExceptionConfirmationItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExceptionConfirmationItemModelToJson(this);
}
