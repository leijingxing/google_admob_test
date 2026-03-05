import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/dimens.dart';
import 'overview_statistics_controller.dart';

/// 首页/总览页共用统计区块。
class DashboardStatisticsSection extends StatelessWidget {
  const DashboardStatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OverviewStatisticsController>(
      init: Get.isRegistered<OverviewStatisticsController>()
          ? Get.find<OverviewStatisticsController>()
          : OverviewStatisticsController(),
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(title: '危化品统计'),
            SizedBox(height: AppDimens.dp10),
            _PieStatCard(
              title: '危化品入园统计',
              parkOptions: controller.parkOptions,
              selectedPark: controller.hazardousInPark,
              rangeText: controller.hazardousInRangeText,
              onParkChanged: controller.onHazardousInParkChanged,
              onRangeTap: () => controller.pickHazardousInRange(context),
              data: controller.hazardousInPie,
            ),
            SizedBox(height: AppDimens.dp10),
            _PieStatCard(
              title: '危化品出园统计',
              parkOptions: controller.parkOptions,
              selectedPark: controller.hazardousOutPark,
              rangeText: controller.hazardousOutRangeText,
              onParkChanged: controller.onHazardousOutParkChanged,
              onRangeTap: () => controller.pickHazardousOutRange(context),
              data: controller.hazardousOutPie,
            ),
            SizedBox(height: AppDimens.dp16),
            _SectionTitle(title: '园内统计'),
            SizedBox(height: AppDimens.dp10),
            _YardStatsGrid(items: controller.yardStats),
            SizedBox(height: AppDimens.dp16),
            _SectionTitle(title: '审批统计'),
            SizedBox(height: AppDimens.dp10),
            _ApprovalCard(rows: controller.approvalRows),
          ],
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

class _PieStatCard extends StatelessWidget {
  const _PieStatCard({
    required this.title,
    required this.parkOptions,
    required this.selectedPark,
    required this.rangeText,
    required this.onParkChanged,
    required this.onRangeTap,
    required this.data,
  });

  final String title;
  final List<String> parkOptions;
  final String selectedPark;
  final String rangeText;
  final ValueChanged<String?> onParkChanged;
  final VoidCallback onRangeTap;
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
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: AppDimens.sp14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _RangeButton(text: rangeText, onTap: onRangeTap),
            ],
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

class _RangeButton extends StatelessWidget {
  const _RangeButton({required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppDimens.dp8),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.dp8,
          vertical: AppDimens.dp6,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAFF),
          borderRadius: BorderRadius.circular(AppDimens.dp8),
          border: Border.all(color: const Color(0xFFE3EAF6)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.date_range_rounded,
              size: AppDimens.sp12,
              color: const Color(0xFF5E738D),
            ),
            SizedBox(width: AppDimens.dp4),
            Text(
              text,
              style: TextStyle(
                color: const Color(0xFF445A73),
                fontSize: AppDimens.sp10,
              ),
            ),
          ],
        ),
      ),
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
        final cardWidth = (constraints.maxWidth - AppDimens.dp10) / 2;
        return Wrap(
          spacing: AppDimens.dp10,
          runSpacing: AppDimens.dp10,
          children: items.map((item) {
            return SizedBox(
              width: cardWidth,
              child: Container(
                padding: EdgeInsets.all(AppDimens.dp10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF1F9),
                  borderRadius: BorderRadius.circular(AppDimens.dp10),
                  border: Border.all(color: const Color(0xFFD9E4F1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        color: const Color(0xFF31465E),
                        fontSize: AppDimens.sp12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: AppDimens.dp8),
                    Row(
                      children: item.metrics.take(3).map((metric) {
                        return Expanded(child: _MiniMetric(metric: metric));
                      }).toList(),
                    ),
                    if (item.metrics.length > 3) ...[
                      SizedBox(height: AppDimens.dp8),
                      Row(
                        children: item.metrics.skip(3).map((metric) {
                          return Expanded(child: _MiniMetric(metric: metric));
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({required this.metric});

  final YardMetric metric;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.dp2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            metric.value,
            style: TextStyle(
              color: const Color(0xFF45505C),
              fontSize: AppDimens.sp14,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppDimens.dp2),
          Text(
            metric.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF52657C),
              fontSize: AppDimens.sp10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ApprovalCard extends StatelessWidget {
  const _ApprovalCard({required this.rows});

  final List<ApprovalStatRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimens.dp10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp14),
        border: Border.all(color: const Color(0xFFE2EAF6)),
      ),
      child: Column(
        children: rows.map((row) {
          final isLast = row == rows.last;
          return Container(
            margin: EdgeInsets.only(bottom: isLast ? 0 : AppDimens.dp8),
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.dp10,
              vertical: AppDimens.dp10,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1FF),
              borderRadius: BorderRadius.circular(AppDimens.dp10),
            ),
            child: Row(
              children: [
                Container(
                  width: AppDimens.dp24,
                  height: AppDimens.dp24,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A78F2).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppDimens.dp6),
                  ),
                  child: Icon(
                    row.icon,
                    size: AppDimens.sp14,
                    color: const Color(0xFF3A78F2),
                  ),
                ),
                SizedBox(width: AppDimens.dp8),
                Expanded(
                  child: Text(
                    row.title,
                    style: TextStyle(
                      color: const Color(0xFF22364D),
                      fontSize: AppDimens.sp12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _ApprovalValue(label: row.leftLabel, value: row.leftValue),
                SizedBox(width: AppDimens.dp8),
                _ApprovalValue(label: row.rightLabel, value: row.rightValue),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ApprovalValue extends StatelessWidget {
  const _ApprovalValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF5B6F86),
            fontSize: AppDimens.sp10,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: const Color(0xFF284E8A),
            fontSize: AppDimens.sp14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
