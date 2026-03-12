import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../core/components/date_picker/custom_date_range_picker.dart';
import '../../../../core/components/select/app_company_select_field.dart';
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
            Row(
              children: [
                const Expanded(child: _SectionTitle(title: '园内统计')),
                _DateRangeFilter(
                  range: controller.yardRange,
                  onChanged: controller.onYardRangeChanged,
                ),
              ],
            ),
            SizedBox(height: AppDimens.dp6),
            _YardStatsGrid(items: controller.yardStats),
            SizedBox(height: AppDimens.dp16),
            _SectionTitle(title: '审批统计'),
            SizedBox(height: AppDimens.dp10),
            _ApprovalCard(rows: controller.approvalRows),
            SizedBox(height: AppDimens.dp16),
            _SectionTitle(title: '今日预约情况'),
            SizedBox(height: AppDimens.dp10),
            _ReservationTrendCard(
              selectedCompany: controller.selectedReservationCompany,
              onCompanyChanged: controller.onReservationCompanyChanged,
              onRefresh: controller.refreshReservationTrend,
              summaryMetrics: controller.reservationSummaryMetrics,
              series: controller.reservationTrendSeries,
            ),
            SizedBox(height: AppDimens.dp16),
            _SectionTitle(title: '危化品统计'),
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
            SizedBox(height: AppDimens.dp10),
            _PieStatCard(
              title: '危化品出园统计',
              parkOptions: controller.parkOptions,
              selectedPark: controller.hazardousOutPark,
              range: controller.hazardousOutRange,
              onParkChanged: controller.onHazardousOutParkChanged,
              onRangeChanged: controller.onHazardousOutRangeChanged,
              data: controller.hazardousOutPie,
            ),
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
            ],
          ),
          SizedBox(height: AppDimens.dp8),
          CustomDateRangePicker(
            startDate: range?.start,
            endDate: range?.end,
            compact: true,
            onDateRangeSelected: (start, end) {
              onRangeChanged(_buildDateRange(start, end));
            },
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
                child: _ReservationCompanyField(
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

class _ReservationCompanyField extends StatelessWidget {
  const _ReservationCompanyField({
    required this.value,
    required this.onChanged,
  });

  final AppSelectedCompany? value;
  final ValueChanged<AppSelectedCompany?> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await showAppCompanySelectDialog(
          context,
          initialValue: value,
          title: '选择企业',
        );
        if (result != null) {
          onChanged(result);
        }
      },
      borderRadius: BorderRadius.circular(AppDimens.dp8),
      child: Container(
        height: AppDimens.dp36,
        padding: EdgeInsets.symmetric(horizontal: AppDimens.dp10),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FBFF),
          borderRadius: BorderRadius.circular(AppDimens.dp8),
          border: Border.all(color: const Color(0xFFD9E4F3)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value?.displayName ?? '选择企业',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: value == null
                      ? const Color(0xFF8A98AF)
                      : const Color(0xFF5A6F8A),
                  fontSize: AppDimens.sp12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (value != null)
              GestureDetector(
                onTap: () => onChanged(null),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.only(right: AppDimens.dp6),
                  child: Icon(
                    Icons.close_rounded,
                    size: AppDimens.dp16,
                    color: const Color(0xFF9AA8BE),
                  ),
                ),
              ),
            const Icon(Icons.keyboard_arrow_down_rounded),
          ],
        ),
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

class _DateRangeFilter extends StatelessWidget {
  const _DateRangeFilter({required this.range, required this.onChanged});

  final DateTimeRange? range;
  final ValueChanged<DateTimeRange?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppDimens.dp196,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: CustomDateRangePicker(
          startDate: range?.start,
          endDate: range?.end,
          compact: true,
          onDateRangeSelected: (start, end) {
            onChanged(_buildDateRange(start, end));
          },
        ),
      ),
    );
  }
}

DateTimeRange? _buildDateRange(DateTime? start, DateTime? end) {
  if (start == null && end == null) return null;
  if (start != null && end != null) {
    final sortedStart = start.isBefore(end) ? start : end;
    final sortedEnd = start.isBefore(end) ? end : start;
    return DateTimeRange(start: sortedStart, end: sortedEnd);
  }
  final singleDay = start ?? end!;
  return DateTimeRange(start: singleDay, end: singleDay);
}

class _ApprovalCard extends StatelessWidget {
  const _ApprovalCard({required this.rows});

  final List<ApprovalStatRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimens.dp12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFF7FAFF)],
        ),
        borderRadius: BorderRadius.circular(AppDimens.dp14),
        border: Border.all(color: const Color(0xFFE2EAF6)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2F6BFF).withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: rows.map((row) {
          final isLast = row == rows.last;
          return Container(
            margin: EdgeInsets.only(bottom: isLast ? 0 : AppDimens.dp10),
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.dp12,
              vertical: AppDimens.dp12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimens.dp12),
              border: Border.all(color: const Color(0xFFE8EEF7)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppDimens.dp34,
                  height: AppDimens.dp34,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A78F2).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppDimens.dp10),
                  ),
                  child: Icon(
                    row.icon,
                    size: AppDimens.sp18,
                    color: const Color(0xFF3A78F2),
                  ),
                ),
                SizedBox(width: AppDimens.dp10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        row.title,
                        style: TextStyle(
                          color: const Color(0xFF22364D),
                          fontSize: AppDimens.sp13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: AppDimens.dp8),
                      Row(
                        children: [
                          Expanded(
                            child: _ApprovalValue(
                              label: row.leftLabel,
                              value: row.leftValue,
                            ),
                          ),
                          SizedBox(width: AppDimens.dp8),
                          Expanded(
                            child: _ApprovalValue(
                              label: row.rightLabel,
                              value: row.rightValue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp10,
        vertical: AppDimens.dp8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F7FD),
        borderRadius: BorderRadius.circular(AppDimens.dp10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF6C8199),
              fontSize: AppDimens.sp10,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppDimens.dp4),
          Text(
            value,
            style: TextStyle(
              color: const Color(0xFF284E8A),
              fontSize: AppDimens.sp16,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
