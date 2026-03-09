import 'package:get/get.dart';

import '../../../../../../../data/models/workbench/park_inspection_record_detail_item_model.dart';
import '../../../../../../../data/models/workbench/park_inspection_task_record_model.dart';
import '../park_inspection_detail_controller.dart';

class ParkInspectionRecordDetailController extends GetxController {
  late final ParkInspectionDetailController detailController;
  late final ParkInspectionTaskRecordModel record;

  bool loading = false;
  List<ParkInspectionRecordDetailItemModel> details =
      const <ParkInspectionRecordDetailItemModel>[];

  @override
  Future<void> onInit() async {
    super.onInit();
    detailController = Get.find<ParkInspectionDetailController>();
    final args = Get.arguments;
    record = args is ParkInspectionTaskRecordModel
        ? args
        : const ParkInspectionTaskRecordModel();
    await loadDetails();
  }

  Future<void> loadDetails() async {
    final recordId = (record.id ?? '').trim();
    if (recordId.isEmpty) return;
    loading = true;
    update();
    details = await detailController.loadRecordDetails(recordId: recordId);
    loading = false;
    update();
  }

  String resultText(String? value) {
    switch ((value ?? '').trim()) {
      case 'PASS':
        return '通过';
      case 'UNINVOLVED':
        return '不涉及';
      default:
        return '不通过';
    }
  }
}
