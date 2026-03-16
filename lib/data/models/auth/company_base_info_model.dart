import 'package:json_annotation/json_annotation.dart';

import '../json_converters.dart';

part 'company_base_info_model.g.dart';

/// 企业基础信息分页项模型。
@JsonSerializable()
class CompanyBaseInfoModel {
  /// 编号。
  @NullableStringSafeConverter()
  final String? id;

  /// 园区编码。
  @NullableStringSafeConverter()
  final String? parkCode;

  /// 企业编码。
  @NullableStringSafeConverter()
  final String? companyCode;

  /// 父级企业编码。
  @NullableStringSafeConverter()
  final String? parentCode;

  /// 企业名称。
  @NullableStringSafeConverter()
  final String? companyName;

  /// 企业简称。
  @NullableStringSafeConverter()
  final String? companyShortName;

  /// 行政区域编码。
  @NullableStringSafeConverter()
  final String? areaCode;

  /// 重点行业编码。
  @NullableStringSafeConverter()
  final String? keyIndustryCode;

  /// 工商注册地址。
  @NullableStringSafeConverter()
  final String? addressRegistry;

  /// 生产场所地址。
  @NullableStringSafeConverter()
  final String? addressWorksite;

  /// 纬度。
  @DoubleSafeConverter()
  final double latitude;

  /// 经度。
  @DoubleSafeConverter()
  final double longitude;

  /// 高度。
  @DoubleSafeConverter()
  final double height;

  /// 法定代表人。
  @NullableStringSafeConverter()
  final String? representativePerson;

  /// 企业负责人。
  @NullableStringSafeConverter()
  final String? responsiblePerson;

  /// 企业负责人手机。
  @NullableStringSafeConverter()
  final String? responsibleMobile;

  /// 企业负责人电话。
  @NullableStringSafeConverter()
  final String? responsiblePhone;

  /// 安全负责人。
  @NullableStringSafeConverter()
  final String? safetyResponsiblePerson;

  /// 安全负责人手机。
  @NullableStringSafeConverter()
  final String? safetyResponsibleMobile;

  /// 安全负责人电话。
  @NullableStringSafeConverter()
  final String? safetyResponsiblePhone;

  /// 安全值班电话。
  @NullableStringSafeConverter()
  final String? dutyPhone;

  /// 邮政编码。
  @NullableStringSafeConverter()
  final String? postCode;

  /// 成立日期。
  @NullableStringSafeConverter()
  final String? establishDate;

  /// 企业网址。
  @NullableStringSafeConverter()
  final String? webSite;

  /// 企业规模：1-大；2-中；3-小；4-微。
  @NullableStringSafeConverter()
  final String? companyScale;

  /// 企业类型：01-生产；02-经营；03-使用；04-化工；05-医药；06-其他。
  @NullableStringSafeConverter()
  final String? companyType;

  /// 经营二级分类。
  @NullableStringSafeConverter()
  final String? businessType;

  /// 进口二级分类。
  @NullableStringSafeConverter()
  final String? importType;

  /// 涉及进口：1-是；0-否。
  @NullableStringSafeConverter()
  final String? isImport;

  /// 经济类型。
  @NullableStringSafeConverter()
  final String? economicType;

  /// 行业门类 ID。
  @NullableStringSafeConverter()
  final String? industryCategoryId;

  /// 行业大类 ID。
  @NullableStringSafeConverter()
  final String? industryClassId;

  /// 统一社会信用代码。
  @NullableStringSafeConverter()
  final String? socialCreditCode;

  /// 营业执照经营范围。
  @NullableStringSafeConverter()
  final String? businessScope;

  /// 安全生产标准化等级：1-一级；2-二级；3-三级。
  @NullableStringSafeConverter()
  final String? safetyStandardGrad;

  /// 安全生产许可证编号。
  @NullableStringSafeConverter()
  final String? safetyLicenseNo;

  /// 安全生产许可证有效期起。
  @NullableStringSafeConverter()
  final String? safetyLicenseStart;

  /// 安全生产许可证有效期止。
  @NullableStringSafeConverter()
  final String? safetyLicenseEnd;

  /// 职工人数。
  @IntSafeConverter()
  final int peopleEmployee;

  /// 专职安全员人数。
  @IntSafeConverter()
  final int peopleFullSafety;

