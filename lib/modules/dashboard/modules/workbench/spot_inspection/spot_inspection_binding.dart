import 'package:get/get.dart';

import 'spot_inspection_controller.dart';

/// 车辆抽检页面依赖绑定。
class SpotInspectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpotInspectionController>(() => SpotInspectionController());
  }
}
