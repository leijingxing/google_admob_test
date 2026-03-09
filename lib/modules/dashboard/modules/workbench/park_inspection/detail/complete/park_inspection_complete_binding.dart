import 'package:get/get.dart';

import 'park_inspection_complete_controller.dart';

class ParkInspectionCompleteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParkInspectionCompleteController>(
      () => ParkInspectionCompleteController(),
    );
  }
}
