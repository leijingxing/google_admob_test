import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
            const OverviewSectionTitle(title: '审批统计'),
            SizedBox(height: AppDimens.dp10),
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
