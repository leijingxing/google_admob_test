import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'today_reservation_model.g.dart';

/// 今日预约情况。
@JsonSerializable()
class TodayReservationModel {
  /// 人员数量。
  @IntSafeConverter()
  final int personNum;

  /// 普通车数量。
  @IntSafeConverter()
  final int commonCarNum;

  /// 普通货车数量。
  @IntSafeConverter()
  final int commonTruckNum;

  /// 危化车数量。
  @IntSafeConverter()
  final int hazardousCarNum;

  /// 危废车数量。
  @IntSafeConverter()
  final int hazardousWasteCarNum;

  /// 待审批数量。
  @IntSafeConverter()
  final int pendingApprovalNum;

  /// 已提交数量。
  @IntSafeConverter()
  final int submittedNum;

  /// 按小时统计的时间轴数据。
  @JsonKey(fromJson: _timeLineFromJson, toJson: _timeLineToJson)
  final List<TodayReservationTimelineItem> timeLine;

  const TodayReservationModel({
    this.personNum = 0,
    this.commonCarNum = 0,
    this.commonTruckNum = 0,
    this.hazardousCarNum = 0,
    this.hazardousWasteCarNum = 0,
    this.pendingApprovalNum = 0,
    this.submittedNum = 0,
    this.timeLine = const <TodayReservationTimelineItem>[],
  });

  factory TodayReservationModel.fromJson(Map<String, dynamic> json) =>
      _$TodayReservationModelFromJson(json);

  Map<String, dynamic> toJson() => _$TodayReservationModelToJson(this);

  static List<TodayReservationTimelineItem> _timeLineFromJson(Object? json) {
    if (json is! List) return const <TodayReservationTimelineItem>[];
    return json
        .map((item) => TodayReservationTimelineItem.fromJson(item))
        .toList();
  }

  static List<Map<String, dynamic>> _timeLineToJson(
    List<TodayReservationTimelineItem> items,
  ) {
    return items.map((item) => item.toJson()).toList();
  }
}

/// 今日预约时间轴单个小时的数据。
class TodayReservationTimelineItem {
  /// 小时，例如 00、13。
  final String hour;

  /// 当前小时的数据明细。
  final TodayReservationTimelineData data;

  const TodayReservationTimelineItem({required this.hour, required this.data});

  factory TodayReservationTimelineItem.fromJson(Object? json) {
    if (json is Map) {
      final map = Map<String, dynamic>.from(json);
      if (map.isNotEmpty) {
        final entry = map.entries.first;
        return TodayReservationTimelineItem(
          hour: entry.key,
          data: TodayReservationTimelineData.fromJson(
            entry.value is Map<String, dynamic>
                ? entry.value as Map<String, dynamic>
                : Map<String, dynamic>.from(entry.value as Map),
          ),
        );
      }
    }
    return const TodayReservationTimelineItem(
      hour: '00',
      data: TodayReservationTimelineData(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{hour: data.toJson()};
  }
}

/// 今日预约时间轴小时明细。
@JsonSerializable()
class TodayReservationTimelineData {
  /// 人员数量。
  @IntSafeConverter()
  final int personNum;

  /// 普通车数量。
  @IntSafeConverter()
  final int commonCarNum;

  /// 普通货车数量。
  @IntSafeConverter()
  final int commonTruckNum;

  /// 危化车数量。
  @IntSafeConverter()
  final int hazardousCarNum;

  /// 危废车数量。
  @IntSafeConverter()
  final int hazardousWasteCarNum;

  const TodayReservationTimelineData({
    this.personNum = 0,
    this.commonCarNum = 0,
    this.commonTruckNum = 0,
    this.hazardousCarNum = 0,
    this.hazardousWasteCarNum = 0,
  });

  factory TodayReservationTimelineData.fromJson(Map<String, dynamic> json) =>
      _$TodayReservationTimelineDataFromJson(json);

  Map<String, dynamic> toJson() => _$TodayReservationTimelineDataToJson(this);
}
