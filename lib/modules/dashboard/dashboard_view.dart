import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/dimens.dart';
import 'dashboard_controller.dart';

/// 主页 Tab 页面。
class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (logic) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF5FAFF), Color(0xFFEFF4FB)],
            ),
          ),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: AppDimens.dp200,
                elevation: 0,
                surfaceTintColor: Colors.transparent,
                backgroundColor: const Color(0xFF145AA3),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(
                    left: AppDimens.dp16,
                    right: AppDimens.dp16,
                    bottom: AppDimens.dp14,
                  ),
                  title: Text(
                    '工作台',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppDimens.sp16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  background: Container(
                    padding: EdgeInsets.fromLTRB(
                      AppDimens.dp16,
                      AppDimens.dp56,
                      AppDimens.dp16,
                      AppDimens.dp20,
                    ),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF0F3A68), Color(0xFF1C6ABD)],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '你好，今天也很适合推进 Demo',
                          style: TextStyle(
                            color: const Color(0xFFDCEEFF),
                            fontSize: AppDimens.sp12,
                          ),
                        ),
                        SizedBox(height: AppDimens.dp8),
                        Text(
                          '快速开始你的业务模块',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppDimens.sp20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: AppDimens.dp12),
                        const _OverviewChips(),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppDimens.dp16,
                    AppDimens.dp16,
                    AppDimens.dp16,
                    AppDimens.dp24,
                  ),
                  child: Column(
                    children: logic.cards.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return Padding(
                        padding: EdgeInsets.only(bottom: AppDimens.dp12),
                        child: _DashboardCard(
                          icon: item.icon,
                          title: item.title,
                          subtitle: item.subtitle,
                          accentColor: index.isEven
                              ? const Color(0xFF1967B4)
                              : const Color(0xFF2A9D8F),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OverviewChips extends StatelessWidget {
  const _OverviewChips();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _OverviewChip(label: '模块', value: '2'),
        SizedBox(width: AppDimens.dp8),
        const _OverviewChip(label: '入口', value: '4'),
        SizedBox(width: AppDimens.dp8),
        const _OverviewChip(label: '状态', value: '正常'),
      ],
    );
  }
}

class _OverviewChip extends StatelessWidget {
  const _OverviewChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp10,
        vertical: AppDimens.dp6,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(AppDimens.dp24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
      ),
      child: Text(
        '$label · $value',
        style: TextStyle(
          color: Colors.white,
          fontSize: AppDimens.sp10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimens.dp14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.dp16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFF7FAFF)],
        ),
        border: Border.all(color: const Color(0xFFE2EAF6)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E2A49).withValues(alpha: 0.08),
            blurRadius: AppDimens.dp12,
            offset: Offset(0, AppDimens.dp4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppDimens.dp40,
            height: AppDimens.dp40,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppDimens.dp12),
            ),
            child: Icon(icon, color: accentColor),
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
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppDimens.dp6),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: AppDimens.sp12,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppDimens.dp8),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: AppDimens.sp12,
            color: const Color(0xFF9BA9BA),
          ),
        ],
      ),
    );
  }
}
