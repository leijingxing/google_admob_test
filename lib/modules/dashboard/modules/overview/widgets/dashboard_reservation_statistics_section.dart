import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../core/components/select/app_company_select_field.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/dimens.dart';
import '../../../../../core/utils/user_manager.dart';
import '../overview_statistics_controller.dart';
import '../overview_statistics_models.dart';
import 'overview_statistics_shared.dart';

/// 今日预约情况区块。
class DashboardReservationStatisticsSection extends StatelessWidget {
  const DashboardReservationStatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OverviewStatisticsController>(
      id: OverviewStatisticsController.reservationSectionId,
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OverviewSectionHeader(
              title: '今日预约情况',
              onRefresh: controller.refreshReservationTrend,
              isRefreshing: controller.isReservationRefreshing,
            ),
            SizedBox(height: OverviewSectionTokens.contentGap),
            _ReservationTrendCard(
              selectedCompany: controller.selectedReservationCompany,
              onCompanyChanged: controller.onReservationCompanyChanged,
              summaryMetrics: controller.reservationSummaryMetrics,
              series: controller.reservationTrendSeries,
            ),
          ],
        );
      },
    );
  }
}

class _ReservationTrendCard extends StatelessWidget {
  const _ReservationTrendCard({
    required this.selectedCompany,
    required this.onCompanyChanged,
    required this.summaryMetrics,
    required this.series,
  });

  final AppSelectedCompany? selectedCompany;
  final ValueChanged<AppSelectedCompany?> onCompanyChanged;
  final List<ReservationSummaryMetric> summaryMetrics;
  final List<ReservationTrendSeries> series;

  @override
  Widget build(BuildContext context) {
    final showCompanyFilter = UserManager.isParkUser;
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
        children: [
          Row(
            children: [
              Expanded(child: OverviewCardTitle(title: '今日预约趋势')),
              if (showCompanyFilter) ...[
                SizedBox(
                  width: AppDimens.dp150,
                  child: OverviewCompanySelectField(
                    value: selectedCompany,
                    onChanged: onCompanyChanged,
                  ),
                ),
                SizedBox(width: AppDimens.dp8),
              ],
            ],
          ),
          SizedBox(height: OverviewSectionTokens.itemGap),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 420;
              final itemWidth = isNarrow
                  ? (constraints.maxWidth - AppDimens.dp8) / 2
                  : (constraints.maxWidth - AppDimens.dp8 * 3) / 4;
              return Wrap(
                spacing: OverviewSectionTokens.itemGap,
                runSpacing: OverviewSectionTokens.itemGap,
                children: summaryMetrics
                    .map(
                      (metric) => SizedBox(
                        width: itemWidth,
                        child: _ReservationSummaryChip(metric: metric),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          SizedBox(height: OverviewSectionTokens.contentGap),
          SizedBox(
            height: 240,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              legend: const Legend(
                isVisible: true,
                position: LegendPosition.top,
                overflowMode: LegendItemOverflowMode.wrap,
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
              zoomPanBehavior: ZoomPanBehavior(
                enablePanning: true,
                zoomMode: ZoomMode.x,
                enablePinching: true,
              ),
              series: series
                  .map(
                    (item) => SplineAreaSeries<ReservationTrendPoint, String>(
                      name: item.label,
                      dataSource: item.points,
                      xValueMapper: (point, _) => point.time,
                      yValueMapper: (point, _) => point.value,
                      color: item.color.withValues(alpha: 0.12),
                      borderColor: item.color,
                      borderWidth: 2,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          item.color.withValues(alpha: 0.22),
                          item.color.withValues(alpha: 0.02),
                        ],
                      ),
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

class _ReservationSummaryChip extends StatelessWidget {
  const _ReservationSummaryChip({required this.metric});

  final ReservationSummaryMetric metric;

  @override
  Widget build(BuildContext context) {
    return OverviewMetricTile(
      label: metric.label,
      value: metric.value,
      emphasize: true,
      alignment: CrossAxisAlignment.center,
      valueColor: OverviewSectionTokens.accent,
    );
  }
}
