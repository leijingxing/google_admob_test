import 'package:get/get.dart';

import 'park_inspection_controller.dart';

class ParkInspectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParkInspectionController>(() => ParkInspectionController());
  }
}
