import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../core/components/select/app_company_select_field.dart';
import '../../../../../core/constants/dimens.dart';
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
            const OverviewSectionTitle(title: '今日预约情况'),
            SizedBox(height: AppDimens.dp10),
            _ReservationTrendCard(
              selectedCompany: controller.selectedReservationCompany,
              onCompanyChanged: controller.onReservationCompanyChanged,
              onRefresh: controller.refreshReservationTrend,
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
    required this.onRefresh,
    required this.summaryMetrics,
    required this.series,
  });

  final AppSelectedCompany? selectedCompany;
  final ValueChanged<AppSelectedCompany?> onCompanyChanged;
  final VoidCallback onRefresh;
  final List<ReservationSummaryMetric> summaryMetrics;
  final List<ReservationTrendSeries> series;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimens.dp12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp16),
        border: Border.all(color: const Color(0xFFE2EAF6)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2F6BFF).withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: AppDimens.dp4,
                      height: AppDimens.dp14,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2F6BFF),
                        borderRadius: BorderRadius.circular(AppDimens.dp4),
                      ),
                    ),
                    SizedBox(width: AppDimens.dp6),
                    Text(
                      '今日预约情况',
                      style: TextStyle(
                        color: const Color(0xFF203651),
                        fontSize: AppDimens.sp14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: AppDimens.dp4),
                    Icon(
                      Icons.info_outline_rounded,
                      size: AppDimens.dp16,
                      color: const Color(0xFF8AA1BC),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: AppDimens.dp150,
                child: OverviewCompanySelectField(
                  value: selectedCompany,
                  onChanged: onCompanyChanged,
                ),
              ),
              SizedBox(width: AppDimens.dp8),
              _RefreshButton(onTap: onRefresh),
            ],
          ),
          SizedBox(height: AppDimens.dp12),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 420;
              final itemWidth = isNarrow
                  ? (constraints.maxWidth - AppDimens.dp8) / 2
                  : (constraints.maxWidth - AppDimens.dp8 * 4) / 5;
              return Wrap(
                spacing: AppDimens.dp8,
                runSpacing: AppDimens.dp8,
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
          SizedBox(height: AppDimens.dp10),
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
              primaryYAxis: const NumericAxis(
                minimum: 0,
                maximum: 54,
                interval: 10,
                axisLine: AxisLine(width: 0),
                majorTickLines: MajorTickLines(size: 0),
                majorGridLines: MajorGridLines(
                  width: 1,
                  color: Color(0xFFEDF2F8),
                ),
                labelStyle: TextStyle(color: Color(0xFF7F92A8), fontSize: 10),
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

class _RefreshButton extends StatelessWidget {
  const _RefreshButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.dp8),
      child: Container(
        width: AppDimens.dp36,
        height: AppDimens.dp36,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FBFF),
          borderRadius: BorderRadius.circular(AppDimens.dp8),
          border: Border.all(color: const Color(0xFFBFD3EF)),
        ),
        child: Icon(
          Icons.refresh_rounded,
          size: AppDimens.dp18,
          color: const Color(0xFF2F6BFF),
        ),
      ),
    );
  }
}

class _ReservationSummaryChip extends StatelessWidget {
  const _ReservationSummaryChip({required this.metric});

  final ReservationSummaryMetric metric;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp10,
        vertical: AppDimens.dp10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5FA),
        borderRadius: BorderRadius.circular(AppDimens.dp10),
      ),
      child: Column(
        children: [
          Text(
            metric.value,
            style: TextStyle(
              color: const Color(0xFF346CFF),
              fontSize: AppDimens.sp22,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          SizedBox(height: AppDimens.dp6),
          Text(
            metric.label,
            style: TextStyle(
              color: const Color(0xFF47617D),
              fontSize: AppDimens.sp11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
