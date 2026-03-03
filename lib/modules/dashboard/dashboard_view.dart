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
              colors: [Color(0xFFF3F8FF), Color(0xFFEAF2FF)],
            ),
          ),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: AppDimens.dp220,
                elevation: 0,
                surfaceTintColor: Colors.transparent,
                backgroundColor: const Color(0xFF1F5FAE),
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
                        colors: [Color(0xFF124A90), Color(0xFF2A78C8)],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          logic.greeting,
                          style: TextStyle(
                            color: Color(0xFFDCEEFF),
                            fontSize: AppDimens.sp12,
                          ),
                        ),
                        SizedBox(height: AppDimens.dp8),
                        Text(
                          '今日业务总览',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppDimens.sp20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: AppDimens.dp10),
                        _WeatherChip(text: logic.weather),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppDimens.dp16,
                    AppDimens.dp14,
                    AppDimens.dp16,
                    AppDimens.dp24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionTitle(title: '数据概览'),
                      SizedBox(height: AppDimens.dp10),
                      _StatsGrid(stats: logic.stats),
                      SizedBox(height: AppDimens.dp16),
                      _SectionTitle(title: '快捷入口'),
                      SizedBox(height: AppDimens.dp10),
                      _QuickActionGrid(
                        items: logic.quickActions,
                        onTap: logic.onQuickActionTap,
                      ),
                      SizedBox(height: AppDimens.dp16),
                      _SectionTitle(title: '今日待办'),
                      SizedBox(height: AppDimens.dp10),
                      ...logic.todos.map(
                        (item) => _TodoCard(item: item, onTap: logic.onTodoTap),
                      ),
                      SizedBox(height: AppDimens.dp16),
                      _SectionTitle(title: '项目进度'),
                      SizedBox(height: AppDimens.dp10),
                      ...logic.projects.map((item) => _ProjectCard(item: item)),
                      SizedBox(height: AppDimens.dp16),
                      _SectionTitle(title: '最近动态'),
                      SizedBox(height: AppDimens.dp10),
                      ...logic.activities.map(
                        (item) => _ActivityCard(item: item),
                      ),
                    ],
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: AppDimens.sp16,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _WeatherChip extends StatelessWidget {
  const _WeatherChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp10,
        vertical: AppDimens.dp6,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppDimens.dp24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_outlined, color: Colors.white, size: AppDimens.sp14),
          SizedBox(width: AppDimens.dp6),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: AppDimens.sp10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.stats});

  final List<DashboardStatData> stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: stats
          .map(
            (item) => Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: AppDimens.dp4),
                padding: EdgeInsets.all(AppDimens.dp12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimens.dp14),
                  border: Border.all(color: const Color(0xFFE2EAF6)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0E2A49).withValues(alpha: 0.08),
                      blurRadius: AppDimens.dp12,
                      offset: Offset(0, AppDimens.dp4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: AppDimens.sp10,
                      ),
                    ),
                    SizedBox(height: AppDimens.dp8),
                    Text(
                      item.value,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: AppDimens.sp14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: AppDimens.dp6),
                    Text(
                      item.trend,
                      style: TextStyle(
                        color: item.color,
                        fontSize: AppDimens.sp10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _QuickActionGrid extends StatelessWidget {
  const _QuickActionGrid({required this.items, required this.onTap});

  final List<DashboardQuickActionData> items;
  final ValueChanged<DashboardQuickActionData> onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - AppDimens.dp10) / 2;
        return Wrap(
          spacing: AppDimens.dp10,
          runSpacing: AppDimens.dp10,
          children: items.map((item) {
            return SizedBox(
              width: cardWidth,
              child: InkWell(
                onTap: () => onTap(item),
                borderRadius: BorderRadius.circular(AppDimens.dp14),
                child: Container(
                  padding: EdgeInsets.all(AppDimens.dp12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppDimens.dp14),
                    border: Border.all(color: const Color(0xFFE2EAF6)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: AppDimens.dp32,
                        height: AppDimens.dp32,
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF2A78C8,
                          ).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(AppDimens.dp10),
                        ),
                        child: Icon(item.icon, color: const Color(0xFF1F5FAE)),
                      ),
                      SizedBox(height: AppDimens.dp8),
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: AppDimens.sp12,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: AppDimens.dp4),
                      Text(
                        item.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: AppDimens.sp10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _TodoCard extends StatelessWidget {
  const _TodoCard({required this.item, required this.onTap});

  final DashboardTodoData item;
  final ValueChanged<DashboardTodoData> onTap;

  @override
  Widget build(BuildContext context) {
    final bool isHigh = item.priority == '高';
    return Container(
      margin: EdgeInsets.only(bottom: AppDimens.dp10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp14),
        border: Border.all(color: const Color(0xFFE2EAF6)),
      ),
      child: ListTile(
        onTap: () => onTap(item),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppDimens.dp12,
          vertical: AppDimens.dp2,
        ),
        leading: CircleAvatar(
          radius: AppDimens.dp16,
          backgroundColor:
              (isHigh ? const Color(0xFFE55252) : const Color(0xFF2F8EDE))
                  .withValues(alpha: 0.14),
          child: Icon(
            Icons.task_alt_rounded,
            color: isHigh ? const Color(0xFFE55252) : const Color(0xFF2F8EDE),
            size: AppDimens.sp14,
          ),
        ),
        title: Text(
          item.title,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: AppDimens.sp12,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${item.time} · 优先级 ${item.priority}',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: AppDimens.sp10,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: const Color(0xFF9BA9BA),
          size: AppDimens.sp18,
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.item});

  final DashboardProjectData item;

  @override
  Widget build(BuildContext context) {
    final percent = (item.progress * 100).toStringAsFixed(0);
    return Container(
      margin: EdgeInsets.only(bottom: AppDimens.dp10),
      padding: EdgeInsets.all(AppDimens.dp12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp14),
        border: Border.all(color: const Color(0xFFE2EAF6)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.name,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: AppDimens.sp12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '$percent%',
                style: TextStyle(
                  color: const Color(0xFF1F5FAE),
                  fontSize: AppDimens.sp12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimens.dp8),
          LinearProgressIndicator(
            minHeight: AppDimens.dp6,
            borderRadius: BorderRadius.circular(AppDimens.dp6),
            value: item.progress,
            backgroundColor: const Color(0xFFE9EEF7),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1F5FAE)),
          ),
          SizedBox(height: AppDimens.dp8),
          Row(
            children: [
              Icon(
                Icons.groups_2_outlined,
                size: AppDimens.sp12,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: AppDimens.dp4),
              Text(
                item.owner,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppDimens.sp10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.item});

  final DashboardActivityData item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimens.dp10),
      padding: EdgeInsets.all(AppDimens.dp12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp14),
        border: Border.all(color: const Color(0xFFE2EAF6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: AppDimens.dp4),
            width: AppDimens.dp8,
            height: AppDimens.dp8,
            decoration: const BoxDecoration(
              color: Color(0xFF1F5FAE),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: AppDimens.dp10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: AppDimens.sp12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppDimens.dp4),
                Text(
                  item.desc,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: AppDimens.sp10,
                  ),
                ),
                SizedBox(height: AppDimens.dp6),
                Text(
                  item.time,
                  style: TextStyle(
                    color: const Color(0xFF8B9AAF),
                    fontSize: AppDimens.sp10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
