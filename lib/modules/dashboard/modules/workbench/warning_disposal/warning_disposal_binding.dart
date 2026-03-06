import 'package:get/get.dart';

import 'warning_disposal_controller.dart';

/// 预警处置依赖注入。
class WarningDisposalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WarningDisposalController>(WarningDisposalController.new);
  }
}
