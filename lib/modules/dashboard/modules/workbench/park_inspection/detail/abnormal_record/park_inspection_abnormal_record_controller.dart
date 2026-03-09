import 'package:get/get.dart';

import '../../../../../../../data/models/workbench/inspection_abnormal_item_model.dart';
import '../../../../../../../data/models/workbench/park_inspection_task_record_model.dart';
import '../park_inspection_detail_controller.dart';

class ParkInspectionAbnormalRecordController extends GetxController {
  late final ParkInspectionDetailController detailController;
  late final ParkInspectionTaskRecordModel record;

  bool loading = false;
  List<InspectionAbnormalItemModel> abnormals =
      const <InspectionAbnormalItemModel>[];

  @override
  void onInit() {
    super.onInit();
    detailController = Get.find<ParkInspectionDetailController>();
    final args = Get.arguments;
    record = args is ParkInspectionTaskRecordModel
        ? args
        : const ParkInspectionTaskRecordModel();
    loadData();
  }

  Future<void> loadData() async {
    loading = true;
    update();
    abnormals = await detailController.loadAbnormals(
      recordId: (record.id ?? '').trim(),
    );
    loading = false;
    update();
  }

  String abnormalStatusText(String? value) {
    switch ((value ?? '').trim()) {
      case 'PENDING_CONFIRM':
        return '待确认';
      case 'PENDING_RECTIFY':
        return '待整改';
      case 'RECTIFYING':
        return '整改中';
      case 'PENDING_VERIFY':
        return '待核查';
      case 'COMPLETED':
        return '已完成';
      case 'REASSIGN':
        return '待重新指派';
      default:
        return '--';
    }
  }
}
