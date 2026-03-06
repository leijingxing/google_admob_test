import 'package:get/get.dart';

import 'alarm_disposal_handle_controller.dart';

/// 报警处置依赖注入。
class AlarmDisposalHandleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlarmDisposalHandleController>(
      AlarmDisposalHandleController.new,
    );
  }
}
