import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'risk_warning_disposal_item_model.g.dart';

/// 报警/预警处置列表项模型。
@JsonSerializable()
class RiskWarningDisposalItemModel {
  @NullableStringSafeConverter()
  final String? id;

  @NullableStringSafeConverter()
  final String? companyId;

  @NullableStringSafeConverter()
  final String? companyCode;

  @NullableStringSafeConverter()
  final String? companyName;

  @NullableStringSafeConverter()
  final String? title;

  @NullableStringSafeConverter()
  final String? moduleType;

  @NullableStringSafeConverter()
  final String? moduleTypeName;

  @NullableStringSafeConverter()
  final String? subModuleType;

  @NullableStringSafeConverter()
  final String? subModuleTypeName;

  @NullableStringSafeConverter()
  final String? warningFileUrl;

  @NullableStringSafeConverter()
  final String? carNum;

  @IntSafeConverter()
  final int violationType;

  @NullableStringSafeConverter()
  final String? deviceCode;

  @NullableStringSafeConverter()
  final String? deviceName;

  @NullableStringSafeConverter()
  final String? position;

  @NullableStringSafeConverter()
  final String? positionDescription;

  @IntSafeConverter()
  final int warningLevel;

  @IntSafeConverter()
  final int warningType;

  @IntSafeConverter()
  final int warningStatus;

  @NullableStringSafeConverter()
  final String? description;

  @NullableStringSafeConverter()
  final String? warningStartTime;

  @NullableStringSafeConverter()
  final String? warningEndTime;

  @NullableStringSafeConverter()
  final String? relationId;

  @NullableStringSafeConverter()
  final String? relationName;

  @NullableStringSafeConverter()
  final String? remark;

  @IntSafeConverter()
  final int beViewed;

  @NullableStringSafeConverter()
  final String? dispatcherFromByName;

  @NullableStringSafeConverter()
  final String? dispatcherFromId;

  @NullableStringSafeConverter()
  final String? dispatcherToByName;

  @NullableStringSafeConverter()
  final String? dispatcherToById;

  @NullableStringSafeConverter()
  final String? dispatcherToContent;

  @IntSafeConverter()
  final int dispatcherToStatus;

  @NullableStringSafeConverter()
  final String? dispatcherToDate;

  @NullableStringSafeConverter()
  final String? disposalByName;

  @NullableStringSafeConverter()
  final String? disposalById;

  @IntSafeConverter()
  final int disposalStatus;

  @IntSafeConverter()
  final int disposalCategory;

  @NullableStringSafeConverter()
  final String? disposalResult;

  @NullableStringListSafeConverter()
  final List<String>? disposalFiles;

  @NullableStringSafeConverter()
  final String? disposalDate;

  @IntSafeConverter()
  final int disposalDeadLine;

  @NullableStringSafeConverter()
  final String? disposalMethod;

  @IntSafeConverter()
  final int disposalType;

  @NullableStringSafeConverter()
  final String? disposalVia;

  @NullableStringSafeConverter()
  final String? disposalReasonAnalyze;

  @NullableStringSafeConverter()
  final String? cancelWarningByName;

  @NullableStringSafeConverter()
  final String? cancelWarningById;

  @NullableStringSafeConverter()
  final String? cancelWarningResult;

  @NullableStringListSafeConverter()
  final List<String>? cancelWarningFiles;

  @NullableStringSafeConverter()
  final String? cancelWarningDate;

  @IntSafeConverter()
  final int disposeRemind;

  @NullableStringSafeConverter()
  final String? giveWarningById;

  @NullableStringSafeConverter()
  final String? giveWarningByName;

  @NullableStringSafeConverter()
  final String? giveWarningResult;

  @NullableStringListSafeConverter()
  final List<String>? giveWarningFiles;

  @NullableStringSafeConverter()
  final String? giveWarningDate;

  @NullableStringSafeConverter()
  final String? actualDisposalByName;

  @NullableStringSafeConverter()
  final String? actualDisposalById;

  @NullableStringSafeConverter()
  final String? actualDisposalPhone;

  @NullableStringSafeConverter()
  final String? reportLeaderName;

  @NullableStringSafeConverter()
  final String? reportLeaderId;

  @IntSafeConverter()
  final int warningSource;

  @NullableStringSafeConverter()
  final String? targetValue;

  @IntSafeConverter()
  final int status;

  @IntSafeConverter()
  final int appealType;

  @NullableStringSafeConverter()
  final String? abnormalDesc;

  @NullableStringSafeConverter()
  final String? appealDesc;

  @NullableStringSafeConverter()
  final String? reply;

  const RiskWarningDisposalItemModel({
    this.id,
    this.companyId,
    this.companyCode,
    this.companyName,
    this.title,
    this.moduleType,
    this.moduleTypeName,
    this.subModuleType,
    this.subModuleTypeName,
    this.warningFileUrl,
    this.carNum,
    this.violationType = 0,
    this.deviceCode,
    this.deviceName,
    this.position,
    this.positionDescription,
    this.warningLevel = 0,
    this.warningType = 0,
    this.warningStatus = 0,
    this.description,
    this.warningStartTime,
    this.warningEndTime,
    this.relationId,
    this.relationName,
    this.remark,
    this.beViewed = 0,
    this.dispatcherFromByName,
    this.dispatcherFromId,
    this.dispatcherToByName,
    this.dispatcherToById,
    this.dispatcherToContent,
    this.dispatcherToStatus = 0,
    this.dispatcherToDate,
    this.disposalByName,
    this.disposalById,
    this.disposalStatus = 0,
    this.disposalCategory = 0,
    this.disposalResult,
    this.disposalFiles,
    this.disposalDate,
    this.disposalDeadLine = 0,
    this.disposalMethod,
    this.disposalType = 0,
    this.disposalVia,
    this.disposalReasonAnalyze,
    this.cancelWarningByName,
    this.cancelWarningById,
    this.cancelWarningResult,
    this.cancelWarningFiles,
    this.cancelWarningDate,
    this.disposeRemind = 0,
    this.giveWarningById,
    this.giveWarningByName,
    this.giveWarningResult,
    this.giveWarningFiles,
    this.giveWarningDate,
    this.actualDisposalByName,
    this.actualDisposalById,
    this.actualDisposalPhone,
    this.reportLeaderName,
    this.reportLeaderId,
    this.warningSource = 0,
    this.targetValue,
    this.status = 0,
    this.appealType = 0,
    this.abnormalDesc,
    this.appealDesc,
    this.reply,
  });

  factory RiskWarningDisposalItemModel.fromJson(Map<String, dynamic> json) =>
      _$RiskWarningDisposalItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$RiskWarningDisposalItemModelToJson(this);
}
