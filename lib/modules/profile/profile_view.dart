import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/components/app_standard_card.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/dimens.dart';
import '../../core/utils/file_service.dart';
import '../../data/models/auth/login_entity.dart';
import '../../router/module_routes/profile_routes.dart';
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
          backgroundColor: const Color(0xFFF6F9FF),
          body: Stack(
            children: [
              _buildBackground(),
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildSliverAppBar(),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppDimens.dp16),
                      child: Column(
                        children: [
                          _ProfileHeader(profile: profile),
                          SizedBox(height: AppDimens.dp16),
                          _buildAccountInfo(profile),
                          SizedBox(height: AppDimens.dp16),
                          _buildSystemSettings(logic),
                          SizedBox(height: AppDimens.dp32),
                          _buildLogoutButton(logic),
                          SizedBox(height: AppDimens.dp40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: AppDimens.dp60,
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(
          left: AppDimens.dp16,
          bottom: AppDimens.dp12,
        ),
        centerTitle: false,
        title: Text(
          '个人中心',
          style: TextStyle(
            color: const Color(0xFF0F2E54),
            fontSize: AppDimens.sp20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildAccountInfo(LoginEntity? profile) {
    return AppStandardCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: '账号信息'),
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
        ],
      ),
    );
  }

  Widget _buildSystemSettings(ProfileController logic) {
    return AppStandardCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: '更多设置'),
          _ActionTile(
            icon: Icons.settings_outlined,
            label: '设置',
            onTap: () => ProfileRoutes.toSettings(),
          ),
          _ActionTile(
            icon: Icons.info_outline_rounded,
            label: '版本信息',
            onTap: () => ProfileRoutes.toVersionInfo(),
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(ProfileController logic) {
    return SizedBox(
      width: double.infinity,
      height: AppDimens.dp48,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFFE55252),
          elevation: 0,
          side: const BorderSide(color: Color(0xFFFFEAEA)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.dp12),
          ),
        ),
        onPressed: logic.logout,
        child: Text(
          '退出当前账号',
          style: TextStyle(
            fontSize: AppDimens.sp15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8F1FF), Color(0xFFF6F9FF)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -80,
              right: -40,
              child: _blurCircle(size: 240, color: const Color(0xFFA5C5FF)),
            ),
            Positioned(
              top: 100,
              left: -60,
              child: _blurCircle(size: 180, color: const Color(0xFFD0E2FF)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _blurCircle({required double size, required Color color}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.15),
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
    final firstChar = nameText.isNotEmpty ? nameText.characters.first : '?';
    final avatarUrl = FileService.getFaceUrl(profile?.headPortrait);
    final title = _buildTitle(profile);

    return Container(
      padding: EdgeInsets.all(AppDimens.dp20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.dp20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E66E5), Color(0xFF5B92FF)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E66E5).withValues(alpha: 0.25),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          _Avatar(avatarUrl: avatarUrl, firstChar: firstChar, title: nameText),
          SizedBox(width: AppDimens.dp16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        nameText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppDimens.sp20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (title != null) ...[
                      SizedBox(width: AppDimens.dp8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimens.dp6,
                          vertical: AppDimens.dp2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(AppDimens.dp6),
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
                  ],
                ),
                SizedBox(height: AppDimens.dp12),
                _HeaderBadge(
                  icon: Icons.phone_iphone_outlined,
                  text: profile?.phone ?? '未绑定手机号',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? _buildTitle(LoginEntity? user) {
    if (user?.isAdmin == '1') return '管理员';
    if (user?.enterprisesOrGovernments == 1) return '政府人员';
    if (user?.enterprisesOrGovernments == 2) return '企业人员';
    return null;
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.avatarUrl, required this.firstChar, required this.title});
  final String? avatarUrl;
  final String firstChar;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimens.dp64,
      height: AppDimens.dp64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.15),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(2),
      child: ClipOval(
        child: Container(
          color: Colors.white,
          child: avatarUrl == null
              ? Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, const Color(0xFFE8F1FF)],
                    ),
                  ),
                  child: Text(
                    firstChar,
                    style: TextStyle(
                      color: const Color(0xFF2E66E5),
                      fontSize: AppDimens.sp24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () => FileService.openFile(avatarUrl!, title: '头像预览'),
                  child: Image.network(
                    avatarUrl!,
                    headers: FileService.imageHeaders(),
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      alignment: Alignment.center,
                      color: const Color(0xFFF1F6FF),
                      child: Text(
                        firstChar,
                        style: TextStyle(
                          color: const Color(0xFF2E66E5),
                          fontSize: AppDimens.sp24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
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
        horizontal: AppDimens.dp8,
        vertical: AppDimens.dp3,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimens.dp8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppDimens.sp12,
            color: Colors.white.withValues(alpha: 0.9),
          ),
          SizedBox(width: AppDimens.dp4),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: AppDimens.sp11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppDimens.dp16,
        AppDimens.dp16,
        AppDimens.dp16,
        AppDimens.dp8,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppDimens.sp15,
          fontWeight: FontWeight.w700,
        ),
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
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.dp16,
            vertical: AppDimens.dp14,
          ),
          child: Row(
            children: [
              Icon(icon, size: AppDimens.sp18, color: const Color(0xFF6B7E9E)),
              SizedBox(width: AppDimens.dp12),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppDimens.sp14,
                ),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: AppDimens.sp14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
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
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.dp16,
              vertical: AppDimens.dp14,
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
                  ),
                ),
                const Spacer(),
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
}
