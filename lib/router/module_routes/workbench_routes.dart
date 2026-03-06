import 'package:get/get.dart';

import '../../data/models/workbench/appointment_approval_item_model.dart';
import '../../data/models/workbench/blacklist_approval_item_model.dart';
import '../../data/models/workbench/spot_inspection_item_model.dart';
import '../../modules/dashboard/modules/workbench/appointment_approval/appointment_approval_binding.dart';
import '../../modules/dashboard/modules/workbench/appointment_approval/approve/appointment_approval_approve_binding.dart';
import '../../modules/dashboard/modules/workbench/appointment_approval/approve/appointment_approval_approve_view.dart';
import '../../modules/dashboard/modules/workbench/appointment_approval/appointment_approval_view.dart';
import '../../modules/dashboard/modules/workbench/appointment_approval/detail/appointment_approval_detail_binding.dart';
import '../../modules/dashboard/modules/workbench/appointment_approval/detail/appointment_approval_detail_view.dart';
import '../../modules/dashboard/modules/workbench/blacklist_approval/approve/blacklist_approval_approve_binding.dart';
import '../../modules/dashboard/modules/workbench/blacklist_approval/approve/blacklist_approval_approve_view.dart';
import '../../modules/dashboard/modules/workbench/blacklist_approval/blacklist_approval_binding.dart';
import '../../modules/dashboard/modules/workbench/blacklist_approval/blacklist_approval_view.dart';
import '../../modules/dashboard/modules/workbench/blacklist_approval/detail/blacklist_approval_detail_binding.dart';
import '../../modules/dashboard/modules/workbench/blacklist_approval/detail/blacklist_approval_detail_view.dart';
import '../../modules/dashboard/modules/workbench/spot_inspection/detail/spot_inspection_detail_binding.dart';
import '../../modules/dashboard/modules/workbench/spot_inspection/detail/spot_inspection_detail_view.dart';
import '../../modules/dashboard/modules/workbench/spot_inspection/fill/spot_inspection_fill_binding.dart';
import '../../modules/dashboard/modules/workbench/spot_inspection/fill/spot_inspection_fill_view.dart';
import '../../modules/dashboard/modules/workbench/spot_inspection/spot_inspection_binding.dart';
import '../../modules/dashboard/modules/workbench/spot_inspection/spot_inspection_view.dart';
import '../../modules/dashboard/modules/workbench/hidden_danger_governance/hidden_danger_governance_binding.dart';
import '../../modules/dashboard/modules/workbench/hidden_danger_governance/hidden_danger_governance_view.dart';
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

  /// 黑名单审批。
  static Future<T?>? toBlacklistApproval<T>() {
    return Get.to<T>(
      () => const BlacklistApprovalView(),
      binding: BlacklistApprovalBinding(),
    );
  }

  /// 车辆抽检。
  static Future<T?>? toSpotInspection<T>() {
    return Get.to<T>(
      () => const SpotInspectionView(),
      binding: SpotInspectionBinding(),
    );
  }

  /// 隐患治理。
  static Future<T?>? toHiddenDangerGovernance<T>() {
    return Get.to<T>(
      () => const HiddenDangerGovernanceView(),
      binding: HiddenDangerGovernanceBinding(),
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

  /// 黑名单审批页。
  static Future<bool?>? toBlacklistApprovalApprove({
    required BlacklistApprovalItemModel item,
  }) {
    return Get.to<bool>(
      () => const BlacklistApprovalApproveView(),
      binding: BlacklistApprovalApproveBinding(),
      arguments: {'item': item, 'authorizationMode': false},
    );
  }

  /// 黑名单更改授权页。
  static Future<bool?>? toBlacklistAuthorization({
    required BlacklistApprovalItemModel item,
  }) {
    return Get.to<bool>(
      () => const BlacklistApprovalApproveView(),
      binding: BlacklistApprovalApproveBinding(),
      arguments: {'item': item, 'authorizationMode': true},
    );
  }

  /// 黑名单详情页。
  static Future<T?>? toBlacklistApprovalDetail<T>({
    required BlacklistApprovalItemModel item,
  }) {
    return Get.to<T>(
      () => const BlacklistApprovalDetailView(),
      binding: BlacklistApprovalDetailBinding(),
      arguments: item,
    );
  }

  /// 抽检填写页。
  static Future<bool?>? toSpotInspectionFill({
    required SpotInspectionItemModel item,
  }) {
    return Get.to<bool>(
      () => const SpotInspectionFillView(),
      binding: SpotInspectionFillBinding(),
      arguments: item,
    );
  }

  /// 抽检详情页。
  static Future<bool?>? toSpotInspectionDetail({
    required SpotInspectionItemModel item,
  }) {
    return Get.to<bool>(
      () => const SpotInspectionDetailView(),
      binding: SpotInspectionDetailBinding(),
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
