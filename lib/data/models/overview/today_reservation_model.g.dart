// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_reservation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodayReservationModel _$TodayReservationModelFromJson(
  Map<String, dynamic> json,
) => TodayReservationModel(
  personNum: json['personNum'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['personNum']),
  commonCarNum: json['commonCarNum'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['commonCarNum']),
  commonTruckNum: json['commonTruckNum'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['commonTruckNum']),
  hazardousCarNum: json['hazardousCarNum'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['hazardousCarNum']),
  hazardousWasteCarNum: json['hazardousWasteCarNum'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['hazardousWasteCarNum']),
  pendingApprovalNum: json['pendingApprovalNum'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['pendingApprovalNum']),
  submittedNum: json['submittedNum'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['submittedNum']),
  timeLine: json['timeLine'] == null
      ? const <TodayReservationTimelineItem>[]
      : TodayReservationModel._timeLineFromJson(json['timeLine']),
);

Map<String, dynamic> _$TodayReservationModelToJson(
  TodayReservationModel instance,
) => <String, dynamic>{
  'personNum': const IntSafeConverter().toJson(instance.personNum),
  'commonCarNum': const IntSafeConverter().toJson(instance.commonCarNum),
  'commonTruckNum': const IntSafeConverter().toJson(instance.commonTruckNum),
  'hazardousCarNum': const IntSafeConverter().toJson(instance.hazardousCarNum),
  'hazardousWasteCarNum': const IntSafeConverter().toJson(
    instance.hazardousWasteCarNum,
  ),
  'pendingApprovalNum': const IntSafeConverter().toJson(
    instance.pendingApprovalNum,
  ),
  'submittedNum': const IntSafeConverter().toJson(instance.submittedNum),
  'timeLine': TodayReservationModel._timeLineToJson(instance.timeLine),
};

TodayReservationTimelineData _$TodayReservationTimelineDataFromJson(
  Map<String, dynamic> json,
) => TodayReservationTimelineData(
  personNum: json['personNum'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['personNum']),
  commonCarNum: json['commonCarNum'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['commonCarNum']),
  commonTruckNum: json['commonTruckNum'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['commonTruckNum']),
  hazardousCarNum: json['hazardousCarNum'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['hazardousCarNum']),
  hazardousWasteCarNum: json['hazardousWasteCarNum'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['hazardousWasteCarNum']),
);

Map<String, dynamic> _$TodayReservationTimelineDataToJson(
  TodayReservationTimelineData instance,
) => <String, dynamic>{
  'personNum': const IntSafeConverter().toJson(instance.personNum),
  'commonCarNum': const IntSafeConverter().toJson(instance.commonCarNum),
  'commonTruckNum': const IntSafeConverter().toJson(instance.commonTruckNum),
  'hazardousCarNum': const IntSafeConverter().toJson(instance.hazardousCarNum),
  'hazardousWasteCarNum': const IntSafeConverter().toJson(
    instance.hazardousWasteCarNum,
  ),
};
