import 'package:get/get.dart';

import 'hidden_danger_governance_detail_controller.dart';

/// 隐患治理详情依赖注入。
class HiddenDangerGovernanceDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HiddenDangerGovernanceDetailController>(
      HiddenDangerGovernanceDetailController.new,
    );
  }
}
