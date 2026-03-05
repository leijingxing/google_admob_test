import 'package:get/get.dart';

import '../../modules/dashboard/modules/workbench/appointment_approval/appointment_approval_binding.dart';
import '../../modules/dashboard/modules/workbench/appointment_approval/appointment_approval_view.dart';

/// Workbench 模块页面跳转封装（非命名路由）。
abstract class WorkbenchRoutes {
  WorkbenchRoutes._();

  /// 预约审批。
  static Future<T?>? toAppointmentApproval<T>() {
    return Get.to<T>(
      () => const AppointmentApprovalView(),
      binding: AppointmentApprovalBinding(),
    );
  }
}
