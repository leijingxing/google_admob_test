import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'overview_models.g.dart';

/// 园内统计条目。
@JsonSerializable()
class ParkStatisticsModel {
  /// 类型：1-人员，2-普通车，3-危化车，4-危废车，5-货车。
  @IntSafeConverter()
  final int type;

  /// 当前在园数量。
  @IntSafeConverter()
  final int currentInParkCount;

  /// 入园数。
  @IntSafeConverter()
  final int inParkCount;

  /// 出园数。
  @IntSafeConverter()
  final int outParkCount;

  /// 入园次数。
  @IntSafeConverter()
  final int inCount;

  /// 出园次数。
  @IntSafeConverter()
  final int outCount;

  /// 入园货物数量。
  @DoubleSafeConverter()
  final double inGoodsAmount;

  /// 出园货物数量。
  @DoubleSafeConverter()
  final double outGoodsAmount;

  /// 累计入园货物数量。
  @DoubleSafeConverter()
  final double totalInGoodsAmount;

  /// 累计出园货物数量。
  @DoubleSafeConverter()
  final double totalOutGoodsAmount;

  /// 种类数。
  @IntSafeConverter()
  final int typeCount;

  const ParkStatisticsModel({
    this.type = 0,
    this.currentInParkCount = 0,
    this.inParkCount = 0,
    this.outParkCount = 0,
    this.inCount = 0,
    this.outCount = 0,
    this.inGoodsAmount = 0,
    this.outGoodsAmount = 0,
    this.totalInGoodsAmount = 0,
    this.totalOutGoodsAmount = 0,
    this.typeCount = 0,
  });

  factory ParkStatisticsModel.fromJson(Map<String, dynamic> json) =>
      _$ParkStatisticsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ParkStatisticsModelToJson(this);
}
