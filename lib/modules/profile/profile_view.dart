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
                colors: [Color(0xFFF3F8FF), Color(0xFFEAF2FF)],
              ),
            ),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppDimens.dp16,
                      AppDimens.dp16,
                      AppDimens.dp16,
                      AppDimens.dp24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ProfileHeader(profile: logic.profile),
                        SizedBox(height: AppDimens.dp12),
                        _SectionCard(
                          title: '常用功能',
                          child: const _QuickActions(),
                        ),
                        SizedBox(height: AppDimens.dp12),
                        _SectionCard(
                          title: '账号信息',
                          child: Column(
                            children: [
                              _InfoTile(
                                icon: Icons.badge_outlined,
                                label: '账号',
                                value: logic.profile.account,
                              ),
                              _InfoTile(
                                icon: Icons.phone_iphone_outlined,
                                label: '手机号',
                                value: logic.profile.phone,
                              ),
                              _InfoTile(
                                icon: Icons.mail_outline_rounded,
                                label: '邮箱',
                                value: logic.profile.email,
                              ),
                              _InfoTile(
                                icon: Icons.apartment_rounded,
                                label: '部门',
                                value: logic.profile.dept,
                                showDivider: false,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppDimens.dp20),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: AppDimens.dp44,
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.settings_outlined),
                                  label: const Text('设置'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF1F5FAE),
                                    side: const BorderSide(
                                      color: Color(0xFFD8E4F4),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppDimens.dp12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: AppDimens.dp10),
                            Expanded(
                              child: SizedBox(
                                height: AppDimens.dp44,
                                child: FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: const Color(0xFFE55252),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppDimens.dp12,
                                      ),
                                    ),
                                  ),
                                  onPressed: logic.logout,
                                  child: const Text('退出登录'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimens.dp16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.dp20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF11498E), Color(0xFF2F81CF)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E2A49).withValues(alpha: 0.16),
            blurRadius: AppDimens.dp16,
            offset: Offset(0, AppDimens.dp8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: AppDimens.dp60,
                height: AppDimens.dp60,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.35),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  profile.name.substring(0, 1),
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
                      profile.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppDimens.sp18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: AppDimens.dp4),
                    Text(
                      profile.role,
                      style: TextStyle(
                        color: const Color(0xFFDCEEFF),
                        fontSize: AppDimens.sp12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimens.dp8,
                  vertical: AppDimens.dp5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(AppDimens.dp20),
                ),
                child: Text(
                  '在线',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppDimens.sp10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimens.dp14),
          Row(
            children: const [
              Expanded(
                child: _HeaderStat(label: '活跃天数', value: '128'),
              ),
              Expanded(
                child: _HeaderStat(label: '完成任务', value: '42'),
              ),
              Expanded(
                child: _HeaderStat(label: '协作项目', value: '6'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  const _HeaderStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppDimens.dp4),
      padding: EdgeInsets.symmetric(vertical: AppDimens.dp10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimens.dp12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: AppDimens.sp14,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppDimens.dp4),
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFFDCEEFF),
              fontSize: AppDimens.sp10,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimens.dp14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp16),
        border: Border.all(color: const Color(0xFFE2EAF6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppDimens.sp14,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppDimens.dp10),
          child,
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.edit_note_rounded, '编辑资料'),
      (Icons.verified_user_outlined, '认证中心'),
      (Icons.history_rounded, '登录记录'),
      (Icons.help_outline_rounded, '帮助反馈'),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - AppDimens.dp10) / 2;
        return Wrap(
          spacing: AppDimens.dp10,
          runSpacing: AppDimens.dp10,
          children: items.map((item) {
            return SizedBox(
              width: width,
              child: Container(
                padding: EdgeInsets.all(AppDimens.dp12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7FAFF),
                  borderRadius: BorderRadius.circular(AppDimens.dp12),
                  border: Border.all(color: const Color(0xFFE6EDF8)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: AppDimens.dp28,
                      height: AppDimens.dp28,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F5FAE).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppDimens.dp8),
                      ),
                      child: Icon(
                        item.$1,
                        size: AppDimens.sp14,
                        color: const Color(0xFF1F5FAE),
                      ),
                    ),
                    SizedBox(width: AppDimens.dp8),
                    Expanded(
                      child: Text(
                        item.$2,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
            );
          }).toList(),
        );
      },
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
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
