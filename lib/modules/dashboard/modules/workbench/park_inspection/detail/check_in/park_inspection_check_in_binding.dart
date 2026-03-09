import 'package:get/get.dart';

import 'park_inspection_check_in_controller.dart';

class ParkInspectionCheckInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParkInspectionCheckInController>(
      () => ParkInspectionCheckInController(),
    );
  }
}
