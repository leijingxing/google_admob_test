import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/dimens.dart';
import '../../core/env/env.dart';
import '../../data/models/auth/login_entity.dart';
import 'profile_controller.dart';

/// 个人页 Tab 页面。
class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (logic) {
        final profile = logic.profile;
        return Scaffold(
          backgroundColor: const Color(0xFFF1F6FF),
          body: Stack(
            children: [
              _buildBackground(),
              SafeArea(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          AppDimens.dp16,
                          AppDimens.dp12,
                          AppDimens.dp16,
                          AppDimens.dp24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '个人中心',
                              style: TextStyle(
                                color: const Color(0xFF0F2E54),
                                fontSize: AppDimens.sp22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: AppDimens.dp12),
                            _ProfileHeader(profile: profile),
                            SizedBox(height: AppDimens.dp12),
                            _SectionCard(
                              title: '账号信息',
                              child: Column(
                                children: [
                                  _InfoTile(
                                    icon: Icons.badge_outlined,
                                    label: '账号',
                                    value: _v(profile?.userAccount),
                                  ),
                                  _InfoTile(
                                    icon: Icons.phone_iphone_outlined,
                                    label: '手机号',
                                    value: _v(profile?.phone),
                                  ),
                                  _InfoTile(
                                    icon: Icons.apartment_rounded,
                                    label: '部门',
                                    value: _v(profile?.departmentName),
                                  ),
                                  _InfoTile(
                                    icon: Icons.verified_user_outlined,
                                    label: '管理员',
                                    value: profile?.isAdmin == '1' ? '是' : '否',
                                    showDivider: false,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: AppDimens.dp20),
                            SizedBox(
                              width: double.infinity,
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBackground() {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFDCE9FF), Color(0xFFF1F6FF), Color(0xFFF7FAFF)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            right: -40,
            child: _blurCircle(size: 240, color: const Color(0xFF8DB2FF)),
          ),
          Positioned(
            top: 120,
            left: -60,
            child: _blurCircle(size: 180, color: const Color(0xFFA9C6FF)),
          ),
        ],
      ),
    );
  }

  Widget _blurCircle({required double size, required Color color}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.22),
      ),
    );
  }

  String _v(String? value) {
    if (value == null || value.trim().isEmpty) return '-';
    return value;
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile});

  final LoginEntity? profile;

  @override
  Widget build(BuildContext context) {
    final name = profile?.userName?.trim();
    final nameText = (name == null || name.isEmpty) ? '未设置姓名' : name;
    final companyText = profile?.companyName?.trim();
    final company = (companyText == null || companyText.isEmpty)
        ? '未设置企业'
        : companyText;
    final firstChar = nameText.characters.first;
    final avatarUrl = _buildAvatarUrl(profile?.headPortrait);
    final title = _buildTitle(profile);

    return Container(
      padding: EdgeInsets.all(AppDimens.dp16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.dp20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B4F9F), Color(0xFF3B78E7)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B4F9F).withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: AppDimens.dp64,
            height: AppDimens.dp64,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
            ),
            child: ClipOval(
              child: avatarUrl == null
                  ? Container(
                      alignment: Alignment.center,
                      color: Colors.white.withValues(alpha: 0.15),
                      child: Text(
                        firstChar,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppDimens.sp24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  : Image.network(
                      avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          alignment: Alignment.center,
                          color: Colors.white.withValues(alpha: 0.15),
                          child: Text(
                            firstChar,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppDimens.sp24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        );
                      },
                    ),
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
                        nameText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppDimens.sp18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(width: AppDimens.dp6),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimens.dp6,
                        vertical: AppDimens.dp2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(AppDimens.dp8),
                      ),
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppDimens.sp10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppDimens.dp4),
                Text(
                  company,
                  style: TextStyle(
                    color: const Color(0xFFDCEEFF),
                    fontSize: AppDimens.sp12,
                  ),
                ),
                SizedBox(height: AppDimens.dp8),
                Wrap(
                  spacing: AppDimens.dp6,
                  runSpacing: AppDimens.dp6,
                  children: [
                    _HeaderBadge(
                      icon: Icons.phone_iphone_outlined,
                      text: _shortText(profile?.phone, fallback: '未绑定手机号'),
                    ),
                    _HeaderBadge(
                      icon: Icons.apartment_rounded,
                      text: _shortText(
                        profile?.departmentName,
                        fallback: '未设置部门',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _buildTitle(LoginEntity? user) {
    if (user?.isAdmin == '1') return '管理员';
    if (user?.enterprisesOrGovernments == 1) return '政府人员';
    if (user?.enterprisesOrGovernments == 2) return '企业人员';
    return '正式员工';
  }

  String? _buildAvatarUrl(String? headPortrait) {
    final raw = headPortrait?.trim() ?? '';
    if (raw.isEmpty) return null;
    if (raw.startsWith('http://') || raw.startsWith('https://')) return raw;
    final base = Environment.currentEnv.apiBaseUrl.trim();
    if (raw.startsWith('/')) return '$base$raw';
    return '$base/$raw';
  }

  String _shortText(String? value, {required String fallback}) {
    final text = value?.trim();
    if (text == null || text.isEmpty) return fallback;
    return text;
  }
}

class _HeaderBadge extends StatelessWidget {
  const _HeaderBadge({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp6,
        vertical: AppDimens.dp3,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppDimens.dp8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppDimens.sp10, color: Colors.white),
          SizedBox(width: AppDimens.dp4),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: AppDimens.sp10,
              fontWeight: FontWeight.w500,
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
      padding: EdgeInsets.all(AppDimens.dp16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp18),
        border: Border.all(color: const Color(0xFFE2EAF6)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E2A49).withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
          padding: EdgeInsets.symmetric(vertical: AppDimens.dp12),
          child: Row(
            children: [
              Container(
                width: AppDimens.dp26,
                height: AppDimens.dp26,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF3FD),
                  borderRadius: BorderRadius.circular(AppDimens.dp8),
                ),
                child: Icon(
                  icon,
                  size: AppDimens.sp14,
                  color: const Color(0xFF5B6F86),
                ),
              ),
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
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEF2F8)),
      ],
    );
  }
}
