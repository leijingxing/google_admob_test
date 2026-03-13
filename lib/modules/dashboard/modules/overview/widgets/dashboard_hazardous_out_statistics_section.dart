import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/dimens.dart';
import '../overview_statistics_controller.dart';
import '../overview_statistics_models.dart';
import 'overview_statistics_shared.dart';

/// 危化品出园统计区块。
class DashboardHazardousOutStatisticsSection extends StatelessWidget {
  const DashboardHazardousOutStatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OverviewStatisticsController>(
      id: OverviewStatisticsController.hazardousOutSectionId,
      builder: (controller) {
        return _PieStatCard(
          title: '危化品出园统计',
          range: controller.hazardousOutRange,
          onRangeChanged: controller.onHazardousOutRangeChanged,
          data: controller.hazardousOutPie,
        );
      },
    );
  }
}

class _PieStatCard extends StatelessWidget {
  const _PieStatCard({
    required this.title,
    required this.range,
    required this.onRangeChanged,
    required this.data,
  });

  final String title;
  final DateTimeRange? range;
  final ValueChanged<DateTimeRange?> onRangeChanged;
  final List<PiePoint> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimens.dp12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp14),
        border: Border.all(color: const Color(0xFFE2EAF6)),
      ),
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
          SizedBox(height: AppDimens.dp8),
          OverviewDateRangeFilter(
            range: range,
            onChanged: onRangeChanged,
            width: double.infinity,
          ),
          SizedBox(height: AppDimens.dp10),
          SizedBox(
            height: AppDimens.dp200,
            child: SfCircularChart(
              legend: const Legend(
                isVisible: true,
                position: LegendPosition.bottom,
                overflowMode: LegendItemOverflowMode.wrap,
              ),
              series: <CircularSeries>[
                PieSeries<PiePoint, String>(
                  dataSource: data,
                  xValueMapper: (item, _) => item.name,
                  yValueMapper: (item, _) => item.value,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
