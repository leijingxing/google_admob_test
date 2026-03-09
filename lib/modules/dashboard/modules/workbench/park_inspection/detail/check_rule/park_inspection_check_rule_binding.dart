import 'package:get/get.dart';

import 'park_inspection_check_rule_controller.dart';

class ParkInspectionCheckRuleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParkInspectionCheckRuleController>(
      () => ParkInspectionCheckRuleController(),
    );
  }
}
