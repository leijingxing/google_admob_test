// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'risk_warning_disposal_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RiskWarningDisposalItemModel _$RiskWarningDisposalItemModelFromJson(
  Map<String, dynamic> json,
) => RiskWarningDisposalItemModel(
  id: const NullableStringSafeConverter().fromJson(json['id']),
  companyId: const NullableStringSafeConverter().fromJson(json['companyId']),
  companyCode: const NullableStringSafeConverter().fromJson(
    json['companyCode'],
  ),
  companyName: const NullableStringSafeConverter().fromJson(
    json['companyName'],
  ),
  title: const NullableStringSafeConverter().fromJson(json['title']),
  moduleType: const NullableStringSafeConverter().fromJson(json['moduleType']),
  moduleTypeName: const NullableStringSafeConverter().fromJson(
    json['moduleTypeName'],
  ),
  subModuleType: const NullableStringSafeConverter().fromJson(
    json['subModuleType'],
  ),
  subModuleTypeName: const NullableStringSafeConverter().fromJson(
    json['subModuleTypeName'],
  ),
  warningFileUrl: const NullableStringSafeConverter().fromJson(
    json['warningFileUrl'],
  ),
  carNum: const NullableStringSafeConverter().fromJson(json['carNum']),
  violationType: json['violationType'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['violationType']),
  deviceCode: const NullableStringSafeConverter().fromJson(json['deviceCode']),
  deviceName: const NullableStringSafeConverter().fromJson(json['deviceName']),
  position: const NullableStringSafeConverter().fromJson(json['position']),
  positionDescription: const NullableStringSafeConverter().fromJson(
    json['positionDescription'],
  ),
  warningLevel: json['warningLevel'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['warningLevel']),
  warningType: json['warningType'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['warningType']),
  warningStatus: json['warningStatus'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['warningStatus']),
  description: const NullableStringSafeConverter().fromJson(
    json['description'],
  ),
  warningStartTime: const NullableStringSafeConverter().fromJson(
    json['warningStartTime'],
  ),
  warningEndTime: const NullableStringSafeConverter().fromJson(
    json['warningEndTime'],
  ),
  relationId: const NullableStringSafeConverter().fromJson(json['relationId']),
  relationName: const NullableStringSafeConverter().fromJson(
    json['relationName'],
  ),
  remark: const NullableStringSafeConverter().fromJson(json['remark']),
  beViewed: json['beViewed'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['beViewed']),
  dispatcherFromByName: const NullableStringSafeConverter().fromJson(
    json['dispatcherFromByName'],
  ),
  dispatcherFromId: const NullableStringSafeConverter().fromJson(
    json['dispatcherFromId'],
  ),
  dispatcherToByName: const NullableStringSafeConverter().fromJson(
    json['dispatcherToByName'],
  ),
  dispatcherToById: const NullableStringSafeConverter().fromJson(
    json['dispatcherToById'],
  ),
  dispatcherToContent: const NullableStringSafeConverter().fromJson(
    json['dispatcherToContent'],
  ),
  dispatcherToStatus: json['dispatcherToStatus'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['dispatcherToStatus']),
  dispatcherToDate: const NullableStringSafeConverter().fromJson(
    json['dispatcherToDate'],
  ),
  disposalByName: const NullableStringSafeConverter().fromJson(
    json['disposalByName'],
  ),
  disposalById: const NullableStringSafeConverter().fromJson(
    json['disposalById'],
  ),
  disposalStatus: json['disposalStatus'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['disposalStatus']),
  disposalCategory: json['disposalCategory'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['disposalCategory']),
  disposalResult: const NullableStringSafeConverter().fromJson(
    json['disposalResult'],
  ),
  disposalFiles: const NullableStringListSafeConverter().fromJson(
    json['disposalFiles'],
  ),
  disposalDate: const NullableStringSafeConverter().fromJson(
    json['disposalDate'],
  ),
  disposalDeadLine: json['disposalDeadLine'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['disposalDeadLine']),
  disposalMethod: const NullableStringSafeConverter().fromJson(
    json['disposalMethod'],
  ),
  disposalType: json['disposalType'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['disposalType']),
  disposalVia: const NullableStringSafeConverter().fromJson(
    json['disposalVia'],
  ),
  disposalReasonAnalyze: const NullableStringSafeConverter().fromJson(
    json['disposalReasonAnalyze'],
  ),
  cancelWarningByName: const NullableStringSafeConverter().fromJson(
    json['cancelWarningByName'],
  ),
  cancelWarningById: const NullableStringSafeConverter().fromJson(
    json['cancelWarningById'],
  ),
  cancelWarningResult: const NullableStringSafeConverter().fromJson(
    json['cancelWarningResult'],
  ),
  cancelWarningFiles: const NullableStringListSafeConverter().fromJson(
    json['cancelWarningFiles'],
  ),
  cancelWarningDate: const NullableStringSafeConverter().fromJson(
    json['cancelWarningDate'],
  ),
  disposeRemind: json['disposeRemind'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['disposeRemind']),
  giveWarningById: const NullableStringSafeConverter().fromJson(
    json['giveWarningById'],
  ),
  giveWarningByName: const NullableStringSafeConverter().fromJson(
    json['giveWarningByName'],
  ),
  giveWarningResult: const NullableStringSafeConverter().fromJson(
    json['giveWarningResult'],
  ),
  giveWarningFiles: const NullableStringListSafeConverter().fromJson(
    json['giveWarningFiles'],
  ),
  giveWarningDate: const NullableStringSafeConverter().fromJson(
    json['giveWarningDate'],
  ),
  actualDisposalByName: const NullableStringSafeConverter().fromJson(
    json['actualDisposalByName'],
  ),
  actualDisposalById: const NullableStringSafeConverter().fromJson(
    json['actualDisposalById'],
  ),
  actualDisposalPhone: const NullableStringSafeConverter().fromJson(
    json['actualDisposalPhone'],
  ),
  reportLeaderName: const NullableStringSafeConverter().fromJson(
    json['reportLeaderName'],
  ),
  reportLeaderId: const NullableStringSafeConverter().fromJson(
    json['reportLeaderId'],
  ),
  warningSource: json['warningSource'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['warningSource']),
  targetValue: const NullableStringSafeConverter().fromJson(
    json['targetValue'],
  ),
  status: json['status'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['status']),
  appealType: json['appealType'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['appealType']),
  abnormalDesc: const NullableStringSafeConverter().fromJson(
    json['abnormalDesc'],
  ),
  appealDesc: const NullableStringSafeConverter().fromJson(json['appealDesc']),
  reply: const NullableStringSafeConverter().fromJson(json['reply']),
);

