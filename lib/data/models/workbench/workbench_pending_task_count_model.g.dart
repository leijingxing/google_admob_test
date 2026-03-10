// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workbench_pending_task_count_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkbenchPendingTaskCountModel _$WorkbenchPendingTaskCountModelFromJson(
  Map<String, dynamic> json,
) => WorkbenchPendingTaskCountModel(
  reservationPendingCount: json['reservationPendingCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['reservationPendingCount']),
  whitePendingCount: json['whitePendingCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['whitePendingCount']),
  blackPendingCount: json['blackPendingCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['blackPendingCount']),
  securityCheckCount: json['securityCheckCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['securityCheckCount']),
  inspectionPendingCount: json['inspectionPendingCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['inspectionPendingCount']),
  hazardPendingCount: json['hazardPendingCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['hazardPendingCount']),
  exceptionPendingCount: json['exceptionPendingCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['exceptionPendingCount']),
  appealPendingCount: json['appealPendingCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['appealPendingCount']),
  warningUnDisposalCount: json['warningUnDisposalCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['warningUnDisposalCount']),
  alarmUnDisposalCount: json['alarmUnDisposalCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['alarmUnDisposalCount']),
);

Map<String, dynamic> _$WorkbenchPendingTaskCountModelToJson(
  WorkbenchPendingTaskCountModel instance,
) => <String, dynamic>{
  'reservationPendingCount': const IntSafeConverter().toJson(
    instance.reservationPendingCount,
  ),
  'whitePendingCount': const IntSafeConverter().toJson(
    instance.whitePendingCount,
  ),
  'blackPendingCount': const IntSafeConverter().toJson(
    instance.blackPendingCount,
  ),
  'securityCheckCount': const IntSafeConverter().toJson(
    instance.securityCheckCount,
  ),
  'inspectionPendingCount': const IntSafeConverter().toJson(
    instance.inspectionPendingCount,
  ),
  'hazardPendingCount': const IntSafeConverter().toJson(
    instance.hazardPendingCount,
  ),
  'exceptionPendingCount': const IntSafeConverter().toJson(
    instance.exceptionPendingCount,
  ),
  'appealPendingCount': const IntSafeConverter().toJson(
    instance.appealPendingCount,
  ),
  'warningUnDisposalCount': const IntSafeConverter().toJson(
    instance.warningUnDisposalCount,
  ),
  'alarmUnDisposalCount': const IntSafeConverter().toJson(
    instance.alarmUnDisposalCount,
  ),
};
