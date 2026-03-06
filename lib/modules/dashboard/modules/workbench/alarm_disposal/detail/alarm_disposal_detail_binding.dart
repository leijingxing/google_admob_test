import 'package:get/get.dart';

import 'alarm_disposal_detail_controller.dart';

/// 报警详情依赖注入。
class AlarmDisposalDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlarmDisposalDetailController>(
      AlarmDisposalDetailController.new,
    );
  }
}
