import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'park_inner_flow_statistics_model.g.dart';

/// 园区内人车流统计条目。
@JsonSerializable()
class ParkInnerFlowStatisticsModel {
  /// 时间轴。
  @StringSafeConverter()
  final String timeAxis;

  /// 入的数量。
  @IntSafeConverter()
  final int inCount;

  /// 出的数量。
  @IntSafeConverter()
  final int outCount;

  const ParkInnerFlowStatisticsModel({
    this.timeAxis = '',
    this.inCount = 0,
    this.outCount = 0,
  });

  factory ParkInnerFlowStatisticsModel.fromJson(Map<String, dynamic> json) =>
      _$ParkInnerFlowStatisticsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ParkInnerFlowStatisticsModelToJson(this);
}
