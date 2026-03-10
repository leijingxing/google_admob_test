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
          return ListView(
            padding: EdgeInsets.fromLTRB(
              AppDimens.dp16,
              AppDimens.dp12,
              AppDimens.dp16,
              AppDimens.dp24,
            ),
            children: [
              _buildHeroCard(logic),
              SizedBox(height: AppDimens.dp16),
              _buildVersionCard(logic),
              SizedBox(height: AppDimens.dp16),
              _buildFunctionSection(logic),
              SizedBox(height: AppDimens.dp24),
              _buildCopyright(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeroCard(VersionInfoController logic) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimens.dp18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEDF4FF), Color(0xFFF7FAFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimens.dp20),
        border: Border.all(color: const Color(0xFFD8E6FB)),
      ),
      child: Row(
        children: [
          Container(
            width: AppDimens.dp84,
            height: AppDimens.dp84,
            padding: EdgeInsets.all(AppDimens.dp6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimens.dp20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.dp16),
              child: Assets.appLogo.image(),
            ),
          ),
          SizedBox(width: AppDimens.dp16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimens.dp8,
                    vertical: AppDimens.dp4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '版本中心',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: AppDimens.sp11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: AppDimens.dp10),
                Text(
                  logic.appName.isEmpty ? '--' : logic.appName,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: AppDimens.sp20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppDimens.dp6),
                Text(
                  '当前版本 ${logic.version.isEmpty ? '--' : logic.version}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: AppDimens.sp13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionCard(VersionInfoController logic) {
    final latest = logic.latestInfo;
    final remoteVersion = latest?.versionLabel ?? '--';
    final releaseNote = latest?.description ?? '点击“检查更新”后查看最新版本说明';
    return Container(
      padding: EdgeInsets.all(AppDimens.dp16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp16),
        border: Border.all(color: const Color(0xFFE3E9F2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildMetric(
                title: '当前版本',
                value: logic.version.isEmpty ? '--' : logic.version,
              ),
              SizedBox(width: AppDimens.dp12),
              _buildMetric(
                title: '构建号',
                value: logic.buildNumber.isEmpty ? '--' : logic.buildNumber,
              ),
              SizedBox(width: AppDimens.dp12),
              _buildMetric(title: '最新版本', value: remoteVersion),
            ],
          ),
          SizedBox(height: AppDimens.dp16),
          Text(
            '更新说明',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppDimens.sp14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppDimens.dp8),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppDimens.dp12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFF),
              borderRadius: BorderRadius.circular(AppDimens.dp12),
            ),
            child: Text(
              releaseNote,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: AppDimens.sp13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric({required String title, required String value}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.dp10,
          vertical: AppDimens.dp12,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FBFF),
          borderRadius: BorderRadius.circular(AppDimens.dp12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppColors.textHint,
                fontSize: AppDimens.sp11,
              ),
            ),
            SizedBox(height: AppDimens.dp6),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: AppDimens.sp14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (logic.checkingUpdate)
              SizedBox(
                width: AppDimens.dp16,
                height: AppDimens.dp16,
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimens.dp8,
                  vertical: AppDimens.dp4,
                ),
                decoration: BoxDecoration(
                  color: logic.hasNewVersion
                      ? const Color(0xFFE8F1FF)
                      : const Color(0xFFF2F5F9),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  logic.hasNewVersion ? '可更新' : '已最新',
                  style: TextStyle(
                    color: logic.hasNewVersion
                        ? AppColors.primary
                        : const Color(0xFF94A3B8),
                    fontSize: AppDimens.sp11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            SizedBox(width: AppDimens.dp8),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: AppDimens.dp112),
              child: Text(
                logic.updateStatus,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: logic.hasNewVersion
                      ? AppColors.primary
                      : const Color(0xFF94A3B8),
                  fontSize: AppDimens.sp12,
                ),
              ),
            ),
          ],
        ),
        onTap: () => logic.checkUpdate(),
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
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.dp16,
              vertical: AppDimens.dp16,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: AppDimens.sp18,
                  color: const Color(0xFF6B7E9E),
                ),
                SizedBox(width: AppDimens.dp12),
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: AppDimens.sp14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                if (trailing != null) ...[
                  trailing,
                  SizedBox(width: AppDimens.dp8),
                ],
                Icon(
                  Icons.chevron_right_rounded,
                  size: AppDimens.sp20,
                  color: const Color(0xFFB0C0D8),
                ),
              ],
            ),
          ),
          if (showDivider)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimens.dp16),
              child: const Divider(
                height: 1,
                thickness: 0.5,
                color: Color(0xFFE3E9F2),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCopyright() {
    return Column(
      children: [
        Text(
          '© 2026 Flutter Base',
          style: TextStyle(
            color: const Color(0xFFB0C0D8),
            fontSize: AppDimens.sp11,
          ),
        ),
      ],
    );
  }
}
