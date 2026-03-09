import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/dimens.dart';
import 'perm_util.dart';
import 'settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      body: GetBuilder<SettingsController>(
        builder: (logic) {
          final grantedCount = _grantedPermissionCount(logic);
          return ListView(
            padding: EdgeInsets.fromLTRB(
              AppDimens.dp16,
              AppDimens.dp12,
              AppDimens.dp16,
              AppDimens.bbhSafe,
            ),
            children: [
              _buildOverviewCard(logic, grantedCount),
              SizedBox(height: AppDimens.dp16),
              _buildSection(
                title: '权限管理',
                subtitle: '按功能查看权限状态，未开启时可直接申请授权',
                child: Column(
                  children: [
                    ..._buildPermissionTiles(logic),
                    _buildActionTile(
                      icon: Icons.tune_rounded,
                      iconBgColor: const Color(0xFFEAF2FF),
                      iconColor: AppColors.blue700,
                      title: '系统权限设置',
                      subtitle: '若权限被永久拒绝，可前往系统设置手动修改',
                      trailing: _buildArrowTag('前往'),
                      onTap: logic.openPermissionSettings,
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppDimens.dp16),
              _buildSection(
                title: '存储管理',
                subtitle: '清理运行缓存，释放本地占用空间',
                child: _buildActionTile(
                  icon: Icons.cleaning_services_rounded,
                  iconBgColor: const Color(0xFFFFF3E8),
                  iconColor: const Color(0xFFE67E22),
                  title: '清除缓存',
                  subtitle: '当前缓存 ${logic.cacheSize}',
                  trailing: _buildArrowTag('清理'),
                  onTap: logic.clearCache,
                  showDivider: false,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  int _grantedPermissionCount(SettingsController logic) {
    return PermUtil.allForApp.where((permission) {
      final status = logic.permissionStatuses[permission];
      return status?.isGranted == true || status?.isLimited == true;
    }).length;
  }

  Widget _buildOverviewCard(SettingsController logic, int grantedCount) {
    final total = PermUtil.allForApp.length;
    return Container(
      padding: EdgeInsets.all(AppDimens.dp18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEDF5FF), Color(0xFFF8FBFF)],
        ),
        borderRadius: BorderRadius.circular(AppDimens.dp20),
        border: Border.all(color: const Color(0xFFD8E7FB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppDimens.dp44,
                height: AppDimens.dp44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.78),
                  borderRadius: BorderRadius.circular(AppDimens.dp14),
                ),
                child: Icon(
                  Icons.admin_panel_settings_outlined,
                  color: AppColors.blue700,
                  size: AppDimens.sp22,
                ),
              ),
              SizedBox(width: AppDimens.dp12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '设备权限与存储设置',
                      style: TextStyle(
                        color: AppColors.headerTitle,
                        fontSize: AppDimens.sp16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: AppDimens.dp4),
                    Text(
                      '建议保持核心权限可用，避免扫码、上传、通知等功能受影响',
                      style: TextStyle(
                        color: AppColors.headerSubtitle,
                        fontSize: AppDimens.sp12,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimens.dp18),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  value: '$grantedCount/$total',
                  label: '已开启权限',
                ),
              ),
              SizedBox(width: AppDimens.dp10),
              Expanded(
                child: _buildStatCard(value: logic.cacheSize, label: '缓存占用'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({required String value, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp14,
        vertical: AppDimens.dp14,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(AppDimens.dp16),
        border: Border.all(color: const Color(0xFFE4EEF9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppDimens.sp16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppDimens.dp4),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppDimens.sp12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimens.dp16,
        AppDimens.dp16,
        AppDimens.dp16,
        AppDimens.dp8,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.dp20),
        border: Border.all(color: const Color(0xFFE2EAF6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A103A6F),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppDimens.sp15,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppDimens.dp4),
          Text(
            subtitle,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppDimens.sp12,
              height: 1.45,
            ),
          ),
          SizedBox(height: AppDimens.dp12),
          child,
        ],
      ),
    );
  }

  List<Widget> _buildPermissionTiles(SettingsController logic) {
    return List<Widget>.generate(PermUtil.allForApp.length, (index) {
      final permission = PermUtil.allForApp[index];
      final status =
          logic.permissionStatuses[permission] ?? PermissionStatus.denied;
      return Padding(
        padding: EdgeInsets.only(bottom: AppDimens.dp10),
        child: _buildPermissionTile(
          permission: permission,
          status: status,
          onTap: () => logic.handlePermissionTap(permission),
        ),
      );
    });
  }

  Widget _buildPermissionTile({
    required Permission permission,
    required PermissionStatus status,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFFF8FBFF),
      borderRadius: BorderRadius.circular(AppDimens.dp18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.dp18),
        child: Padding(
          padding: EdgeInsets.all(AppDimens.dp14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppDimens.dp44,
                height: AppDimens.dp44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimens.dp14),
                  border: Border.all(color: const Color(0xFFE3EDF9)),
                ),
                child: Icon(
                  permission.icon,
                  size: AppDimens.sp20,
                  color: const Color(0xFF5F79A2),
                ),
              ),
              SizedBox(width: AppDimens.dp12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            permission.displayName,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: AppDimens.sp14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        _buildStatusBadge(status),
                      ],
                    ),
                    SizedBox(height: AppDimens.dp6),
                    Text(
                      permission.description,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: AppDimens.sp12,
                        height: 1.45,
                      ),
                    ),
                    SizedBox(height: AppDimens.dp10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _buildActionChip(status),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(PermissionStatus status) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp10,
        vertical: AppDimens.dp4,
      ),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: status.color,
          fontSize: AppDimens.sp11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionChip(PermissionStatus status) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp10,
        vertical: AppDimens.dp6,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE1EAF7)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            status.actionLabel,
            style: TextStyle(
              color: const Color(0xFF5B6E8C),
              fontSize: AppDimens.sp11,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: AppDimens.dp4),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: AppDimens.sp10,
            color: const Color(0xFF8DA1BE),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget trailing,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.dp18),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppDimens.dp14,
              horizontal: AppDimens.dp2,
            ),
            child: Row(
              children: [
                Container(
                  width: AppDimens.dp40,
                  height: AppDimens.dp40,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(AppDimens.dp14),
                  ),
                  child: Icon(icon, color: iconColor, size: AppDimens.sp20),
                ),
                SizedBox(width: AppDimens.dp12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: AppDimens.sp14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: AppDimens.dp4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: AppDimens.sp12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppDimens.dp12),
                trailing,
              ],
            ),
          ),
          if (showDivider)
            const Divider(height: 1, thickness: 0.5, color: Color(0xFFE3E9F2)),
        ],
      ),
    );
  }

  Widget _buildArrowTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp10,
        vertical: AppDimens.dp6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F7FD),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(
              color: const Color(0xFF5D7090),
              fontSize: AppDimens.sp11,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: AppDimens.dp4),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: AppDimens.sp10,
            color: const Color(0xFF8DA1BE),
          ),
        ],
      ),
    );
  }
}
