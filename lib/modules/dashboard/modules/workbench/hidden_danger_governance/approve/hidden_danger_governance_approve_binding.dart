import 'package:get/get.dart';

import 'hidden_danger_governance_approve_controller.dart';

/// 隐患治理审批页依赖注入。
class HiddenDangerGovernanceApproveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HiddenDangerGovernanceApproveController>(
      HiddenDangerGovernanceApproveController.new,
    );
  }
}
