import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/dimens.dart';
import '../overview_statistics_controller.dart';
import '../overview_statistics_models.dart';
import 'overview_statistics_shared.dart';

/// 审批统计区块。
class DashboardApprovalStatisticsSection extends StatelessWidget {
  const DashboardApprovalStatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OverviewStatisticsController>(
      id: OverviewStatisticsController.approvalSectionId,
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OverviewSectionHeader(
              title: '审批统计',
              onRefresh: controller.refreshApprovalStatistics,
              isRefreshing: controller.isApprovalRefreshing,
            ),
            SizedBox(height: OverviewSectionTokens.contentGap),
            _ApprovalCard(rows: controller.approvalRows),
          ],
        );
      },
    );
  }
}

class _ApprovalCard extends StatelessWidget {
  const _ApprovalCard({required this.rows});

  final List<ApprovalStatRow> rows;

  @override
  Widget build(BuildContext context) {
    return OverviewCard(
      backgroundColor: OverviewSectionTokens.cardTintBackground,
      child: Column(
        children: rows.map((row) {
          final isLast = row == rows.last;
          return Container(
            margin: EdgeInsets.only(
              bottom: isLast ? 0 : OverviewSectionTokens.contentGap,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.dp12,
              vertical: AppDimens.dp12,
            ),
            decoration: BoxDecoration(
              color: OverviewSectionTokens.cardBackground,
              borderRadius: BorderRadius.circular(
                OverviewSectionTokens.cardRadius,
              ),
              border: Border.all(color: OverviewSectionTokens.metricBorder),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppDimens.dp34,
                  height: AppDimens.dp34,
                  decoration: BoxDecoration(
                    color: OverviewSectionTokens.accentSoft,
                    borderRadius: BorderRadius.circular(
                      OverviewSectionTokens.metricRadius,
                    ),
                  ),
                  child: Icon(
                    row.icon,
                    size: AppDimens.sp18,
                    color: OverviewSectionTokens.accent,
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
                          color: AppColors.headerTitle,
                          fontSize: AppDimens.sp13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: OverviewSectionTokens.itemGap),
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
    return OverviewMetricTile(
      label: label,
      value: value,
      valueColor: OverviewSectionTokens.accent,
      backgroundColor: OverviewSectionTokens.metricBackground,
    );
  }
}
