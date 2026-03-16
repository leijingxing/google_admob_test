import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/dimens.dart';
import '../overview_statistics_controller.dart';
import '../overview_statistics_models.dart';
import 'overview_statistics_shared.dart';

/// 园内统计区块。
class DashboardYardStatisticsSection extends StatelessWidget {
  const DashboardYardStatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OverviewStatisticsController>(
      id: OverviewStatisticsController.yardSectionId,
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OverviewSectionHeader(
              title: '园内统计',
              trailing: OverviewDateRangeFilter(
                range: controller.yardRange,
                onChanged: controller.onYardRangeChanged,
              ),
              onRefresh: controller.refreshYardStatistics,
              isRefreshing: controller.isYardRefreshing,
            ),
            SizedBox(height: OverviewSectionTokens.contentGap),
            _YardStatsGrid(items: controller.yardStats),
          ],
        );
      },
    );
  }
}

class _YardStatsGrid extends StatelessWidget {
  const _YardStatsGrid({required this.items});

  final List<YardStatCardData> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 560;
        final cardWidth = isNarrow
            ? constraints.maxWidth
            : (constraints.maxWidth - AppDimens.dp12) / 2;
        return Wrap(
          spacing: AppDimens.dp10,
          runSpacing: AppDimens.dp10,
          children: items.map((item) {
            return SizedBox(
              width: cardWidth,
              child: _YardStatCard(item: item),
            );
          }).toList(),
        );
      },
    );
  }
}

class _YardStatCard extends StatelessWidget {
  const _YardStatCard({required this.item});

  final YardStatCardData item;

  @override
  Widget build(BuildContext context) {
    return OverviewCard(
      padding: EdgeInsets.all(OverviewSectionTokens.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.dp8,
              vertical: AppDimens.dp6,
            ),
            decoration: BoxDecoration(
              color: OverviewSectionTokens.mutedBackground,
              borderRadius: BorderRadius.circular(
                OverviewSectionTokens.metricRadius,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppDimens.dp6,
                  height: AppDimens.dp6,
                  margin: EdgeInsets.only(top: AppDimens.dp4),
                  decoration: BoxDecoration(
                    color: OverviewSectionTokens.accent,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: AppDimens.dp6),
                Expanded(
                  child: Text(
                    item.title,
                    softWrap: true,
                    style: TextStyle(
                      color: const Color(0xFF23415F),
                      fontSize: AppDimens.sp12,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: OverviewSectionTokens.itemGap),
          LayoutBuilder(
            builder: (context, constraints) {
              final columnCount = _metricColumnCount(
                metricCount: item.metrics.length,
                maxWidth: constraints.maxWidth,
              );
              final spacing = AppDimens.dp6;
              final itemWidth =
                  (constraints.maxWidth - spacing * (columnCount - 1)) /
                  columnCount;
              return Wrap(
                spacing: spacing,
                runSpacing: AppDimens.dp4,
                children: item.metrics
                    .map(
                      (metric) => SizedBox(
                        width: itemWidth,
                        child: _InlineMetric(
                          metric: metric,
                          emphasize: item.metrics.length <= 2,
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  int _metricColumnCount({required int metricCount, required double maxWidth}) {
    if (metricCount <= 1) return 1;
    if (maxWidth < 320) return metricCount == 3 ? 1 : 2;
    if (metricCount <= 2) return metricCount;
    if (metricCount == 3) return 3;
    if (metricCount >= 5 && maxWidth < 420) return 3;
    return 5;
  }
}

class _InlineMetric extends StatelessWidget {
  const _InlineMetric({required this.metric, this.emphasize = false});

  final YardMetric metric;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return OverviewMetricTile(
      value: metric.value,
      label: metric.label,
      emphasize: emphasize,
      valueColor: const Color(0xFF243E5A),
      backgroundColor: emphasize
          ? OverviewSectionTokens.metricEmphasisBackground
          : OverviewSectionTokens.metricBackground,
      borderColor: emphasize
          ? OverviewSectionTokens.accentSoftBorder
          : OverviewSectionTokens.metricBorder,
    );
  }
}
