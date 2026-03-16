import 'package:flutter/material.dart';

import 'widgets/dashboard_approval_statistics_section.dart';
import 'widgets/dashboard_enterprise_overview_section.dart';
import 'widgets/dashboard_hazardous_in_statistics_section.dart';
import 'widgets/dashboard_hazardous_out_statistics_section.dart';
import 'widgets/dashboard_inner_flow_statistics_section.dart';
import 'widgets/dashboard_reservation_statistics_section.dart';
import 'widgets/dashboard_yard_statistics_section.dart';
import 'widgets/overview_statistics_shared.dart';

/// 总览页统计区块容器，仅负责拼装各独立统计模块。
class DashboardStatisticsSection extends StatelessWidget {
  const DashboardStatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardYardStatisticsSection(),
        OverviewSectionSpacing(),
        DashboardInnerFlowStatisticsSection(),
        OverviewSectionSpacing(),
        DashboardApprovalStatisticsSection(),
        OverviewSectionSpacing(),
        DashboardReservationStatisticsSection(),
        OverviewSectionSpacing(),
        DashboardHazardousInStatisticsSection(),
        OverviewSectionSpacing(),
        DashboardHazardousOutStatisticsSection(),
        OverviewSectionSpacing(),
        DashboardEnterpriseOverviewSection(),
      ],
    );
  }
}
