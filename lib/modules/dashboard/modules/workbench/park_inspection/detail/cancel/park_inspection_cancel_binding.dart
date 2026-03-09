import 'package:get/get.dart';

import 'park_inspection_cancel_controller.dart';

class ParkInspectionCancelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParkInspectionCancelController>(
      () => ParkInspectionCancelController(),
    );
  }
}
