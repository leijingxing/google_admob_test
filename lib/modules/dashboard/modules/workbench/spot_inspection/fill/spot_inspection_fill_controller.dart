import 'package:get/get.dart';

import '../../../../../../core/components/toast/toast_widget.dart';
import '../../../../../../data/models/workbench/spot_inspection_check_item_model.dart';
import '../../../../../../data/models/workbench/spot_inspection_editable_item_model.dart';
import '../../../../../../data/models/workbench/spot_inspection_item_model.dart';
import '../../../../../../data/repository/workbench_repository.dart';

/// 抽检填写控制器。
///
/// 负责：
/// 1. 拉取待抽检详情
/// 2. 拉取待抽检检查项列表
/// 3. 维护上传后的本地编辑态
/// 4. 调用抽检提交接口
class SpotInspectionFillController extends GetxController {
  final WorkbenchRepository _repository = WorkbenchRepository();

  /// 工作台列表传入的预约/抽检基础信息。
  late final SpotInspectionItemModel item;

  /// 页面首屏加载态。
  bool loading = false;

  /// 提交按钮加载态。
  bool submitting = false;

  /// 页面上用于展示和编辑的检查项集合。
  List<SpotInspectionEditableItemModel> items =
      const <SpotInspectionEditableItemModel>[];

  /// 抽检详情原始数据，用于补齐公司、模板等提交字段。
  Map<String, dynamic> detail = const <String, dynamic>{};

  /// 总抽检结果：`1-合格`，`0-不合格`。
  int overallResult = 1;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    item = args is SpotInspectionItemModel
        ? args
        : const SpotInspectionItemModel();
    loadData();
  }

  /// 加载抽检详情和检查项数据。
  Future<void> loadData() async {
    final reservationId = item.reservationId ?? '';
    if (reservationId.isEmpty) {
      AppToast.showError('缺少预约ID');
      return;
    }

    loading = true;
    update();

    final id = item.id ?? '';
    if (id.isNotEmpty) {
      final detailResult = await _repository.getSpotInspectionDetail(id: id);
      detailResult.when(
        success: (data) {
          detail = data;
          overallResult = _toInt(
            data['securityCheckResults'] ?? item.securityCheckResults,
            fallback: 1,
          );
        },
        failure: (error) => AppToast.showError(error.message),
      );
    } else {
      overallResult = _toInt(item.securityCheckResults, fallback: 1);
    }

    final checkListResult = await _repository.getWaitingInspectorCheckItemList(
      reservationId: reservationId,
    );
    checkListResult.when(
      success: (data) {
        items = data
            .map((e) => SpotInspectionEditableItemModel.fromModel(e))
            .toList();
      },
      failure: (error) => AppToast.showError(error.message),
    );

    if (items.isEmpty) {
      items = <SpotInspectionEditableItemModel>[
        SpotInspectionEditableItemModel.empty(index: 1),
      ];
    }

    loading = false;
    update();
  }

  String get checkInfoText => _firstNonEmpty(
    detail['checkInfo'],
    item.checkTemplateName,
    item.goodsName,
    item.goodsTypeName,
  );
  String get carNumbText => _firstNonEmpty(detail['carNumb'], item.carNumb);
  String get templateText =>
      _firstNonEmpty(detail['checkTemplateName'], item.checkTemplateName);
  String get timeText => _firstNonEmpty(
    detail['securityCheckTime'],
    item.securityCheckTime,
    item.reservationTime,
  );

  /// 更新某个检查项的合格状态。
  void updateItemPass(int index, bool pass) {
    items[index] = items[index].copyWith(pass: pass);
    update();
  }

  /// 更新某个检查项的备注。
  void updateItemRemark(int index, String value) {
    items[index] = items[index].copyWith(remark: value);
  }

  /// 更新某个检查项的附件上传结果。
  void updateItemPhotos(int index, List<String> values) {
    items[index] = items[index].copyWith(checkFile: values.join(','));
    update();
  }

  /// 获取检查项详情，用于说明区域点击后展示完整内容。
  Future<SpotInspectionCheckItemModel?> getCheckItemDetail(String id) async {
    final checkItemId = id.trim();
    if (checkItemId.isEmpty) {
      AppToast.showWarning('缺少检查项ID');
      return null;
    }

    final result = await _repository.getCheckItemDetail(id: checkItemId);
    return result.when(
      success: (data) => data,
      failure: (error) {
        AppToast.showError(error.message);
        return null;
      },
    );
  }

  /// 更新整体抽检结论。
  void updateOverallResult(int value) {
    overallResult = value;
    update();
  }

  /// 提交抽检结果。
  Future<void> submit() async {
    final reservationId = item.reservationId ?? '';
    if (reservationId.isEmpty) {
      AppToast.showError('缺少预约ID');
      return;
    }
    final hasEmptyPhotos = items.any((e) => e.checkFile.trim().isEmpty);
    if (hasEmptyPhotos) {
      AppToast.showWarning('请完成所有检查项照片上传');
      return;
    }

    submitting = true;
    update();

    final payload = <String, dynamic>{
      'securityCheckListDTOList': items
          .map(
            (e) => e.toSubmitPayload(
              reservationId: reservationId,
              checkIdentity: '1',
              companyId: _readText(detail['companyId']) ?? e.companyId,
              companyName: _readText(detail['companyName']) ?? e.companyName,
            ),
          )
          .toList(),
      'securityCheckResultDTO':
          <String, dynamic>{
            'id': _readText(detail['id']),
            'companyId': _readText(detail['companyId']) ?? _firstItemCompanyId,
            'companyName':
                _readText(detail['companyName']) ?? _firstItemCompanyName,
            'reservationId': reservationId,
            'checkTemplateId': _firstNonEmpty(
              detail['checkTemplateId'],
              _firstItemSecurityTemplateId,
              item.checkTemplateId,
            ),
            'checkTemplateName': _firstNonEmpty(
              detail['checkTemplateName'],
              item.checkTemplateName,
            ),
            'securityCheckResults': overallResult.toString(),
            'securityCheckTime': _nowText(),
          }..removeWhere(
            (key, value) => value == null || (value is String && value.isEmpty),
          ),
    };

    final result = await _repository.submitSelfCheckList(payload: payload);
    submitting = false;
    update();

    result.when(
      success: (_) {
        AppToast.showSuccess('提交成功');
        Get.back<bool>(result: true);
      },
      failure: (error) => AppToast.showError(error.message),
    );
  }

  String _firstNonEmpty([Object? a, Object? b, Object? c, Object? d]) {
    for (final value in <Object?>[a, b, c, d]) {
      final text = value?.toString().trim() ?? '';
      if (text.isNotEmpty && text.toLowerCase() != 'null') return text;
    }
    return '--';
  }

  String? _readText(Object? value) {
    final text = value?.toString().trim() ?? '';
    if (text.isEmpty || text.toLowerCase() == 'null') return null;
    return text;
  }

  int _toInt(Object? value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse((value ?? '').toString()) ?? fallback;
  }

  String _nowText() {
    final now = DateTime.now();
    return '${now.year}-${_pad2(now.month)}-${_pad2(now.day)} ${_pad2(now.hour)}:${_pad2(now.minute)}:${_pad2(now.second)}';
  }

  String _pad2(int value) => value.toString().padLeft(2, '0');

  String? get _firstItemCompanyId =>
      items.isEmpty ? null : _readText(items.first.companyId);

  String? get _firstItemCompanyName =>
      items.isEmpty ? null : _readText(items.first.companyName);

  String? get _firstItemSecurityTemplateId =>
      items.isEmpty ? null : _readText(items.first.securityTemplateId);
}
