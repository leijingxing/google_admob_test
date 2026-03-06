import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'personnel_query_models.g.dart';

/// 人员查询顶部统计。
@JsonSerializable()
class PersonnelCountModel {
  @IntSafeConverter()
  final int totalCount;

  @IntSafeConverter()
  final int blackListCount;

  @IntSafeConverter()
  final int whiteListCount;

  @IntSafeConverter()
  final int reservationCount;

  const PersonnelCountModel({
    this.totalCount = 0,
    this.blackListCount = 0,
    this.whiteListCount = 0,
    this.reservationCount = 0,
  });

  factory PersonnelCountModel.fromJson(Map<String, dynamic> json) =>
      _$PersonnelCountModelFromJson(json);

  Map<String, dynamic> toJson() => _$PersonnelCountModelToJson(this);
}

/// 人员综合查询主列表项。
@JsonSerializable()
class PersonnelComprehensiveItemModel {
  @NullableStringSafeConverter()
  final String? id;

  @StringSafeConverter()
  final String name;

  @StringSafeConverter()
  final String phone;

  @StringSafeConverter()
  final String idCard;

  @StringSafeConverter()
  final String unit;

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

  const PersonnelComprehensiveItemModel({
    this.id,
    this.name = '',
    this.phone = '',
    this.idCard = '',
    this.unit = '',
    this.validityStatus = 0,
    this.accessCount = 0,
    this.inCount = 0,
    this.outCount = 0,
    this.violationCount = 0,
    this.blackCount = 0,
  });

  factory PersonnelComprehensiveItemModel.fromJson(Map<String, dynamic> json) =>
      _$PersonnelComprehensiveItemModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PersonnelComprehensiveItemModelToJson(this);
}
