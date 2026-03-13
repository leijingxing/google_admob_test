import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/dimens.dart';
import '../overview_statistics_controller.dart';
import '../overview_statistics_models.dart';
import 'overview_statistics_shared.dart';

/// 危化品入园统计区块。
class DashboardHazardousInStatisticsSection extends StatelessWidget {
  const DashboardHazardousInStatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OverviewStatisticsController>(
      id: OverviewStatisticsController.hazardousInSectionId,
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const OverviewSectionTitle(title: '危化品统计'),
            SizedBox(height: AppDimens.dp10),
            _PieStatCard(
              title: '危化品入园统计',
              parkOptions: controller.parkOptions,
              selectedPark: controller.hazardousInPark,
              range: controller.hazardousInRange,
              onParkChanged: controller.onHazardousInParkChanged,
              onRangeChanged: controller.onHazardousInRangeChanged,
              data: controller.hazardousInPie,
            ),
          ],
        );
      },
    );
  }
}

class _PieStatCard extends StatelessWidget {
  const _PieStatCard({
    required this.title,
    required this.parkOptions,
    required this.selectedPark,
    required this.range,
    required this.onParkChanged,
    required this.onRangeChanged,
    required this.data,
  });

  final String title;
  final List<String> parkOptions;
  final String selectedPark;
  final DateTimeRange? range;
  final ValueChanged<String?> onParkChanged;
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
          SizedBox(height: AppDimens.dp8),
          Row(
            children: [
              Text(
                '园区',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppDimens.sp12,
                ),
              ),
              SizedBox(width: AppDimens.dp8),
              Expanded(
                child: Container(
                  height: AppDimens.dp34,
                  padding: EdgeInsets.symmetric(horizontal: AppDimens.dp10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7FAFF),
                    borderRadius: BorderRadius.circular(AppDimens.dp10),
                    border: Border.all(color: const Color(0xFFE3EAF6)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedPark,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: AppDimens.sp12,
                      ),
                      onChanged: onParkChanged,
                      items: parkOptions
                          .map(
                            (e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            ],
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
