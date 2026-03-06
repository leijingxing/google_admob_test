import 'package:get/get.dart';

import 'park_inspection_detail_controller.dart';

class ParkInspectionDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParkInspectionDetailController>(
      () => ParkInspectionDetailController(),
    );
  }
}
