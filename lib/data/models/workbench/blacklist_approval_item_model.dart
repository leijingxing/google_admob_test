import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'blacklist_approval_item_model.g.dart';

/// 黑名单审批列表项模型。
@JsonSerializable()
class BlacklistApprovalItemModel {
  @NullableStringSafeConverter()
  final String? id;

  /// 1-人员黑名单；2-车辆黑名单。
  @IntSafeConverter()
  final int type;

  @NullableStringSafeConverter()
  final String? carNumb;

  @NullableStringSafeConverter()
  final String? realName;

  @NullableStringSafeConverter()
  final String? userPhone;

  @NullableStringSafeConverter()
  final String? createBy;

  @NullableStringSafeConverter()
  final String? createDate;

  @NullableStringSafeConverter()
  final String? submitUserPhone;

  @NullableStringSafeConverter()
  final String? remark;

  @NullableStringSafeConverter()
  final String? attachment;

  @NullableStringSafeConverter()
  final String? parkCheckUserName;

  @NullableStringSafeConverter()
  final String? parkCheckUserPhone;

  @NullableStringSafeConverter()
  final String? parkCheckTime;

  @NullableStringSafeConverter()
  final String? parkCheckDesc;

  @NullableStringSafeConverter()
  final String? validityBeginTime;

  @NullableStringSafeConverter()
  final String? validityEndTime;

  @IntSafeConverter()
  final int parkCheckStatus;

  /// 黑名单有效状态：0-失效；1-有效。
  @IntSafeConverter()
  final int status;

  /// 某些接口返回字段名为 state，这里一并兼容。
  @IntSafeConverter()
  final int state;

  @IntSafeConverter()
  final int carCategory;

  @IntSafeConverter()
  final int carNumbColour;

  @NullableStringSafeConverter()
  final String? roadTransportPermitNumber;

  @NullableStringSafeConverter()
  final String? drivingLicenseEnd;

  @NullableStringSafeConverter()
  final String? drivingLicensePic;

  @IntSafeConverter()
  final int trailer;

  @NullableStringSafeConverter()
  final String? trailerLicensePlate;

  @NullableStringSafeConverter()
  final String? trailerRoadTransportPermitNumber;

  @NullableStringSafeConverter()
  final String? trailerTrailerDrivingLicense;

  @IntSafeConverter()
  final int sex;

  @NullableStringSafeConverter()
  final String? idCard;

  @NullableStringSafeConverter()
  final String? faceUrl;

  const BlacklistApprovalItemModel({
    this.id,
    this.type = 0,
    this.carNumb,
    this.realName,
    this.userPhone,
    this.createBy,
    this.createDate,
    this.submitUserPhone,
    this.remark,
    this.attachment,
    this.parkCheckUserName,
    this.parkCheckUserPhone,
    this.parkCheckTime,
    this.parkCheckDesc,
    this.validityBeginTime,
    this.validityEndTime,
    this.parkCheckStatus = 0,
    this.status = 0,
    this.state = 0,
    this.carCategory = 0,
    this.carNumbColour = 0,
    this.roadTransportPermitNumber,
    this.drivingLicenseEnd,
    this.drivingLicensePic,
    this.trailer = 0,
    this.trailerLicensePlate,
    this.trailerRoadTransportPermitNumber,
    this.trailerTrailerDrivingLicense,
    this.sex = 0,
    this.idCard,
    this.faceUrl,
  });

  factory BlacklistApprovalItemModel.fromJson(Map<String, dynamic> json) =>
      _$BlacklistApprovalItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$BlacklistApprovalItemModelToJson(this);
}
