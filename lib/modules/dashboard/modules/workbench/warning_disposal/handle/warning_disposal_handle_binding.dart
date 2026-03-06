import 'package:get/get.dart';

import 'warning_disposal_handle_controller.dart';

/// 预警处置依赖注入。
class WarningDisposalHandleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WarningDisposalHandleController>(
      WarningDisposalHandleController.new,
    );
  }
}
