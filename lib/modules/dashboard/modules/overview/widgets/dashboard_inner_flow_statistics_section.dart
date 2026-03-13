import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
            const OverviewSectionTitle(title: '园区内人车流统计'),
            SizedBox(height: AppDimens.dp10),
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

    return Container(
      padding: EdgeInsets.all(AppDimens.dp12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp14),
        border: Border.all(color: const Color(0xFFE2EAF6)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2F6BFF).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '园区内人车流趋势',
                  style: TextStyle(
                    color: const Color(0xFF203651),
                    fontSize: AppDimens.sp14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              OverviewDateRangeFilter(range: range, onChanged: onRangeChanged),
            ],
          ),
          SizedBox(height: AppDimens.dp10),
          Wrap(
            spacing: AppDimens.dp8,
            runSpacing: AppDimens.dp8,
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
          SizedBox(height: AppDimens.dp12),
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
                  color: Color(0xFFEDF2F8),
                ),
                labelStyle: const TextStyle(
                  color: Color(0xFF7F92A8),
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
          color: selected ? const Color(0xFF2F6BFF) : const Color(0xFFF4F7FB),
          borderRadius: BorderRadius.circular(AppDimens.dp20),
          border: Border.all(
            color: selected ? const Color(0xFF2F6BFF) : const Color(0xFFDCE5F1),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF47617D),
            fontSize: AppDimens.sp12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
