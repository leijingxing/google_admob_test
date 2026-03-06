import 'spot_inspection_check_item_model.dart';

/// 自检填写页使用的可编辑检查项模型。
class SpotInspectionEditableItemModel {
  const SpotInspectionEditableItemModel({
    required this.id,
    required this.companyId,
    required this.companyName,
    required this.securityTemplateId,
    required this.checkItemId,
    required this.checkItemName,
    required this.checkDescribe,
    required this.checkMethod,
    required this.pass,
    required this.remark,
    required this.checkFile,
  });

  /// 检查项记录ID。
  final String id;

  /// 企业ID。
  final String companyId;

  /// 企业名称。
  final String companyName;

  /// 安全检查模板ID。
  final String securityTemplateId;

  /// 模板检查项ID。
  final String checkItemId;

  /// 检查项名称。
  final String checkItemName;

  /// 检查说明。
  final String checkDescribe;

  /// 检查方式：`1-拍照`，`2-录像`。
  final String checkMethod;

  /// 当前检查项是否合格。
  final bool pass;

  /// 检查备注。
  final String remark;

  /// 已上传文件ID，多个值使用逗号分隔。
  final String checkFile;

  factory SpotInspectionEditableItemModel.fromModel(
    SpotInspectionCheckItemModel model,
  ) {
    return SpotInspectionEditableItemModel(
      id: model.id ?? '',
      companyId: model.companyId ?? '',
      companyName: model.companyName ?? '',
      securityTemplateId: model.securityTemplateId ?? '',
      checkItemId: model.checkItemId ?? model.id ?? '',
      checkItemName: model.checkItemName ?? model.checkItem ?? '--',
      checkDescribe: model.checkDescribe ?? '--',
      checkMethod: model.checkMethod ?? '1',
      pass: (model.checkResult ?? model.checkStatus ?? model.isConformity ?? '1') !=
          '0',
      remark: model.remark ?? model.remarks ?? '',
      checkFile: model.checkFile ?? '',
    );
  }

  factory SpotInspectionEditableItemModel.empty({required int index}) {
    return SpotInspectionEditableItemModel(
      id: '',
      companyId: '',
      companyName: '',
      securityTemplateId: '',
      checkItemId: '',
      checkItemName: '$index 检查项',
      checkDescribe: '--',
      checkMethod: '1',
      pass: true,
      remark: '',
      checkFile: '',
    );
  }

  SpotInspectionEditableItemModel copyWith({
    bool? pass,
    String? remark,
    String? checkFile,
  }) {
    return SpotInspectionEditableItemModel(
      id: id,
      companyId: companyId,
      companyName: companyName,
      securityTemplateId: securityTemplateId,
      checkItemId: checkItemId,
      checkItemName: checkItemName,
      checkDescribe: checkDescribe,
      checkMethod: checkMethod,
      pass: pass ?? this.pass,
      remark: remark ?? this.remark,
      checkFile: checkFile ?? this.checkFile,
    );
  }

  /// 转成小程序同款自检提交结构。
  Map<String, dynamic> toSubmitPayload({
    required String reservationId,
    required String checkIdentity,
    String? companyId,
    String? companyName,
  }) {
    return {
      // 'id': id,
      'companyId': companyId,
      'companyName': companyName,
      'reservationId': reservationId,
      'checkItemId': checkItemId.isNotEmpty ? checkItemId : id,
      'checkItemName': checkItemName,
      'checkDescribe': checkDescribe,
      'checkMethod': checkMethod,
      'checkFile': checkFile,
      'checkResult': pass ? '1' : '0',
      'checkIdentity': checkIdentity,
      'remarks': remark,
    }..removeWhere(
      (key, value) => value == null || (value is String && value.isEmpty),
    );
  }
}
