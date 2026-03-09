import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/dimens.dart';
import '../../../generated/assets.gen.dart';
import 'version_info_controller.dart';

class VersionInfoView extends GetView<VersionInfoController> {
  const VersionInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        title: const Text('版本信息'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      body: GetBuilder<VersionInfoController>(
        builder: (logic) {
          return Column(
            children: [
              _buildAppInfo(logic),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimens.dp16),
                child: _buildFunctionSection(logic),
              ),
              const Spacer(),
              _buildCopyright(),
              SizedBox(height: AppDimens.dp40),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppInfo(VersionInfoController logic) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: AppDimens.dp40),
      child: Column(
        children: [
          Container(
            width: AppDimens.dp80,
            height: AppDimens.dp80,
            padding: EdgeInsets.all(AppDimens.dp4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimens.dp16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.dp12),
              child: Assets.appLogo.image(),
            ),
          ),
          SizedBox(height: AppDimens.dp16),
          Text(
            logic.appName,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppDimens.sp18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppDimens.dp4),
          Text(
            'Version ${logic.version}',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppDimens.sp13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFunctionSection(VersionInfoController logic) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp16),
        border: Border.all(color: const Color(0xFFE3E9F2)),
      ),
      child: _buildTile(
        icon: Icons.system_update_rounded,
        label: '检查更新',
        trailing: Text(
          logic.updateStatus,
          style: TextStyle(
            color: logic.hasNewVersion ? AppColors.primary : const Color(0xFF94A3B8),
            fontSize: AppDimens.sp13,
          ),
        ),
        onTap: logic.checkUpdate,
        showDivider: false,
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Widget? trailing,
    bool showDivider = true,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.dp16),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimens.dp16, vertical: AppDimens.dp16),
            child: Row(
              children: [
                Icon(icon, size: AppDimens.sp18, color: const Color(0xFF6B7E9E)),
                SizedBox(width: AppDimens.dp12),
                Text(
                  label,
                  style: TextStyle(color: AppColors.textPrimary, fontSize: AppDimens.sp14, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                if (trailing != null) ...[
                  trailing,
                  SizedBox(width: AppDimens.dp8),
                ],
                Icon(Icons.chevron_right_rounded, size: AppDimens.sp20, color: const Color(0xFFB0C0D8)),
              ],
            ),
          ),
          if (showDivider)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimens.dp16),
              child: const Divider(height: 1, thickness: 0.5, color: Color(0xFFE3E9F2)),
            ),
        ],
      ),
    );
  }

  Widget _buildCopyright() {
    return Column(
      children: [
        Text(
          '© 2026 Flutter Base. All Rights Reserved.',
          style: TextStyle(
            color: const Color(0xFFB0C0D8),
            fontSize: AppDimens.sp11,
          ),
        ),
      ],
    );
  }
}
