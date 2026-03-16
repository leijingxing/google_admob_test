// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_base_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyBaseInfoModel _$CompanyBaseInfoModelFromJson(
  Map<String, dynamic> json,
) => CompanyBaseInfoModel(
  id: const NullableStringSafeConverter().fromJson(json['id']),
  parkCode: const NullableStringSafeConverter().fromJson(json['parkCode']),
  companyCode: const NullableStringSafeConverter().fromJson(
    json['companyCode'],
  ),
  parentCode: const NullableStringSafeConverter().fromJson(json['parentCode']),
  companyName: const NullableStringSafeConverter().fromJson(
    json['companyName'],
  ),
  companyShortName: const NullableStringSafeConverter().fromJson(
    json['companyShortName'],
  ),
  areaCode: const NullableStringSafeConverter().fromJson(json['areaCode']),
  keyIndustryCode: const NullableStringSafeConverter().fromJson(
    json['keyIndustryCode'],
  ),
  addressRegistry: const NullableStringSafeConverter().fromJson(
    json['addressRegistry'],
  ),
  addressWorksite: const NullableStringSafeConverter().fromJson(
    json['addressWorksite'],
  ),
  latitude: json['latitude'] == null
      ? 0
      : const DoubleSafeConverter().fromJson(json['latitude']),
  longitude: json['longitude'] == null
      ? 0
      : const DoubleSafeConverter().fromJson(json['longitude']),
  height: json['height'] == null
      ? 0
      : const DoubleSafeConverter().fromJson(json['height']),
  representativePerson: const NullableStringSafeConverter().fromJson(
    json['representativePerson'],
  ),
  responsiblePerson: const NullableStringSafeConverter().fromJson(
    json['responsiblePerson'],
  ),
  responsibleMobile: const NullableStringSafeConverter().fromJson(
    json['responsibleMobile'],
  ),
  responsiblePhone: const NullableStringSafeConverter().fromJson(
    json['responsiblePhone'],
  ),
  safetyResponsiblePerson: const NullableStringSafeConverter().fromJson(
    json['safetyResponsiblePerson'],
  ),
  safetyResponsibleMobile: const NullableStringSafeConverter().fromJson(
    json['safetyResponsibleMobile'],
  ),
  safetyResponsiblePhone: const NullableStringSafeConverter().fromJson(
    json['safetyResponsiblePhone'],
  ),
  dutyPhone: const NullableStringSafeConverter().fromJson(json['dutyPhone']),
  postCode: const NullableStringSafeConverter().fromJson(json['postCode']),
  establishDate: const NullableStringSafeConverter().fromJson(
    json['establishDate'],
  ),
  webSite: const NullableStringSafeConverter().fromJson(json['webSite']),
  companyScale: const NullableStringSafeConverter().fromJson(
    json['companyScale'],
  ),
  companyType: const NullableStringSafeConverter().fromJson(
    json['companyType'],
  ),
  businessType: const NullableStringSafeConverter().fromJson(
    json['businessType'],
  ),
  importType: const NullableStringSafeConverter().fromJson(json['importType']),
  isImport: const NullableStringSafeConverter().fromJson(json['isImport']),
  economicType: const NullableStringSafeConverter().fromJson(
    json['economicType'],
  ),
  industryCategoryId: const NullableStringSafeConverter().fromJson(
    json['industryCategoryId'],
  ),
  industryClassId: const NullableStringSafeConverter().fromJson(
    json['industryClassId'],
  ),
  socialCreditCode: const NullableStringSafeConverter().fromJson(
    json['socialCreditCode'],
  ),
  businessScope: const NullableStringSafeConverter().fromJson(
    json['businessScope'],
  ),
  safetyStandardGrad: const NullableStringSafeConverter().fromJson(
    json['safetyStandardGrad'],
  ),
  safetyLicenseNo: const NullableStringSafeConverter().fromJson(
    json['safetyLicenseNo'],
  ),
  safetyLicenseStart: const NullableStringSafeConverter().fromJson(
    json['safetyLicenseStart'],
  ),
  safetyLicenseEnd: const NullableStringSafeConverter().fromJson(
    json['safetyLicenseEnd'],
  ),
  peopleEmployee: json['peopleEmployee'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['peopleEmployee']),
  peopleFullSafety: json['peopleFullSafety'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['peopleFullSafety']),
  peopleCertifiedSafety: json['peopleCertifiedSafety'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['peopleCertifiedSafety']),
  peoplePractitioner: json['peoplePractitioner'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['peoplePractitioner']),
  peopleToxic: json['peopleToxic'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['peopleToxic']),
  peopleHazard: json['peopleHazard'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['peopleHazard']),
  peopleOperation: json['peopleOperation'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['peopleOperation']),
  auditStatus: const NullableStringSafeConverter().fromJson(
    json['auditStatus'],
  ),
  inIndustrialPark: const NullableStringSafeConverter().fromJson(
    json['inIndustrialPark'],
  ),
  industrialParkName: const NullableStringSafeConverter().fromJson(
    json['industrialParkName'],
  ),
  companyStatus: const NullableStringSafeConverter().fromJson(
    json['companyStatus'],
  ),
  factoryArea: json['factoryArea'] == null
      ? 0
      : const DoubleSafeConverter().fromJson(json['factoryArea']),
  rangeGeometryData: const NullableStringSafeConverter().fromJson(
    json['rangeGeometryData'],
  ),
  organizationType: const NullableStringSafeConverter().fromJson(
    json['organizationType'],
  ),
  order: json['order'] == null
      ? 0
      : const IntSafeConverter().fromJson(json['order']),
  deleted: const NullableStringSafeConverter().fromJson(json['deleted']),
  createById: const NullableStringSafeConverter().fromJson(json['createById']),
  createBy: const NullableStringSafeConverter().fromJson(json['createBy']),
  createDate: const NullableStringSafeConverter().fromJson(json['createDate']),
  updateById: const NullableStringSafeConverter().fromJson(json['updateById']),
  updateBy: const NullableStringSafeConverter().fromJson(json['updateBy']),
  updateDate: const NullableStringSafeConverter().fromJson(json['updateDate']),
  tenantCode: const NullableStringSafeConverter().fromJson(json['tenantCode']),
  parentId: const NullableStringSafeConverter().fromJson(json['parentId']),
  capUrl: const NullableStringSafeConverter().fromJson(json['capUrl']),
);

