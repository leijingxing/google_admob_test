import 'package:get/get.dart';

import '../../../../../../core/components/toast/toast_widget.dart';
import '../../../../../../data/models/workbench/spot_inspection_check_item_model.dart';
import '../../../../../../data/models/workbench/spot_inspection_item_model.dart';
import '../../../../../../data/repository/workbench_repository.dart';

/// 抽检详情控制器。
class SpotInspectionDetailController extends GetxController {
  final WorkbenchRepository _repository = WorkbenchRepository();

  late final SpotInspectionItemModel item;
  bool loading = false;
  Map<String, dynamic> detail = const <String, dynamic>{};
  List<SpotInspectionCheckItemModel> items =
      const <SpotInspectionCheckItemModel>[];

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
        success: (data) => detail = data,
        failure: (error) => AppToast.showError(error.message),
      );
    }

    final result = await _repository.getSpotInspectionCheckList(
      reservationId: reservationId.isNotEmpty
          ? reservationId
          : (detail['reservationId'] ?? '').toString(),
    );
    result.when(
      success: (data) => items = data,
      failure: (error) => AppToast.showError(error.message),
    );

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
  String get timeText =>
      _firstNonEmpty(detail['securityCheckTime'], item.securityCheckTime);
  String get checkerText => _firstNonEmpty(detail['createBy'], item.createBy);
  int get overallResult => _toInt(
    detail['securityCheckResults'] ?? item.securityCheckResults,
    fallback: 1,
  );

  String resultText(int value) => value == 1 ? '通过' : '不通过';
  String itemResultText(SpotInspectionCheckItemModel model) {
    final value = _toInt(model.checkStatus ?? model.isConformity, fallback: 1);
    return value == 1 ? '是' : '否';
  }

  int _toInt(Object? value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse((value ?? '').toString()) ?? fallback;
  }

  String _firstNonEmpty([Object? a, Object? b, Object? c]) {
    for (final value in <Object?>[a, b, c]) {
      final text = value?.toString().trim() ?? '';
      if (text.isNotEmpty && text.toLowerCase() != 'null') return text;
    }
    return '--';
  }
}
