import 'package:get/get.dart';

import 'park_inspection_dispatch_controller.dart';

class ParkInspectionDispatchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParkInspectionDispatchController>(
      () => ParkInspectionDispatchController(),
    );
  }
}
