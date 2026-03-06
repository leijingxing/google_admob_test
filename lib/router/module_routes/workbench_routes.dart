import 'package:get/get.dart';

import '../../data/models/workbench/appointment_approval_item_model.dart';
import '../../modules/dashboard/modules/workbench/appointment_approval/appointment_approval_binding.dart';
import '../../modules/dashboard/modules/workbench/appointment_approval/approve/appointment_approval_approve_binding.dart';
import '../../modules/dashboard/modules/workbench/appointment_approval/approve/appointment_approval_approve_view.dart';
import '../../modules/dashboard/modules/workbench/appointment_approval/appointment_approval_view.dart';
import '../../modules/dashboard/modules/workbench/appointment_approval/detail/appointment_approval_detail_binding.dart';
import '../../modules/dashboard/modules/workbench/appointment_approval/detail/appointment_approval_detail_view.dart';
import '../../modules/dashboard/modules/workbench/whitelist_approval/whitelist_approval_binding.dart';
import '../../modules/dashboard/modules/workbench/whitelist_approval/approve/whitelist_approval_approve_binding.dart';
import '../../modules/dashboard/modules/workbench/whitelist_approval/approve/whitelist_approval_approve_view.dart';
import '../../modules/dashboard/modules/workbench/whitelist_approval/detail/whitelist_approval_detail_binding.dart';
import '../../modules/dashboard/modules/workbench/whitelist_approval/detail/whitelist_approval_detail_view.dart';
import '../../modules/dashboard/modules/workbench/whitelist_approval/whitelist_approval_view.dart';
import '../../data/models/workbench/whitelist_approval_item_model.dart';

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

  /// 白名单审批。
  static Future<T?>? toWhitelistApproval<T>() {
    return Get.to<T>(
      () => const WhitelistApprovalView(),
      binding: WhitelistApprovalBinding(),
    );
  }

  /// 白名单审批页。
  static Future<bool?>? toWhitelistApprovalApprove({
    required WhitelistApprovalItemModel item,
  }) {
    return Get.to<bool>(
      () => const WhitelistApprovalApproveView(),
      binding: WhitelistApprovalApproveBinding(),
      arguments: item,
    );
  }

  /// 白名单详情页。
  static Future<T?>? toWhitelistApprovalDetail<T>({
    required WhitelistApprovalItemModel item,
  }) {
    return Get.to<T>(
      () => const WhitelistApprovalDetailView(),
      binding: WhitelistApprovalDetailBinding(),
      arguments: item,
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
