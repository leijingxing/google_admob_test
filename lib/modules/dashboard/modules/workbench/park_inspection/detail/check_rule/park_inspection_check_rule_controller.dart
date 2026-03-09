import 'package:get/get.dart';

import '../../../../../../../data/models/workbench/park_inspection_task_record_model.dart';
import '../park_inspection_detail_controller.dart';

class ParkInspectionCheckRuleController extends GetxController {
  late final ParkInspectionDetailController detailController;
  late final ParkInspectionTaskRecordModel record;

  bool loading = false;
  bool submitting = false;
  List<ParkInspectionRuleDraft> drafts = const <ParkInspectionRuleDraft>[];

  @override
  Future<void> onInit() async {
    super.onInit();
    detailController = Get.find<ParkInspectionDetailController>();
    final args = Get.arguments;
    record = args is ParkInspectionTaskRecordModel
        ? args
        : const ParkInspectionTaskRecordModel();
    await loadDrafts();
  }

  Future<void> loadDrafts() async {
    loading = true;
    update();
    drafts = await detailController.buildRuleDrafts(record: record);
    loading = false;
    update();
  }

  void updateDraft(int index, ParkInspectionRuleDraft next) {
    drafts[index] = next;
    update();
  }

  Future<void> submit() async {
    if (submitting) return;
    submitting = true;
    update();
    final success = await detailController.submitCheckRules(
      record: record,
      drafts: drafts,
    );
    submitting = false;
    update();
    if (success) {
      Get.back<bool>(result: true);
    }
  }

  String checkMethodText(String value) {
    switch (value) {
      case 'VISUAL':
        return '目视检查';
      case 'PHOTO':
        return '拍照检查';
      case 'VIDEO':
        return '录制视频';
      default:
        return '--';
    }
  }
}
