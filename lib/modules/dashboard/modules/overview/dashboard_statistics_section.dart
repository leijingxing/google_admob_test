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
            _SectionTitle(title: '今日预约情况'),
            SizedBox(height: AppDimens.dp10),
            _ReservationTrendCard(
              unitOptions: controller.reservationUnitOptions,
              selectedUnit: controller.selectedReservationUnit,
              onUnitChanged: controller.onReservationUnitChanged,
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

class _ReservationTrendCard extends StatelessWidget {
  const _ReservationTrendCard({
    required this.unitOptions,
    required this.selectedUnit,
    required this.onUnitChanged,
    required this.onRefresh,
    required this.summaryMetrics,
    required this.series,
  });

  final List<String> unitOptions;
  final String selectedUnit;
  final ValueChanged<String?> onUnitChanged;
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
                width: AppDimens.dp128,
                child: _CompactSelectBox(
                  value: selectedUnit,
                  items: unitOptions,
                  onChanged: onUnitChanged,
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
                labelStyle: TextStyle(
                  color: Color(0xFF7F92A8),
                  fontSize: 10,
                ),
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
                labelStyle: TextStyle(
                  color: Color(0xFF7F92A8),
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

class _CompactSelectBox extends StatelessWidget {
  const _CompactSelectBox({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimens.dp36,
      padding: EdgeInsets.symmetric(horizontal: AppDimens.dp10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBFF),
        borderRadius: BorderRadius.circular(AppDimens.dp8),
        border: Border.all(color: const Color(0xFFD9E4F3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          style: TextStyle(
            color: const Color(0xFF5A6F8A),
            fontSize: AppDimens.sp12,
          ),
          onChanged: onChanged,
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
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

  static const List<_YardCardPalette> _palettes = [
    _YardCardPalette(
      accent: Color(0xFF2F6BFF),
      accentSoft: Color(0xFFEAF2FF),
      surface: Color(0xFFF8FBFF),
      border: Color(0xFFD7E6FF),
    ),
    _YardCardPalette(
      accent: Color(0xFF00A67E),
      accentSoft: Color(0xFFE8FAF4),
      surface: Color(0xFFF7FCFA),
      border: Color(0xFFD5F0E7),
    ),
    _YardCardPalette(
      accent: Color(0xFFF08A24),
      accentSoft: Color(0xFFFFF3E7),
      surface: Color(0xFFFFFBF7),
      border: Color(0xFFF8E1C7),
    ),
    _YardCardPalette(
      accent: Color(0xFF7B61FF),
      accentSoft: Color(0xFFF1EEFF),
      surface: Color(0xFFFAF9FF),
      border: Color(0xFFE0DAFF),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 360;
        final cardWidth = isNarrow
            ? constraints.maxWidth
            : (constraints.maxWidth - AppDimens.dp10) / 2;
        return Wrap(
          spacing: AppDimens.dp10,
          runSpacing: AppDimens.dp10,
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final palette = _palettes[index % _palettes.length];
            return SizedBox(
              width: cardWidth,
              child: _YardStatCard(item: item, palette: palette),
            );
          }).toList(),
        );
      },
    );
  }
}

class _YardStatCard extends StatelessWidget {
  const _YardStatCard({required this.item, required this.palette});

  final YardStatCardData item;
  final _YardCardPalette palette;

  @override
  Widget build(BuildContext context) {
    final primaryMetric = item.metrics.isNotEmpty ? item.metrics.first : null;
    final secondaryMetrics = item.metrics.skip(1).toList();

    return Container(
      padding: EdgeInsets.all(AppDimens.dp12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, palette.surface],
        ),
        borderRadius: BorderRadius.circular(AppDimens.dp16),
        border: Border.all(color: palette.border),
        boxShadow: [
          BoxShadow(
            color: palette.accent.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppDimens.dp36,
                height: AppDimens.dp36,
                decoration: BoxDecoration(
                  color: palette.accentSoft,
                  borderRadius: BorderRadius.circular(AppDimens.dp12),
                ),
                child: Icon(
                  Icons.stacked_bar_chart_rounded,
                  color: palette.accent,
                  size: AppDimens.dp20,
                ),
              ),
              SizedBox(width: AppDimens.dp10),
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(
                    color: const Color(0xFF22364D),
                    fontSize: AppDimens.sp13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if (primaryMetric != null) ...[
            SizedBox(height: AppDimens.dp10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: AppDimens.dp10,
                vertical: AppDimens.dp8,
              ),
              decoration: BoxDecoration(
                color: palette.accentSoft,
                borderRadius: BorderRadius.circular(AppDimens.dp14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    primaryMetric.label,
                    style: TextStyle(
                      color: palette.accent.withValues(alpha: 0.78),
                      fontSize: AppDimens.sp10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppDimens.dp4),
                  Text(
                    primaryMetric.value,
                    style: TextStyle(
                      color: palette.accent,
                      fontSize: AppDimens.sp22,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (secondaryMetrics.isNotEmpty) ...[
            SizedBox(height: AppDimens.dp8),
            Wrap(
              spacing: AppDimens.dp8,
              runSpacing: AppDimens.dp8,
              children: secondaryMetrics
                  .map(
                    (metric) => _MiniMetric(
                      metric: metric,
                      palette: palette,
                      widthFactor: secondaryMetrics.length == 1 ? 1 : 0.46,
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
    required this.metric,
    required this.palette,
    required this.widthFactor,
  });

  final YardMetric metric;
  final _YardCardPalette palette;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.dp9,
          vertical: AppDimens.dp8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimens.dp12),
          border: Border.all(color: palette.border.withValues(alpha: 0.9)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              metric.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color(0xFF627892),
                fontSize: AppDimens.sp10,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppDimens.dp6),
            Text(
              metric.value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color(0xFF1F3550),
                fontSize: AppDimens.sp15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _YardCardPalette {
  const _YardCardPalette({
    required this.accent,
    required this.accentSoft,
    required this.surface,
    required this.border,
  });

  final Color accent;
  final Color accentSoft;
  final Color surface;
  final Color border;
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
