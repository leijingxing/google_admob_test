import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/dimens.dart';
import '../../../../../data/models/workbench/appointment_approval_item_model.dart';
import '../widgets/workbench_segment_tabs.dart';
import 'appointment_approval_controller.dart';

/// 预约审批页面。
class AppointmentApprovalView extends GetView<AppointmentApprovalController> {
  const AppointmentApprovalView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppointmentApprovalController>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: const Text('预约审批')),
          body: Container(
            color: const Color(0xFFF2F3F5),
            child: Column(
              children: [
                _TopFilterSection(controller: logic),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: logic.fetchList,
                    child: _ApprovalList(controller: logic),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TopFilterSection extends StatelessWidget {
  const _TopFilterSection({required this.controller});

  final AppointmentApprovalController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(
        AppDimens.dp12,
        AppDimens.dp8,
        AppDimens.dp12,
        AppDimens.dp10,
      ),
      child: Column(
        children: [
          WorkbenchSegmentTabs(
            items: controller.tabItems,
            currentIndex: controller.currentTabIndex,
            onChanged: controller.onTabChanged,
          ),
          SizedBox(height: AppDimens.dp8),
          Row(
            children: [
              Expanded(
                child: _FilterDropdown(
                  value: controller.reservationType,
                  options: controller.reservationTypeOptions,
                  onChanged: controller.onReservationTypeChanged,
                ),
              ),
              SizedBox(width: AppDimens.dp8),
              Expanded(
                child: _FilterDropdown(
                  value: controller.parkCheckStatus,
                  options: controller.statusOptions,
                  onChanged: controller.onStatusChanged,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimens.dp8),
          InkWell(
            onTap: () => controller.pickDateRange(context),
            child: Container(
              width: double.infinity,
              height: AppDimens.dp36,
              padding: EdgeInsets.symmetric(horizontal: AppDimens.dp10),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD0D4DA), width: 1),
              ),
              child: Text(
                controller.dateRangeText,
                style: TextStyle(
                  color: const Color(0xFF333333),
                  fontSize: AppDimens.sp12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final int? value;
  final List<WorkbenchFilterOption<int?>> options;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimens.dp36,
      padding: EdgeInsets.symmetric(horizontal: AppDimens.dp10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD0D4DA), width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int?>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          style: TextStyle(
            color: const Color(0xFF333333),
            fontSize: AppDimens.sp12,
          ),
          onChanged: (next) => onChanged(next),
          items: options
              .map(
                (item) => DropdownMenuItem<int?>(
                  value: item.value,
                  child: Text(item.label),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _ApprovalList extends StatelessWidget {
  const _ApprovalList({required this.controller});

  final AppointmentApprovalController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.isLoading && controller.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.items.isEmpty) {
      return ListView(
        children: [
          SizedBox(height: AppDimens.dp120),
          Center(
            child: Text(
              '暂无数据',
              style: TextStyle(
                color: const Color(0xFF8C96A4),
                fontSize: AppDimens.sp12,
              ),
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(AppDimens.dp10),
      itemCount: controller.items.length,
      separatorBuilder: (_, index) => SizedBox(height: AppDimens.dp10),
      itemBuilder: (context, index) {
        final item = controller.items[index];
        return _ApprovalCard(item: item, controller: controller);
      },
    );
  }
}

class _ApprovalCard extends StatelessWidget {
  const _ApprovalCard({required this.item, required this.controller});

  final AppointmentApprovalItemModel item;
  final AppointmentApprovalController controller;

  @override
  Widget build(BuildContext context) {
    final statusText = controller.statusText(item.parkCheckStatus);
    final statusColor = _statusColor(item.parkCheckStatus);
    final title = (item.carNumb != null && item.carNumb!.isNotEmpty)
        ? item.carNumb!
        : (item.realName ?? '--');
    final reservationTypeText = controller.reservationTypeText(
      item.reservationType,
    );

    return Container(
      padding: EdgeInsets.all(AppDimens.dp12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD4D6DA), width: 1),
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
                    color: const Color(0xFF2F3134),
                    fontSize: AppDimens.sp20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                statusText,
                style: TextStyle(
                  color: statusColor,
                  fontSize: AppDimens.sp12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimens.dp6),
          Text(
            '预约类型：$reservationTypeText',
            style: TextStyle(
              color: const Color(0xFF333333),
              fontSize: AppDimens.sp12,
            ),
          ),
          SizedBox(height: AppDimens.dp4),
          Row(
            children: [
              Expanded(
                child: Text(
                  '提交时间：${controller.submitTimeText(item)}',
                  style: TextStyle(
                    color: const Color(0xFF333333),
                    fontSize: AppDimens.sp12,
                  ),
                ),
              ),
              if (item.parkCheckStatus == 0)
                SizedBox(
                  width: AppDimens.dp56,
                  height: AppDimens.dp26,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF1F7BFF)),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.dp4),
                      ),
                    ),
                    child: Text(
                      '审批',
                      style: TextStyle(
                        color: const Color(0xFF1F7BFF),
                        fontSize: AppDimens.sp12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _statusColor(int status) {
    switch (status) {
      case 1:
        return const Color(0xFF1BA664);
      case 2:
        return const Color(0xFFEB6A1F);
      case 3:
        return const Color(0xFF999999);
      default:
        return const Color(0xFF333333);
    }
  }
}