Map<String, dynamic> _$CompanyBaseInfoModelToJson(
  CompanyBaseInfoModel instance,
) => <String, dynamic>{
  'id': const NullableStringSafeConverter().toJson(instance.id),
  'parkCode': const NullableStringSafeConverter().toJson(instance.parkCode),
  'companyCode': const NullableStringSafeConverter().toJson(
    instance.companyCode,
  ),
  'parentCode': const NullableStringSafeConverter().toJson(instance.parentCode),
  'companyName': const NullableStringSafeConverter().toJson(
    instance.companyName,
  ),
  'companyShortName': const NullableStringSafeConverter().toJson(
    instance.companyShortName,
  ),
  'areaCode': const NullableStringSafeConverter().toJson(instance.areaCode),
  'keyIndustryCode': const NullableStringSafeConverter().toJson(
    instance.keyIndustryCode,
  ),
  'addressRegistry': const NullableStringSafeConverter().toJson(
    instance.addressRegistry,
  ),
  'addressWorksite': const NullableStringSafeConverter().toJson(
    instance.addressWorksite,
  ),
  'latitude': const DoubleSafeConverter().toJson(instance.latitude),
  'longitude': const DoubleSafeConverter().toJson(instance.longitude),
  'height': const DoubleSafeConverter().toJson(instance.height),
  'representativePerson': const NullableStringSafeConverter().toJson(
    instance.representativePerson,
  ),
  'responsiblePerson': const NullableStringSafeConverter().toJson(
    instance.responsiblePerson,
  ),
  'responsibleMobile': const NullableStringSafeConverter().toJson(
    instance.responsibleMobile,
  ),
  'responsiblePhone': const NullableStringSafeConverter().toJson(
    instance.responsiblePhone,
  ),
  'safetyResponsiblePerson': const NullableStringSafeConverter().toJson(
    instance.safetyResponsiblePerson,
  ),
  'safetyResponsibleMobile': const NullableStringSafeConverter().toJson(
    instance.safetyResponsibleMobile,
  ),
  'safetyResponsiblePhone': const NullableStringSafeConverter().toJson(
    instance.safetyResponsiblePhone,
  ),
  'dutyPhone': const NullableStringSafeConverter().toJson(instance.dutyPhone),
  'postCode': const NullableStringSafeConverter().toJson(instance.postCode),
  'establishDate': const NullableStringSafeConverter().toJson(
    instance.establishDate,
  ),
  'webSite': const NullableStringSafeConverter().toJson(instance.webSite),
  'companyScale': const NullableStringSafeConverter().toJson(
    instance.companyScale,
  ),
  'companyType': const NullableStringSafeConverter().toJson(
    instance.companyType,
  ),
  'businessType': const NullableStringSafeConverter().toJson(
    instance.businessType,
  ),
  'importType': const NullableStringSafeConverter().toJson(instance.importType),
  'isImport': const NullableStringSafeConverter().toJson(instance.isImport),
  'economicType': const NullableStringSafeConverter().toJson(
    instance.economicType,
  ),
  'industryCategoryId': const NullableStringSafeConverter().toJson(
    instance.industryCategoryId,
  ),
  'industryClassId': const NullableStringSafeConverter().toJson(
    instance.industryClassId,
  ),
  'socialCreditCode': const NullableStringSafeConverter().toJson(
    instance.socialCreditCode,
  ),
  'businessScope': const NullableStringSafeConverter().toJson(
    instance.businessScope,
  ),
  'safetyStandardGrad': const NullableStringSafeConverter().toJson(
    instance.safetyStandardGrad,
  ),
  'safetyLicenseNo': const NullableStringSafeConverter().toJson(
    instance.safetyLicenseNo,
  ),
  'safetyLicenseStart': const NullableStringSafeConverter().toJson(
    instance.safetyLicenseStart,
  ),
  'safetyLicenseEnd': const NullableStringSafeConverter().toJson(
    instance.safetyLicenseEnd,
  ),
  'peopleEmployee': const IntSafeConverter().toJson(instance.peopleEmployee),
  'peopleFullSafety': const IntSafeConverter().toJson(
    instance.peopleFullSafety,
  ),
  'peopleCertifiedSafety': const IntSafeConverter().toJson(
    instance.peopleCertifiedSafety,
  ),
  'peoplePractitioner': const IntSafeConverter().toJson(
    instance.peoplePractitioner,
  ),
  'peopleToxic': const IntSafeConverter().toJson(instance.peopleToxic),
  'peopleHazard': const IntSafeConverter().toJson(instance.peopleHazard),
  'peopleOperation': const IntSafeConverter().toJson(instance.peopleOperation),
  'auditStatus': const NullableStringSafeConverter().toJson(
    instance.auditStatus,
  ),
  'inIndustrialPark': const NullableStringSafeConverter().toJson(
    instance.inIndustrialPark,
  ),
  'industrialParkName': const NullableStringSafeConverter().toJson(
    instance.industrialParkName,
  ),
  'companyStatus': const NullableStringSafeConverter().toJson(
    instance.companyStatus,
  ),
  'factoryArea': const DoubleSafeConverter().toJson(instance.factoryArea),
  'rangeGeometryData': const NullableStringSafeConverter().toJson(
    instance.rangeGeometryData,
  ),
  'organizationType': const NullableStringSafeConverter().toJson(
    instance.organizationType,
  ),
  'order': const IntSafeConverter().toJson(instance.order),
  'deleted': const NullableStringSafeConverter().toJson(instance.deleted),
  'createById': const NullableStringSafeConverter().toJson(instance.createById),
  'createBy': const NullableStringSafeConverter().toJson(instance.createBy),
  'createDate': const NullableStringSafeConverter().toJson(instance.createDate),
  'updateById': const NullableStringSafeConverter().toJson(instance.updateById),
  'updateBy': const NullableStringSafeConverter().toJson(instance.updateBy),
  'updateDate': const NullableStringSafeConverter().toJson(instance.updateDate),
  'tenantCode': const NullableStringSafeConverter().toJson(instance.tenantCode),
  'parentId': const NullableStringSafeConverter().toJson(instance.parentId),
  'capUrl': const NullableStringSafeConverter().toJson(instance.capUrl),
};
