import 'package:get/get.dart';

import 'park_inspection_record_detail_controller.dart';

class ParkInspectionRecordDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParkInspectionRecordDetailController>(
      () => ParkInspectionRecordDetailController(),
    );
  }
}
