import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/dimens.dart';
import '../overview_statistics_controller.dart';
import '../overview_statistics_models.dart';
import 'overview_statistics_shared.dart';

/// 园区内人车流统计区块。
class DashboardInnerFlowStatisticsSection extends StatelessWidget {
  const DashboardInnerFlowStatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OverviewStatisticsController>(
      id: OverviewStatisticsController.innerFlowSectionId,
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OverviewSectionHeader(
              title: '园区内人车流统计',
              onRefresh: controller.refreshInnerFlowStatistics,
              isRefreshing: controller.isInnerFlowRefreshing,
            ),
            SizedBox(height: OverviewSectionTokens.contentGap),
            _InnerFlowStatisticsCard(
              range: controller.innerFlowRange,
              onRangeChanged: controller.onInnerFlowRangeChanged,
              options: controller.innerFlowTypes,
              selectedType: controller.selectedInnerFlowType,
              onTypeChanged: controller.onInnerFlowTypeChanged,
              series: controller.innerFlowSeries,
            ),
          ],
        );
      },
    );
  }
}

class _InnerFlowStatisticsCard extends StatelessWidget {
  const _InnerFlowStatisticsCard({
    required this.range,
    required this.onRangeChanged,
    required this.options,
    required this.selectedType,
    required this.onTypeChanged,
    required this.series,
  });

  final DateTimeRange? range;
  final ValueChanged<DateTimeRange?> onRangeChanged;
  final List<FlowTypeOption> options;
  final int selectedType;
  final ValueChanged<int> onTypeChanged;
  final List<ReservationTrendSeries> series;

  @override
  Widget build(BuildContext context) {
    final maxValue = series
        .expand((item) => item.points)
        .fold<double>(
          0,
          (previous, item) => item.value > previous ? item.value : previous,
        );
    final axisMax = maxValue <= 0
        ? 10.0
        : ((maxValue / 5).ceil() * 5).toDouble();
    final axisInterval = axisMax <= 10 ? 2.0 : (axisMax / 5).ceilToDouble();

    return OverviewCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OverviewCardTitle(
            title: '园区内人车流趋势',
            trailing: OverviewDateRangeFilter(
              range: range,
              onChanged: onRangeChanged,
            ),
          ),
          SizedBox(height: OverviewSectionTokens.contentGap),
          Wrap(
            spacing: OverviewSectionTokens.itemGap,
            runSpacing: OverviewSectionTokens.itemGap,
            children: options
                .map(
                  (item) => _FlowTypeButton(
                    label: item.label,
                    selected: item.type == selectedType,
                    onTap: () => onTypeChanged(item.type),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: OverviewSectionTokens.cardPadding),
          SizedBox(
            height: 240,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              legend: const Legend(
                isVisible: true,
                position: LegendPosition.top,
              ),
              primaryXAxis: const CategoryAxis(
                majorGridLines: MajorGridLines(width: 0),
                axisLine: AxisLine(color: Color(0xFFD5DFEE)),
                labelStyle: TextStyle(color: Color(0xFF7F92A8), fontSize: 10),
              ),
              primaryYAxis: NumericAxis(
                minimum: 0,
                maximum: axisMax,
                interval: axisInterval,
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
                majorGridLines: const MajorGridLines(
                  width: 1,
                  color: OverviewSectionTokens.metricBorder,
                ),
                labelStyle: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
              series: series
                  .map(
                    (item) => SplineSeries<ReservationTrendPoint, String>(
                      name: item.label,
                      dataSource: item.points,
                      xValueMapper: (point, _) => point.time,
                      yValueMapper: (point, _) => point.value,
                      color: item.color,
                      width: 2.5,
                      markerSettings: const MarkerSettings(isVisible: true),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _FlowTypeButton extends StatelessWidget {
  const _FlowTypeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.dp20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.dp12,
          vertical: AppDimens.dp7,
        ),
        decoration: BoxDecoration(
          color: selected
              ? OverviewSectionTokens.accent
              : OverviewSectionTokens.mutedBackground,
          borderRadius: BorderRadius.circular(AppDimens.dp20),
          border: Border.all(
            color: selected
                ? OverviewSectionTokens.accent
                : OverviewSectionTokens.metricBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.headerSubtitle,
            fontSize: AppDimens.sp12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
