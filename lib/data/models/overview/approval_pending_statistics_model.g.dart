// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_pending_statistics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApprovalPendingStatisticsModel _$ApprovalPendingStatisticsModelFromJson(
  Map<String, dynamic> json,
) => ApprovalPendingStatisticsModel(
  companyPendingCount: json['companyPendingCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['companyPendingCount']),
  parkPendingCount: json['parkPendingCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['parkPendingCount']),
);

Map<String, dynamic> _$ApprovalPendingStatisticsModelToJson(
  ApprovalPendingStatisticsModel instance,
) => <String, dynamic>{
  'companyPendingCount': const IntSafeConverter().toJson(
    instance.companyPendingCount,
  ),
  'parkPendingCount': const IntSafeConverter().toJson(
    instance.parkPendingCount,
  ),
};
