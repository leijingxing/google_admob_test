// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_black_white_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApprovalBlackWhiteListModel _$ApprovalBlackWhiteListModelFromJson(
  Map<String, dynamic> json,
) => ApprovalBlackWhiteListModel(
  companyApprovalCount: json['companyApprovalCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['companyApprovalCount']),
  parkApprovalCount: json['parkApprovalCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['parkApprovalCount']),
  personBlackListCount: json['personBlackListCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['personBlackListCount']),
  carBlackListCount: json['carBlackListCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['carBlackListCount']),
  personWhiteListCount: json['personWhiteListCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['personWhiteListCount']),
  carWhiteListCount: json['carWhiteListCount'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['carWhiteListCount']),
);

Map<String, dynamic> _$ApprovalBlackWhiteListModelToJson(
  ApprovalBlackWhiteListModel instance,
) => <String, dynamic>{
  'companyApprovalCount': const IntSafeConverter().toJson(
    instance.companyApprovalCount,
  ),
  'parkApprovalCount': const IntSafeConverter().toJson(
    instance.parkApprovalCount,
  ),
  'personBlackListCount': const IntSafeConverter().toJson(
    instance.personBlackListCount,
  ),
  'carBlackListCount': const IntSafeConverter().toJson(
    instance.carBlackListCount,
  ),
  'personWhiteListCount': const IntSafeConverter().toJson(
    instance.personWhiteListCount,
  ),
  'carWhiteListCount': const IntSafeConverter().toJson(
    instance.carWhiteListCount,
  ),
};
