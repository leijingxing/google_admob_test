import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/dimens.dart';
import 'dashboard_controller.dart';

/// 首页 Tab 页面：5 个业务模块入口。
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
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppDimens.dp16,
                    AppDimens.dp56,
                    AppDimens.dp16,
                    AppDimens.dp20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '首页',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: AppDimens.sp24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: AppDimens.dp6),
                      Text(
                        '工作台、查询与总览入口',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: AppDimens.sp12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: AppDimens.dp16),
                sliver: SliverToBoxAdapter(
                  child: _ModuleGrid(
                    items: logic.modules,
                    onTap: logic.onTapModule,
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
                  child: const _OverviewPlaceholder(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ModuleGrid extends StatelessWidget {
  const _ModuleGrid({required this.items, required this.onTap});

  final List<DashboardModuleItem> items;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - AppDimens.dp10) / 2;
        return Wrap(
          spacing: AppDimens.dp10,
          runSpacing: AppDimens.dp10,
          children: List.generate(items.length, (index) {
            final item = items[index];
            return SizedBox(
              width: cardWidth,
              child: InkWell(
                borderRadius: BorderRadius.circular(AppDimens.dp16),
                onTap: () => onTap(index),
                child: Container(
                  padding: EdgeInsets.all(AppDimens.dp12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppDimens.dp16),
                    border: Border.all(color: const Color(0xFFE2EAF6)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0E2A49).withValues(alpha: 0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: AppDimens.dp36,
                        height: AppDimens.dp36,
                        decoration: BoxDecoration(
                          color: item.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppDimens.dp10),
                        ),
                        child: Icon(item.icon, color: item.color),
                      ),
                      SizedBox(height: AppDimens.dp10),
                      Text(
                        item.title,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: AppDimens.sp14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: AppDimens.dp4),
                      Text(
                        item.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: AppDimens.sp10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class _OverviewPlaceholder extends StatelessWidget {
  const _OverviewPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
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
            '总览（首页占位）',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppDimens.sp14,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppDimens.dp8),
          Text(
            '当前暂无统计数据，后续接入图表与指标。',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppDimens.sp12,
            ),
          ),
          SizedBox(height: AppDimens.dp12),
          Row(
            children: List.generate(3, (index) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: AppDimens.dp4),
                  height: AppDimens.dp56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F9FF),
                    borderRadius: BorderRadius.circular(AppDimens.dp10),
                    border: Border.all(color: const Color(0xFFEAF0FA)),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
