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
            Row(
              children: [
                const Expanded(child: OverviewSectionTitle(title: '园内统计')),
                OverviewDateRangeFilter(
                  range: controller.yardRange,
                  onChanged: controller.onYardRangeChanged,
                ),
              ],
            ),
            SizedBox(height: AppDimens.dp6),
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
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp10,
        vertical: AppDimens.dp10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp12),
        border: Border.all(color: const Color(0xFFE3EBF5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F2747).withValues(alpha: 0.035),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.dp8,
              vertical: AppDimens.dp6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F8FC),
              borderRadius: BorderRadius.circular(AppDimens.dp10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppDimens.dp6,
                  height: AppDimens.dp6,
                  margin: EdgeInsets.only(top: AppDimens.dp4),
                  decoration: const BoxDecoration(
                    color: Color(0xFF4C7DFF),
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
          SizedBox(height: AppDimens.dp7),
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
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp8,
        vertical: AppDimens.dp7,
      ),
      decoration: BoxDecoration(
        color: emphasize ? const Color(0xFFF3F7FF) : const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(AppDimens.dp9),
        border: Border.all(
          color: emphasize ? const Color(0xFFDCE7FA) : const Color(0xFFE8EEF6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            metric.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF243E5A),
              fontSize: emphasize ? AppDimens.sp20 : AppDimens.sp17,
              fontWeight: FontWeight.w800,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            metric.label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF67809C),
              fontSize: AppDimens.sp10,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
