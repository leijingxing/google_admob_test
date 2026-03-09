import 'package:get/get.dart';

import 'park_inspection_report_abnormal_controller.dart';

class ParkInspectionReportAbnormalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParkInspectionReportAbnormalController>(
      () => ParkInspectionReportAbnormalController(),
    );
  }
}
