import 'package:get/get.dart';

import 'spot_inspection_fill_controller.dart';

/// 抽检填写页面依赖绑定。
class SpotInspectionFillBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpotInspectionFillController>(
      () => SpotInspectionFillController(),
    );
  }
}
