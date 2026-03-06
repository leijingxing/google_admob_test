import 'package:get/get.dart';

import 'alarm_disposal_controller.dart';

/// 报警处置依赖注入。
class AlarmDisposalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlarmDisposalController>(AlarmDisposalController.new);
  }
}
