import 'package:get/get.dart';

import 'warning_disposal_detail_controller.dart';

/// 预警详情依赖注入。
class WarningDisposalDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WarningDisposalDetailController>(
      WarningDisposalDetailController.new,
    );
  }
}
