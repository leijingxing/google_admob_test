// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_overview_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyOverviewModel _$CompanyOverviewModelFromJson(
  Map<String, dynamic> json,
) => CompanyOverviewModel(
  id: const NullableStringSafeConverter().fromJson(json['id']),
  companyName: json['companyName'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['companyName']),
  responsiblePerson: json['responsiblePerson'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['responsiblePerson']),
  responsibleMobile: json['responsibleMobile'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['responsibleMobile']),
  responsiblePhone: json['responsiblePhone'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['responsiblePhone']),
  approvalPendingCount: json['approvalPendingCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['approvalPendingCount']),
  approvalApprovedCount: json['approvalApprovedCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['approvalApprovedCount']),
  whiteListCount: json['whiteListCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['whiteListCount']),
  blackListCount: json['blackListCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['blackListCount']),
  onDutyPersonName: json['onDutyPersonName'] == null
      ? ''
      : const StringSafeConverter().fromJson(json['onDutyPersonName']),
);

Map<String, dynamic> _$CompanyOverviewModelToJson(
  CompanyOverviewModel instance,
) => <String, dynamic>{
  'id': const NullableStringSafeConverter().toJson(instance.id),
  'companyName': const StringSafeConverter().toJson(instance.companyName),
  'responsiblePerson': const StringSafeConverter().toJson(
    instance.responsiblePerson,
  ),
  'responsibleMobile': const StringSafeConverter().toJson(
    instance.responsibleMobile,
  ),
  'responsiblePhone': const StringSafeConverter().toJson(
    instance.responsiblePhone,
  ),
  'approvalPendingCount': const IntSafeConverter().toJson(
    instance.approvalPendingCount,
  ),
  'approvalApprovedCount': const IntSafeConverter().toJson(
    instance.approvalApprovedCount,
  ),
  'whiteListCount': const IntSafeConverter().toJson(instance.whiteListCount),
  'blackListCount': const IntSafeConverter().toJson(instance.blackListCount),
  'onDutyPersonName': const StringSafeConverter().toJson(
    instance.onDutyPersonName,
  ),
};
