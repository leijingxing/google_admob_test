import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/dimens.dart';
import 'profile_controller.dart';

/// 个人页 Tab 页面。
class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (logic) {
        return SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF6FAFF), Color(0xFFEFF4FB)],
              ),
            ),
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                AppDimens.dp16,
                AppDimens.dp16,
                AppDimens.dp16,
                AppDimens.dp24,
              ),
              children: [
                Container(
                  padding: EdgeInsets.all(AppDimens.dp16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimens.dp18),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF124F92), Color(0xFF2A75C5)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0E2A49).withValues(alpha: 0.16),
                        blurRadius: AppDimens.dp16,
                        offset: Offset(0, AppDimens.dp8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: AppDimens.dp56,
                        height: AppDimens.dp56,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.35),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          logic.profile.name.substring(0, 1),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppDimens.sp24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(width: AppDimens.dp12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              logic.profile.name,
                              style: TextStyle(
                                fontSize: AppDimens.sp18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: AppDimens.dp4),
                            Text(
                              logic.profile.role,
                              style: TextStyle(
                                fontSize: AppDimens.sp12,
                                color: const Color(0xFFDCEEFF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppDimens.dp12),
                Row(
                  children: const [
                    Expanded(
                      child: _ProfileStatCard(title: '活跃天数', value: '128'),
                    ),
                    Expanded(
                      child: _ProfileStatCard(title: '任务完成', value: '42'),
                    ),
                    Expanded(
                      child: _ProfileStatCard(title: '协作项目', value: '6'),
                    ),
                  ],
                ),
                SizedBox(height: AppDimens.dp12),
                Container(
                  padding: EdgeInsets.all(AppDimens.dp14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppDimens.dp14),
                    border: Border.all(color: const Color(0xFFE2EAF6)),
                  ),
                  child: Column(
                    children: [
                      _ProfileItem(
                        icon: Icons.badge_outlined,
                        label: '账号',
                        value: logic.profile.account,
                      ),
                      _ProfileItem(
                        icon: Icons.phone_iphone_outlined,
                        label: '手机号',
                        value: logic.profile.phone,
                      ),
                      _ProfileItem(
                        icon: Icons.mail_outline_rounded,
                        label: '邮箱',
                        value: logic.profile.email,
                      ),
                      _ProfileItem(
                        icon: Icons.apartment_rounded,
                        label: '部门',
                        value: logic.profile.dept,
                        showDivider: false,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppDimens.dp20),
                SizedBox(
                  height: AppDimens.dp44,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFE55252),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.dp12),
                      ),
                    ),
                    onPressed: logic.logout,
                    child: const Text('退出登录'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProfileStatCard extends StatelessWidget {
  const _ProfileStatCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppDimens.dp4),
      padding: EdgeInsets.symmetric(vertical: AppDimens.dp12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp12),
        border: Border.all(color: const Color(0xFFE2EAF6)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: AppDimens.sp16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppDimens.dp4),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppDimens.sp10,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  const _ProfileItem({
    required this.icon,
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: AppDimens.dp10),
          child: Row(
            children: [
              Icon(icon, size: AppDimens.sp16, color: const Color(0xFF6D8098)),
              SizedBox(width: AppDimens.dp10),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppDimens.sp12,
                ),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: AppDimens.sp12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F3F8)),
      ],
    );
  }
}
