import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/components/select/app_company_select_field.dart';
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
            const OverviewSectionTitle(title: '企业情况概览'),
            SizedBox(height: AppDimens.dp10),
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
    return Container(
      padding: EdgeInsets.all(AppDimens.dp10),
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
          Wrap(
            spacing: AppDimens.dp8,
            runSpacing: AppDimens.dp8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
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
                    '企业情况概览',
                    style: TextStyle(
                      color: const Color(0xFF203651),
                      fontSize: AppDimens.sp14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              if (showCompanyFilter)
                SizedBox(
                  width: AppDimens.dp150,
                  child: OverviewCompanySelectField(
                    value: selectedCompany,
                    onChanged: onCompanyChanged,
                  ),
                ),
            ],
          ),
          SizedBox(height: AppDimens.dp10),
          ...items.map((item) {
            final isLast = item == items.last;
            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppDimens.dp8),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp12),
        border: Border.all(color: const Color(0xFFE1E9F4)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF153055).withValues(alpha: 0.025),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
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
                  color: const Color(0xFFF5F8FC),
                  borderRadius: BorderRadius.circular(AppDimens.dp10),
                  border: Border.all(color: const Color(0xFFE1E9F3)),
                ),
                child: Text(
                  item.index.toString().padLeft(2, '0'),
                  style: TextStyle(
                    color: const Color(0xFF4E6785),
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
                    color: const Color(0xFF203651),
                    fontSize: AppDimens.sp14,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimens.dp8),
          Container(
            padding: EdgeInsets.all(AppDimens.dp8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFD),
              borderRadius: BorderRadius.circular(AppDimens.dp10),
              border: Border.all(color: const Color(0xFFE8EEF5)),
            ),
            child: Column(
              children: [
                _CompactInfoField(label: '负责人', value: item.ownerName),
                SizedBox(height: AppDimens.dp8),
                _CompactInfoField(label: '联系电话', value: item.phone),
                SizedBox(height: AppDimens.dp8),
                Row(
                  children: [
                    Expanded(
                      child: _CompactInfoField(
                        label: '待审批数目',
                        value: item.pendingCount,
                        emphasize: true,
                      ),
                    ),
                    SizedBox(width: AppDimens.dp8),
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
          SizedBox(height: AppDimens.dp8),
          Container(
            padding: EdgeInsets.all(AppDimens.dp7),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFD),
              borderRadius: BorderRadius.circular(AppDimens.dp10),
              border: Border.all(color: const Color(0xFFE8EEF5)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _EnterpriseMetricChip(
                    metric: _EnterpriseMetricData(
                      label: '今日已审批',
                      value: item.approvedCount,
                      accentColor: const Color(0xFF18A874),
                      backgroundColor: const Color(0xFFF5FBF8),
                    ),
                  ),
                ),
                SizedBox(width: AppDimens.dp6),
                Expanded(
                  child: _EnterpriseMetricChip(
                    metric: _EnterpriseMetricData(
                      label: '新增黑名单',
                      value: item.newBlacklistCount,
                      accentColor: const Color(0xFFF06A6A),
                      backgroundColor: const Color(0xFFFFF6F6),
                    ),
                  ),
                ),
                SizedBox(width: AppDimens.dp6),
                Expanded(
                  child: _EnterpriseMetricChip(
                    metric: _EnterpriseMetricData(
                      label: '新增白名单',
                      value: item.newWhitelistCount,
                      accentColor: const Color(0xFF8A63F8),
                      backgroundColor: const Color(0xFFF8F6FF),
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
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp8,
        vertical: AppDimens.dp7,
      ),
      decoration: BoxDecoration(
        color: emphasize ? Colors.white : const Color(0xFFFDFEFF),
        borderRadius: BorderRadius.circular(AppDimens.dp8),
        border: Border.all(color: const Color(0xFFE2EAF5)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: AppDimens.dp60,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color(0xFF7E90A8),
                fontSize: AppDimens.sp10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: emphasize
                    ? const Color(0xFF244C84)
                    : const Color(0xFF233B56),
                fontSize: emphasize ? AppDimens.sp12 : AppDimens.sp11,
                fontWeight: FontWeight.w700,
                height: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EnterpriseMetricChip extends StatelessWidget {
  const _EnterpriseMetricChip({required this.metric});

  final _EnterpriseMetricData metric;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp8,
        vertical: AppDimens.dp8,
      ),
      decoration: BoxDecoration(
        color: metric.backgroundColor,
        borderRadius: BorderRadius.circular(AppDimens.dp8),
        border: Border.all(color: const Color(0xFFE3EAF4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppDimens.dp14,
            height: AppDimens.dp3,
            decoration: BoxDecoration(
              color: metric.accentColor,
              borderRadius: BorderRadius.circular(AppDimens.dp999),
            ),
          ),
          SizedBox(height: AppDimens.dp8),
          Text(
            metric.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF223C5A),
              fontSize: AppDimens.sp16,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          SizedBox(height: AppDimens.dp4),
          Text(
            metric.label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF667F9D),
              fontSize: AppDimens.sp10,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _EnterpriseMetricData {
  const _EnterpriseMetricData({
    required this.label,
    required this.value,
    required this.accentColor,
    required this.backgroundColor,
  });

  final String label;
  final String value;
  final Color accentColor;
  final Color backgroundColor;
}
