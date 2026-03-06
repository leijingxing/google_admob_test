import 'package:get/get.dart';

import 'spot_inspection_detail_controller.dart';

/// 抽检详情页面依赖绑定。
class SpotInspectionDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpotInspectionDetailController>(
      () => SpotInspectionDetailController(),
    );
  }
}
