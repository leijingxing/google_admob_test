import 'package:get/get.dart';

import '../../../../../../core/components/toast/toast_widget.dart';
import '../../../../../../data/models/workbench/risk_warning_disposal_item_model.dart';
import '../../../../../../data/repository/workbench_repository.dart';

/// 预警详情控制器。
class WarningDisposalDetailController extends GetxController {
  final WorkbenchRepository _repository = WorkbenchRepository();

  late final RiskWarningDisposalItemModel item;
  bool loading = false;
  RiskWarningDisposalItemModel? detail;

  RiskWarningDisposalItemModel get source => detail ?? item;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    item = args is RiskWarningDisposalItemModel
        ? args
        : const RiskWarningDisposalItemModel();
    loadDetail();
  }

  Future<void> loadDetail() async {
    final id = item.id ?? '';
    if (id.isEmpty) return;
    loading = true;
    update();

    final result = await _repository.getRiskWarningDisposalDetail(id: id);
    result.when(
      success: (data) => detail = data,
      failure: (error) => AppToast.showError(error.message),
    );

    loading = false;
    update();
  }

  String display(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? '--' : text;
  }

  String statusText() => source.warningStatus == 1 ? '已销警' : '持续中';

  String warningLevelText() {
    switch (source.warningLevel) {
      case 1:
        return '红色';
      case 2:
        return '橙色';
      case 3:
        return '黄色';
      case 4:
        return '蓝色';
      case 0:
        return '无等级';
      default:
        return source.warningLevel <= 0 ? '--' : '等级${source.warningLevel}';
    }
  }
}
