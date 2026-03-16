import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/components/select/app_company_select_field.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/dimens.dart';
import '../../../../../core/utils/user_manager.dart';
import '../overview_statistics_controller.dart';
import '../overview_statistics_models.dart';
import 'overview_statistics_shared.dart';

/// 企业情况概览区块。
class DashboardEnterpriseOverviewSection extends StatelessWidget {
  const DashboardEnterpriseOverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OverviewStatisticsController>(
      id: OverviewStatisticsController.enterpriseSectionId,
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OverviewSectionHeader(
              title: '企业情况概览',
              onRefresh: controller.refreshEnterpriseOverview,
              isRefreshing: controller.isEnterpriseRefreshing,
            ),
            SizedBox(height: OverviewSectionTokens.contentGap),
            _EnterpriseOverviewCard(
              selectedCompany: controller.selectedEnterpriseCompany,
              onCompanyChanged: controller.onEnterpriseCompanyChanged,
              items: controller.enterpriseOverviewItems,
            ),
          ],
        );
      },
    );
  }
}

class _EnterpriseOverviewCard extends StatelessWidget {
  const _EnterpriseOverviewCard({
    required this.selectedCompany,
    required this.onCompanyChanged,
    required this.items,
  });

  final AppSelectedCompany? selectedCompany;
  final ValueChanged<AppSelectedCompany?> onCompanyChanged;
  final List<EnterpriseOverviewItem> items;

  @override
  Widget build(BuildContext context) {
    final showCompanyFilter = UserManager.isParkUser;
    return OverviewCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OverviewCardTitle(
            title: '企业列表',
            trailing: showCompanyFilter
                ? SizedBox(
                    width: AppDimens.dp150,
                    child: OverviewCompanySelectField(
                      value: selectedCompany,
                      onChanged: onCompanyChanged,
                    ),
                  )
                : null,
          ),
          SizedBox(height: OverviewSectionTokens.contentGap),
          ...items.map((item) {
            final isLast = item == items.last;
            return Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : OverviewSectionTokens.itemGap,
              ),
              child: _EnterpriseOverviewListItem(item: item),
            );
          }),
        ],
      ),
    );
  }
}

class _EnterpriseOverviewListItem extends StatelessWidget {
  const _EnterpriseOverviewListItem({required this.item});

  final EnterpriseOverviewItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimens.dp10),
      decoration: BoxDecoration(
        color: OverviewSectionTokens.cardTintBackground,
        borderRadius: BorderRadius.circular(OverviewSectionTokens.cardRadius),
        border: Border.all(color: OverviewSectionTokens.metricBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(minWidth: AppDimens.dp34),
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimens.dp8,
                  vertical: AppDimens.dp7,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: OverviewSectionTokens.metricBackground,
                  borderRadius: BorderRadius.circular(
                    OverviewSectionTokens.metricRadius,
                  ),
                  border: Border.all(color: OverviewSectionTokens.metricBorder),
                ),
                child: Text(
                  item.index.toString().padLeft(2, '0'),
                  style: TextStyle(
                    color: AppColors.headerSubtitle,
                    fontSize: AppDimens.sp12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SizedBox(width: AppDimens.dp8),
              Expanded(
                child: Text(
                  item.companyName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.headerTitle,
                    fontSize: AppDimens.sp14,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: OverviewSectionTokens.itemGap),
          Container(
            padding: EdgeInsets.all(AppDimens.dp8),
            decoration: BoxDecoration(
              color: OverviewSectionTokens.cardBackground,
              borderRadius: BorderRadius.circular(
                OverviewSectionTokens.metricRadius,
              ),
              border: Border.all(color: OverviewSectionTokens.metricBorder),
            ),
            child: Column(
              children: [
                _CompactInfoField(label: '负责人', value: item.ownerName),
                SizedBox(height: OverviewSectionTokens.itemGap),
                _CompactInfoField(label: '联系电话', value: item.phone),
                SizedBox(height: OverviewSectionTokens.itemGap),
                Row(
                  children: [
                    Expanded(
                      child: _CompactInfoField(
                        label: '待审批数目',
                        value: item.pendingCount,
                        emphasize: true,
                      ),
                    ),
                    SizedBox(width: OverviewSectionTokens.itemGap),
                    Expanded(
                      child: _CompactInfoField(
                        label: '今日在岗员工',
                        value: item.onDutyEmployeeCount,
                        emphasize: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: OverviewSectionTokens.itemGap),
          Container(
            padding: EdgeInsets.all(AppDimens.dp7),
            decoration: BoxDecoration(
              color: OverviewSectionTokens.cardBackground,
              borderRadius: BorderRadius.circular(
                OverviewSectionTokens.metricRadius,
              ),
              border: Border.all(color: OverviewSectionTokens.metricBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _EnterpriseMetricChip(
                    metric: _EnterpriseMetricData(
                      label: '今日已审批',
                      value: item.approvedCount,
                      valueColor: AppColors.success,
                      backgroundColor: OverviewSectionTokens.successSoft,
                    ),
                  ),
                ),
                SizedBox(width: AppDimens.dp6),
                Expanded(
                  child: _EnterpriseMetricChip(
                    metric: _EnterpriseMetricData(
                      label: '新增黑名单',
                      value: item.newBlacklistCount,
                      valueColor: AppColors.error,
                      backgroundColor: OverviewSectionTokens.dangerSoft,
                    ),
                  ),
                ),
                SizedBox(width: AppDimens.dp6),
                Expanded(
                  child: _EnterpriseMetricChip(
                    metric: _EnterpriseMetricData(
                      label: '新增白名单',
                      value: item.newWhitelistCount,
                      valueColor: OverviewSectionTokens.accent,
                      backgroundColor:
                          OverviewSectionTokens.metricEmphasisBackground,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactInfoField extends StatelessWidget {
  const _CompactInfoField({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return OverviewInfoRow(label: label, value: value, emphasize: emphasize);
  }
}

class _EnterpriseMetricChip extends StatelessWidget {
  const _EnterpriseMetricChip({required this.metric});

  final _EnterpriseMetricData metric;

  @override
  Widget build(BuildContext context) {
    return OverviewMetricTile(
      label: metric.label,
      value: metric.value,
      backgroundColor: metric.backgroundColor,
      valueColor: metric.valueColor,
    );
  }
}

class _EnterpriseMetricData {
  const _EnterpriseMetricData({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.backgroundColor,
  });

  final String label;
  final String value;
  final Color valueColor;
  final Color backgroundColor;
}
