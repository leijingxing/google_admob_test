import 'package:get/get.dart';

import 'park_inspection_abnormal_record_controller.dart';

class ParkInspectionAbnormalRecordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParkInspectionAbnormalRecordController>(
      () => ParkInspectionAbnormalRecordController(),
    );
  }
}
