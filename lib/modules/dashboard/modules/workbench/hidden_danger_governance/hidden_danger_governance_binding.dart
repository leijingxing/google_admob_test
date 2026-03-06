import 'package:get/get.dart';

import 'hidden_danger_governance_controller.dart';

/// 隐患治理依赖注入。
class HiddenDangerGovernanceBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<HiddenDangerGovernanceController>()) {
      Get.lazyPut<HiddenDangerGovernanceController>(
        HiddenDangerGovernanceController.new,
      );
    }
  }
}
