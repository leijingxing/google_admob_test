import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'logistics_query_models.g.dart';

/// 物流统计项。
@JsonSerializable()
class LogisticsStatisticsItemModel {
  @IntSafeConverter()
  final int hazardousType;

  @StringSafeConverter()
  final String topOneName;

  @StringSafeConverter()
  final String topOneAmount;

  @StringSafeConverter()
  final String topTwoName;

  @StringSafeConverter()
  final String topTwoAmount;

  @StringSafeConverter()
  final String topThreeName;

  @StringSafeConverter()
  final String topThreeAmount;

  const LogisticsStatisticsItemModel({
    this.hazardousType = 0,
    this.topOneName = '',
    this.topOneAmount = '0',
    this.topTwoName = '',
    this.topTwoAmount = '0',
    this.topThreeName = '',
    this.topThreeAmount = '0',
  });

  factory LogisticsStatisticsItemModel.fromJson(Map<String, dynamic> json) =>
      _$LogisticsStatisticsItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$LogisticsStatisticsItemModelToJson(this);
}

/// 物流综合查询主列表项。
@JsonSerializable()
class LogisticsComprehensiveItemModel {
  @NullableStringSafeConverter()
  final String? id;

  @StringSafeConverter()
  final String cas;

  @StringSafeConverter()
  final String goodsName;

  @StringSafeConverter()
  final int goodsType;

  @IntSafeConverter()
  final String? hazardousType;

  @IntSafeConverter()
  final int inCount;

  @IntSafeConverter()
  final int outCount;

  @StringSafeConverter()
  final String inGoodsAmount;

  @StringSafeConverter()
  final String outGoodsAmount;

  const LogisticsComprehensiveItemModel({
    this.id,
    this.cas = '',
    this.goodsName = '',
    this.goodsType = 0,
    this.hazardousType,
    this.inCount = 0,
    this.outCount = 0,
    this.inGoodsAmount = '0',
    this.outGoodsAmount = '0',
  });

  factory LogisticsComprehensiveItemModel.fromJson(Map<String, dynamic> json) =>
      _$LogisticsComprehensiveItemModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$LogisticsComprehensiveItemModelToJson(this);
}

/// 物流详情顶部统计。
@JsonSerializable()
class LogisticsDetailCountModel {
  @IntSafeConverter()
  final int accessRecordCount;

  @IntSafeConverter()
  final int authorizationCount;

  @IntSafeConverter()
  final int blackListCount;

  @IntSafeConverter()
  final int violationCount;

  const LogisticsDetailCountModel({
    this.accessRecordCount = 0,
    this.authorizationCount = 0,
    this.blackListCount = 0,
    this.violationCount = 0,
  });

  factory LogisticsDetailCountModel.fromJson(Map<String, dynamic> json) =>
      _$LogisticsDetailCountModelFromJson(json);

  Map<String, dynamic> toJson() => _$LogisticsDetailCountModelToJson(this);
}

/// 物流授权记录。
@JsonSerializable()
class LogisticsAuthorizationRecordModel {
  @NullableStringSafeConverter()
  final String? id;

  @NullableStringSafeConverter()
  final String? reservationId;

  @StringSafeConverter()
  final String parkCheckTime;

  @StringSafeConverter()
  final String validityBeginTime;

  @StringSafeConverter()
  final String validityEndTime;

  @StringSafeConverter()
  final String carNumb;

  @IntSafeConverter()
  final int loadType;

  @StringSafeConverter()
  final String destination;

  const LogisticsAuthorizationRecordModel({
    this.id,
    this.reservationId,
    this.parkCheckTime = '',
    this.validityBeginTime = '',
    this.validityEndTime = '',
    this.carNumb = '',
    this.loadType = 0,
    this.destination = '',
  });

  factory LogisticsAuthorizationRecordModel.fromJson(
    Map<String, dynamic> json,
  ) => _$LogisticsAuthorizationRecordModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$LogisticsAuthorizationRecordModelToJson(this);
}

/// 物流出入记录。
@JsonSerializable()
class LogisticsAccessRecordModel {
  @NullableStringSafeConverter()
  final String? id;

  @NullableStringSafeConverter()
  final String? reservationId;

  @StringSafeConverter()
  final String carNumb;

  @StringSafeConverter()
  final String destination;

  @StringSafeConverter()
  final String inDate;

  @StringSafeConverter()
  final String inDeviceName;

  @StringSafeConverter()
  final String inGoodsAmount;

  @StringSafeConverter()
  final String outGoodsAmount;

  @StringSafeConverter()
  final String transportAmount;

  @StringSafeConverter()
  final String outDate;

  @StringSafeConverter()
  final String outDeviceName;

  @StringSafeConverter()
  final String parkCheckTime;

  @StringSafeConverter()
  final String validityBeginTime;

  @StringSafeConverter()
  final String validityEndTime;

  @IntSafeConverter()
  final int loadType;

  const LogisticsAccessRecordModel({
    this.id,
    this.reservationId,
    this.carNumb = '',
    this.destination = '',
    this.inDate = '',
    this.inDeviceName = '',
    this.inGoodsAmount = '0',
    this.outGoodsAmount = '0',
    this.transportAmount = '0',
    this.outDate = '',
    this.outDeviceName = '',
    this.parkCheckTime = '',
    this.validityBeginTime = '',
    this.validityEndTime = '',
    this.loadType = 0,
  });

  factory LogisticsAccessRecordModel.fromJson(Map<String, dynamic> json) =>
      _$LogisticsAccessRecordModelFromJson(json);

  Map<String, dynamic> toJson() => _$LogisticsAccessRecordModelToJson(this);
}
