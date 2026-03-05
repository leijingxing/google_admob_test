import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'vehicle_query_models.g.dart';

/// 车辆分类统计。
@JsonSerializable()
class VehicleCategoryCountModel {
  @IntSafeConverter()
  final int carCategory;

  @IntSafeConverter()
  final int totalCount;

  @IntSafeConverter()
  final int blackListCount;

  @IntSafeConverter()
  final int whiteListCount;

  @IntSafeConverter()
  final int reservationCount;

  const VehicleCategoryCountModel({
    this.carCategory = 0,
    this.totalCount = 0,
    this.blackListCount = 0,
    this.whiteListCount = 0,
    this.reservationCount = 0,
  });

  factory VehicleCategoryCountModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleCategoryCountModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleCategoryCountModelToJson(this);
}

/// 车辆详情抽屉顶部统计。
@JsonSerializable()
class ComprehensiveDetailCountModel {
  @IntSafeConverter()
  final int accessRecordCount;

  @IntSafeConverter()
  final int authorizationCount;

  @IntSafeConverter()
  final int blackListCount;

  @IntSafeConverter()
  final int violationCount;

  const ComprehensiveDetailCountModel({
    this.accessRecordCount = 0,
    this.authorizationCount = 0,
    this.blackListCount = 0,
    this.violationCount = 0,
  });

  factory ComprehensiveDetailCountModel.fromJson(Map<String, dynamic> json) =>
      _$ComprehensiveDetailCountModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComprehensiveDetailCountModelToJson(this);
}

/// 车辆综合查询主列表项。
@JsonSerializable()
class VehicleComprehensiveItemModel {
  @NullableStringSafeConverter()
  final String? id;

  @NullableStringSafeConverter()
  final String? idCard;

  @StringSafeConverter()
  final String carNumb;

  @IntSafeConverter()
  final int carCategory;

  @IntSafeConverter()
  final int carNumbColour;

  @IntSafeConverter()
  final int trailer;

  @IntSafeConverter()
  final int validityStatus;

  @IntSafeConverter()
  final int accessCount;

  @IntSafeConverter()
  final int inCount;

  @IntSafeConverter()
  final int outCount;

  @IntSafeConverter()
  final int violationCount;

  @IntSafeConverter()
  final int blackCount;

  const VehicleComprehensiveItemModel({
    this.id,
    this.idCard,
    this.carNumb = '',
    this.carCategory = 0,
    this.carNumbColour = 0,
    this.trailer = 0,
    this.validityStatus = 0,
    this.accessCount = 0,
    this.inCount = 0,
    this.outCount = 0,
    this.violationCount = 0,
    this.blackCount = 0,
  });

  factory VehicleComprehensiveItemModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleComprehensiveItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleComprehensiveItemModelToJson(this);
}

/// 车辆授权记录。
@JsonSerializable()
class VehicleAuthorizationRecordModel {
  @NullableStringSafeConverter()
  final String? id;

  @IntSafeConverter()
  final int recordType;

  @StringSafeConverter()
  final String approvalTime;

  @StringSafeConverter()
  final String validityBeginTime;

  @StringSafeConverter()
  final String validityEndTime;

  @StringSafeConverter()
  final String userPhone;

  @StringSafeConverter()
  final String destination;

  @StringSafeConverter()
  final String inDate;

  const VehicleAuthorizationRecordModel({
    this.id,
    this.recordType = 0,
    this.approvalTime = '',
    this.validityBeginTime = '',
    this.validityEndTime = '',
    this.userPhone = '',
    this.destination = '',
    this.inDate = '',
  });

  factory VehicleAuthorizationRecordModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleAuthorizationRecordModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$VehicleAuthorizationRecordModelToJson(this);
}

/// 车辆出入记录。
@JsonSerializable()
class VehicleAccessRecordModel {
  @NullableStringSafeConverter()
  final String? reservationOrWhileId;

  @IntSafeConverter()
  final int recordType;

  @StringSafeConverter()
  final String userPhone;

  @StringSafeConverter()
  final String destination;

  @StringSafeConverter()
  final String inDate;

  @StringSafeConverter()
  final String inDeviceName;

  @StringSafeConverter()
  final String outDate;

  @StringSafeConverter()
  final String outDeviceName;

  @IntSafeConverter()
  final int violationCount;

  const VehicleAccessRecordModel({
    this.reservationOrWhileId,
    this.recordType = 0,
    this.userPhone = '',
    this.destination = '',
    this.inDate = '',
    this.inDeviceName = '',
    this.outDate = '',
    this.outDeviceName = '',
    this.violationCount = 0,
  });

  factory VehicleAccessRecordModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleAccessRecordModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleAccessRecordModelToJson(this);
}

/// 车辆违规记录。
@JsonSerializable()
class VehicleViolationRecordModel {
  @StringSafeConverter()
  final String subModuleTypeName;

  @StringSafeConverter()
  final String description;

  @StringSafeConverter()
  final String warningStartTime;

  @StringSafeConverter()
  final String position;

  @NullableStringSafeConverter()
  final String? warningFileUrl;

  const VehicleViolationRecordModel({
    this.subModuleTypeName = '',
    this.description = '',
    this.warningStartTime = '',
    this.position = '',
    this.warningFileUrl,
  });

  factory VehicleViolationRecordModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleViolationRecordModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleViolationRecordModelToJson(this);
}

/// 车辆拉黑记录。
@JsonSerializable()
class VehicleBlackRecordModel {
  @StringSafeConverter()
  final String userPhone;

  @IntSafeConverter()
  final int status;

  @StringSafeConverter()
  final String createBy;

  @StringSafeConverter()
  final String createDate;

  @StringSafeConverter()
  final String remark;

  const VehicleBlackRecordModel({
    this.userPhone = '',
    this.status = 0,
    this.createBy = '',
    this.createDate = '',
    this.remark = '',
  });

  factory VehicleBlackRecordModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleBlackRecordModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleBlackRecordModelToJson(this);
}
