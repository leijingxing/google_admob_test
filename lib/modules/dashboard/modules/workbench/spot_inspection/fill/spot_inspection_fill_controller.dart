import 'package:get/get.dart';

import '../../../../../../core/components/toast/toast_widget.dart';
import '../../../../../../data/models/workbench/spot_inspection_check_item_model.dart';
import '../../../../../../data/models/workbench/spot_inspection_item_model.dart';
import '../../../../../../data/repository/workbench_repository.dart';

/// 抽检填写控制器。
class SpotInspectionFillController extends GetxController {
  final WorkbenchRepository _repository = WorkbenchRepository();

  late final SpotInspectionItemModel item;
  bool loading = false;
  bool submitting = false;
  Map<String, dynamic> detail = const <String, dynamic>{};
  List<InspectionEditableItem> items = const <InspectionEditableItem>[];
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

  Future<void> loadData() async {
    final id = item.id ?? '';
    final reservationId = item.reservationId ?? '';
    if (id.isEmpty && reservationId.isEmpty) return;

    loading = true;
    update();

    if (id.isNotEmpty) {
      final detailResult = await _repository.getSpotInspectionDetail(id: id);
      detailResult.when(
        success: (data) {
          detail = data;
          overallResult = _toResult(data['securityCheckResults'], fallback: 1);
        },
        failure: (error) => AppToast.showError(error.message),
      );
    }

    final checkListResult = await _repository.getSpotInspectionCheckList(
      reservationId: reservationId.isNotEmpty
          ? reservationId
          : (detail['reservationId'] ?? '').toString(),
    );
    checkListResult.when(
      success: (data) {
        items = data.map((e) => InspectionEditableItem.fromModel(e)).toList();
      },
      failure: (error) => AppToast.showError(error.message),
    );

    if (items.isEmpty) {
      items = <InspectionEditableItem>[InspectionEditableItem.empty(index: 1)];
    }

    loading = false;
    update();
  }

  String get checkInfoText => _firstNonEmpty(
    detail['checkInfo'],
    detail['checkTemplateName'],
    item.checkTemplateName,
  );
  String get carNumbText => _firstNonEmpty(detail['carNumb'], item.carNumb);
  String get templateText =>
      _firstNonEmpty(detail['checkTemplateName'], item.checkTemplateName);
  String get timeText => _firstNonEmpty(detail['securityCheckTime']);
  String get checkerText => _firstNonEmpty(detail['createBy']);

  void updateItemPass(int index, bool pass) {
    items[index] = items[index].copyWith(pass: pass);
    update();
  }

  void updateItemRemark(int index, String value) {
    items[index] = items[index].copyWith(remark: value);
  }

  void updateItemPhotos(int index, List<String> values) {
    items[index] = items[index].copyWith(checkFile: values.join(','));
    update();
  }

  void updateOverallResult(int value) {
    overallResult = value;
    update();
  }

  Future<void> submit() async {
    final id = item.id ?? _firstNonEmpty(detail['id']);
    if (id == '--') {
      AppToast.showError('缺少抽检记录ID');
      return;
    }

    submitting = true;
    update();

    final payload = <String, dynamic>{
      ...detail,
      'id': id,
      'reservationId': _firstNonEmpty(
        detail['reservationId'],
        item.reservationId,
      ),
      'carNumb': _firstNonEmpty(detail['carNumb'], item.carNumb),
      'checkTemplateName': templateText == '--' ? '' : templateText,
      'securityCheckResults': overallResult,
      'securityCheckTime': _firstNonEmpty(
        detail['securityCheckTime'],
        _nowText(),
      ),
      'securityCheckList': items.map((e) => e.toPayload()).toList(),
    }..removeWhere((key, value) => value == null || value == '--');

    final result = await _repository.submitSpotInspection(payload: payload);
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

  int _toResult(Object? value, {required int fallback}) {
    final text = (value ?? '').toString().trim();
    if (text == '1') return 1;
    if (text == '0') return 0;
    return fallback;
  }

  String _firstNonEmpty([Object? a, Object? b, Object? c]) {
    for (final value in <Object?>[a, b, c]) {
      final text = value?.toString().trim() ?? '';
      if (text.isNotEmpty && text.toLowerCase() != 'null') return text;
    }
    return '--';
  }

  String _nowText() {
    final now = DateTime.now();
    return '${now.year}-${_pad2(now.month)}-${_pad2(now.day)} ${_pad2(now.hour)}:${_pad2(now.minute)}:${_pad2(now.second)}';
  }

  String _pad2(int value) => value.toString().padLeft(2, '0');
}

class InspectionEditableItem {
  const InspectionEditableItem({
    required this.id,
    required this.checkItemId,
    required this.checkItemName,
    required this.checkDescribe,
    required this.pass,
    required this.remark,
    required this.checkFile,
  });

  final String id;
  final String checkItemId;
  final String checkItemName;
  final String checkDescribe;
  final bool pass;
  final String remark;
  final String checkFile;

  factory InspectionEditableItem.fromModel(SpotInspectionCheckItemModel model) {
    final statusText = (model.checkStatus ?? model.isConformity ?? '').trim();
    return InspectionEditableItem(
      id: model.id ?? '',
      checkItemId: model.checkItemId ?? '',
      checkItemName: model.checkItemName ?? '--',
      checkDescribe: model.checkDescribe ?? '--',
      pass: statusText != '0',
      remark: model.remark ?? '',
      checkFile: model.checkFile ?? '',
    );
  }

  factory InspectionEditableItem.empty({required int index}) {
    return InspectionEditableItem(
      id: '',
      checkItemId: '',
      checkItemName: '$index 检查项',
      checkDescribe: '--',
      pass: true,
      remark: '',
      checkFile: '',
    );
  }

  InspectionEditableItem copyWith({
    bool? pass,
    String? remark,
    String? checkFile,
  }) {
    return InspectionEditableItem(
      id: id,
      checkItemId: checkItemId,
      checkItemName: checkItemName,
      checkDescribe: checkDescribe,
      pass: pass ?? this.pass,
      remark: remark ?? this.remark,
      checkFile: checkFile ?? this.checkFile,
    );
  }

  Map<String, dynamic> toPayload() {
    return {
      'id': id,
      'checkItemId': checkItemId,
      'checkItemName': checkItemName,
      'checkDescribe': checkDescribe,
      'checkStatus': pass ? 1 : 0,
      'isConformity': pass ? 1 : 0,
      'remark': remark,
      'checkFile': checkFile,
    }..removeWhere(
      (key, value) => value == null || (value is String && value.isEmpty),
    );
  }
}