  /// 注册安全工程师人数。
  @IntSafeConverter()
  final int peopleCertifiedSafety;

  /// 从业人员人数。
  @IntSafeConverter()
  final int peoplePractitioner;

  /// 剧毒化学品作业人员人数。
  @IntSafeConverter()
  final int peopleToxic;

  /// 危险化学品作业人员人数。
  @IntSafeConverter()
  final int peopleHazard;

  /// 特殊作业人员人数。
  @IntSafeConverter()
  final int peopleOperation;

  /// 审核状态；1：已审核，2：未审核，3：待审核。
  @NullableStringSafeConverter()
  final String? auditStatus;

  /// 是否在化工园区内：0-否；1-是。
  @NullableStringSafeConverter()
  final String? inIndustrialPark;

  /// 所属化工园区名称。
  @NullableStringSafeConverter()
  final String? industrialParkName;

  /// 企业状态：0-正常生产；1-未投产；2-试生产；9-长期停产。
  @NullableStringSafeConverter()
  final String? companyStatus;

  /// 厂区面积。
  @DoubleSafeConverter()
  final double factoryArea;

  /// 边界地理信息。
  @NullableStringSafeConverter()
  final String? rangeGeometryData;

  /// 组织类型：0-企业；1-管理机构；2-园区。
  @NullableStringSafeConverter()
  final String? organizationType;

  /// 排序。
  @IntSafeConverter()
  final int order;

  /// 删除标志：0-正常；1-已删除。
  @NullableStringSafeConverter()
  final String? deleted;

  /// 创建人 ID。
  @NullableStringSafeConverter()
  final String? createById;

  /// 创建人。
  @NullableStringSafeConverter()
  final String? createBy;

  /// 创建时间。
  @NullableStringSafeConverter()
  final String? createDate;

  /// 最后修改人 ID。
  @NullableStringSafeConverter()
  final String? updateById;

  /// 最后修改人。
  @NullableStringSafeConverter()
  final String? updateBy;

  /// 最后修改时间。
  @NullableStringSafeConverter()
  final String? updateDate;

  /// 租户 CODE。
  @NullableStringSafeConverter()
  final String? tenantCode;

  /// 父级 ID。
  @NullableStringSafeConverter()
  final String? parentId;

  /// 帽贴定位服务 URL。
  @NullableStringSafeConverter()
  final String? capUrl;

  const CompanyBaseInfoModel({
    this.id,
    this.parkCode,
    this.companyCode,
    this.parentCode,
    this.companyName,
    this.companyShortName,
    this.areaCode,
    this.keyIndustryCode,
    this.addressRegistry,
    this.addressWorksite,
    this.latitude = 0,
    this.longitude = 0,
    this.height = 0,
    this.representativePerson,
    this.responsiblePerson,
    this.responsibleMobile,
    this.responsiblePhone,
    this.safetyResponsiblePerson,
    this.safetyResponsibleMobile,
    this.safetyResponsiblePhone,
    this.dutyPhone,
    this.postCode,
    this.establishDate,
    this.webSite,
    this.companyScale,
    this.companyType,
    this.businessType,
    this.importType,
    this.isImport,
    this.economicType,
    this.industryCategoryId,
    this.industryClassId,
    this.socialCreditCode,
    this.businessScope,
    this.safetyStandardGrad,
    this.safetyLicenseNo,
    this.safetyLicenseStart,
    this.safetyLicenseEnd,
    this.peopleEmployee = 0,
    this.peopleFullSafety = 0,
    this.peopleCertifiedSafety = 0,
    this.peoplePractitioner = 0,
    this.peopleToxic = 0,
    this.peopleHazard = 0,
    this.peopleOperation = 0,
    this.auditStatus,
    this.inIndustrialPark,
    this.industrialParkName,
    this.companyStatus,
    this.factoryArea = 0,
    this.rangeGeometryData,
    this.organizationType,
    this.order = 0,
    this.deleted,
    this.createById,
    this.createBy,
    this.createDate,
    this.updateById,
    this.updateBy,
    this.updateDate,
    this.tenantCode,
    this.parentId,
    this.capUrl,
  });

  /// 从 JSON 创建实例。
  factory CompanyBaseInfoModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyBaseInfoModelFromJson(json);

  /// 转为 JSON。
  Map<String, dynamic> toJson() => _$CompanyBaseInfoModelToJson(this);
}