Map<String, dynamic> _$RiskWarningDisposalItemModelToJson(
  RiskWarningDisposalItemModel instance,
) => <String, dynamic>{
  'id': const NullableStringSafeConverter().toJson(instance.id),
  'companyId': const NullableStringSafeConverter().toJson(instance.companyId),
  'companyCode': const NullableStringSafeConverter().toJson(
    instance.companyCode,
  ),
  'companyName': const NullableStringSafeConverter().toJson(
    instance.companyName,
  ),
  'title': const NullableStringSafeConverter().toJson(instance.title),
  'moduleType': const NullableStringSafeConverter().toJson(instance.moduleType),
  'moduleTypeName': const NullableStringSafeConverter().toJson(
    instance.moduleTypeName,
  ),
  'subModuleType': const NullableStringSafeConverter().toJson(
    instance.subModuleType,
  ),
  'subModuleTypeName': const NullableStringSafeConverter().toJson(
    instance.subModuleTypeName,
  ),
  'warningFileUrl': const NullableStringSafeConverter().toJson(
    instance.warningFileUrl,
  ),
  'carNum': const NullableStringSafeConverter().toJson(instance.carNum),
  'violationType': const IntSafeConverter().toJson(instance.violationType),
  'deviceCode': const NullableStringSafeConverter().toJson(instance.deviceCode),
  'deviceName': const NullableStringSafeConverter().toJson(instance.deviceName),
  'position': const NullableStringSafeConverter().toJson(instance.position),
  'positionDescription': const NullableStringSafeConverter().toJson(
    instance.positionDescription,
  ),
  'warningLevel': const IntSafeConverter().toJson(instance.warningLevel),
  'warningType': const IntSafeConverter().toJson(instance.warningType),
  'warningStatus': const IntSafeConverter().toJson(instance.warningStatus),
  'description': const NullableStringSafeConverter().toJson(
    instance.description,
  ),
  'warningStartTime': const NullableStringSafeConverter().toJson(
    instance.warningStartTime,
  ),
  'warningEndTime': const NullableStringSafeConverter().toJson(
    instance.warningEndTime,
  ),
  'relationId': const NullableStringSafeConverter().toJson(instance.relationId),
  'relationName': const NullableStringSafeConverter().toJson(
    instance.relationName,
  ),
  'remark': const NullableStringSafeConverter().toJson(instance.remark),
  'beViewed': const IntSafeConverter().toJson(instance.beViewed),
  'dispatcherFromByName': const NullableStringSafeConverter().toJson(
    instance.dispatcherFromByName,
  ),
  'dispatcherFromId': const NullableStringSafeConverter().toJson(
    instance.dispatcherFromId,
  ),
  'dispatcherToByName': const NullableStringSafeConverter().toJson(
    instance.dispatcherToByName,
  ),
  'dispatcherToById': const NullableStringSafeConverter().toJson(
    instance.dispatcherToById,
  ),
  'dispatcherToContent': const NullableStringSafeConverter().toJson(
    instance.dispatcherToContent,
  ),
  'dispatcherToStatus': const IntSafeConverter().toJson(
    instance.dispatcherToStatus,
  ),
  'dispatcherToDate': const NullableStringSafeConverter().toJson(
    instance.dispatcherToDate,
  ),
  'disposalByName': const NullableStringSafeConverter().toJson(
    instance.disposalByName,
  ),
  'disposalById': const NullableStringSafeConverter().toJson(
    instance.disposalById,
  ),
  'disposalStatus': const IntSafeConverter().toJson(instance.disposalStatus),
  'disposalCategory': const IntSafeConverter().toJson(
    instance.disposalCategory,
  ),
  'disposalResult': const NullableStringSafeConverter().toJson(
    instance.disposalResult,
  ),
  'disposalFiles': const NullableStringListSafeConverter().toJson(
    instance.disposalFiles,
  ),
  'disposalDate': const NullableStringSafeConverter().toJson(
    instance.disposalDate,
  ),
  'disposalDeadLine': const IntSafeConverter().toJson(
    instance.disposalDeadLine,
  ),
  'disposalMethod': const NullableStringSafeConverter().toJson(
    instance.disposalMethod,
  ),
  'disposalType': const IntSafeConverter().toJson(instance.disposalType),
  'disposalVia': const NullableStringSafeConverter().toJson(
    instance.disposalVia,
  ),
  'disposalReasonAnalyze': const NullableStringSafeConverter().toJson(
    instance.disposalReasonAnalyze,
  ),
  'cancelWarningByName': const NullableStringSafeConverter().toJson(
    instance.cancelWarningByName,
  ),
  'cancelWarningById': const NullableStringSafeConverter().toJson(
    instance.cancelWarningById,
  ),
  'cancelWarningResult': const NullableStringSafeConverter().toJson(
    instance.cancelWarningResult,
  ),
  'cancelWarningFiles': const NullableStringListSafeConverter().toJson(
    instance.cancelWarningFiles,
  ),
  'cancelWarningDate': const NullableStringSafeConverter().toJson(
    instance.cancelWarningDate,
  ),
  'disposeRemind': const IntSafeConverter().toJson(instance.disposeRemind),
  'giveWarningById': const NullableStringSafeConverter().toJson(
    instance.giveWarningById,
  ),
  'giveWarningByName': const NullableStringSafeConverter().toJson(
    instance.giveWarningByName,
  ),
  'giveWarningResult': const NullableStringSafeConverter().toJson(
    instance.giveWarningResult,
  ),
  'giveWarningFiles': const NullableStringListSafeConverter().toJson(
    instance.giveWarningFiles,
  ),
  'giveWarningDate': const NullableStringSafeConverter().toJson(
    instance.giveWarningDate,
  ),
  'actualDisposalByName': const NullableStringSafeConverter().toJson(
    instance.actualDisposalByName,
  ),
  'actualDisposalById': const NullableStringSafeConverter().toJson(
    instance.actualDisposalById,
  ),
  'actualDisposalPhone': const NullableStringSafeConverter().toJson(
    instance.actualDisposalPhone,
  ),
  'reportLeaderName': const NullableStringSafeConverter().toJson(
    instance.reportLeaderName,
  ),
  'reportLeaderId': const NullableStringSafeConverter().toJson(
    instance.reportLeaderId,
  ),
  'warningSource': const IntSafeConverter().toJson(instance.warningSource),
  'targetValue': const NullableStringSafeConverter().toJson(
    instance.targetValue,
  ),
  'status': const IntSafeConverter().toJson(instance.status),
  'appealType': const IntSafeConverter().toJson(instance.appealType),
  'abnormalDesc': const NullableStringSafeConverter().toJson(
    instance.abnormalDesc,
  ),
  'appealDesc': const NullableStringSafeConverter().toJson(instance.appealDesc),
  'reply': const NullableStringSafeConverter().toJson(instance.reply),
};
