import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'company_overview_model.g.dart';

/// 企业情况概览条目。
@JsonSerializable()
class CompanyOverviewModel {
  /// 企业 ID。
  @NullableStringSafeConverter()
  final String? id;

  /// 企业名称。
  @StringSafeConverter()
  final String companyName;

  /// 企业负责人。
  @StringSafeConverter()
  final String responsiblePerson;

  /// 企业负责人手机。
  @StringSafeConverter()
  final String responsibleMobile;

  /// 企业负责人电话。
  @StringSafeConverter()
  final String responsiblePhone;

  /// 待审批数量。
  @IntSafeConverter()
  final int approvalPendingCount;

  /// 已审批数量。
  @IntSafeConverter()
  final int approvalApprovedCount;

  /// 白名单数量。
  @IntSafeConverter()
  final int whiteListCount;

  /// 黑名单数量。
  @IntSafeConverter()
  final int blackListCount;

  /// 在岗员工。
  @StringSafeConverter()
  final String onDutyPersonName;

  const CompanyOverviewModel({
    this.id,
    this.companyName = '',
    this.responsiblePerson = '',
    this.responsibleMobile = '',
    this.responsiblePhone = '',
    this.approvalPendingCount = 0,
    this.approvalApprovedCount = 0,
    this.whiteListCount = 0,
    this.blackListCount = 0,
    this.onDutyPersonName = '',
  });

  factory CompanyOverviewModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyOverviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyOverviewModelToJson(this);
}
