import 'package:get/get.dart';

import '../../data/models/workbench/appointment_approval_item_model.dart';
import '../../modules/dashboard/modules/workbench/appointment_approval/appointment_approval_binding.dart';
import '../../modules/dashboard/modules/workbench/appointment_approval/approve/appointment_approval_approve_binding.dart';
import '../../modules/dashboard/modules/workbench/appointment_approval/approve/appointment_approval_approve_view.dart';
import '../../modules/dashboard/modules/workbench/appointment_approval/appointment_approval_view.dart';
import '../../modules/dashboard/modules/workbench/appointment_approval/detail/appointment_approval_detail_binding.dart';
import '../../modules/dashboard/modules/workbench/appointment_approval/detail/appointment_approval_detail_view.dart';

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

  /// 预约审批详情页。
  static Future<T?>? toAppointmentApprovalDetail<T>({
    required AppointmentApprovalItemModel item,
  }) {
    return Get.to<T>(
      () => const AppointmentApprovalDetailView(),
      binding: AppointmentApprovalDetailBinding(),
      arguments: item,
    );
  }

  /// 预约审批页。
  static Future<bool?>? toAppointmentApprovalApprove({
    required AppointmentApprovalItemModel item,
  }) {
    return Get.to<bool>(
      () => const AppointmentApprovalApproveView(),
      binding: AppointmentApprovalApproveBinding(),
      arguments: item,
    );
  }
}
