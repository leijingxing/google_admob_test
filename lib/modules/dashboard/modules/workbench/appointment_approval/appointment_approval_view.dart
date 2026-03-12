import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/components/app_info_status_card.dart';
import '../../../../../core/components/custom_refresh.dart';
import '../../../../../core/components/custom_sliding_tab_bar.dart';
import '../../../../../core/components/date_picker/custom_date_range_picker.dart';
import '../../../../../core/constants/dimens.dart';
import '../../../../../data/models/workbench/appointment_approval_item_model.dart';
import '../../../../../router/module_routes/workbench_routes.dart';
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
          body: _ApprovalTabbedBody(controller: logic),
        );
      },
    );
  }
}

class _ApprovalTabbedBody extends StatefulWidget {
  const _ApprovalTabbedBody({required this.controller});

  final AppointmentApprovalController controller;

  @override
  State<_ApprovalTabbedBody> createState() => _ApprovalTabbedBodyState();
}

class _ApprovalTabbedBodyState extends State<_ApprovalTabbedBody>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.controller.tabItems.length,
      vsync: this,
      initialIndex: widget.controller.currentTabIndex,
    )..addListener(_handleTabChanged);
  }

  @override
  void didUpdateWidget(covariant _ApprovalTabbedBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_tabController.index != widget.controller.currentTabIndex) {
      _tabController.animateTo(widget.controller.currentTabIndex);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChanged() {
    if (_tabController.indexIsChanging) return;
    final nextIndex = _tabController.index;
    if (nextIndex != widget.controller.currentTabIndex) {
      widget.controller.onTabChanged(nextIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TopFilterSection(
          controller: widget.controller,
          tabController: _tabController,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: List.generate(widget.controller.tabItems.length, (
              tabIndex,
            ) {
              return CustomEasyRefreshList<AppointmentApprovalItemModel>(
                key: ValueKey('approval-list-$tabIndex'),
                refreshTrigger: widget.controller.refreshTrigger,
                pageSize: 20,
                dataLoader: (pageIndex, pageSize) => widget.controller
                    .loadPageByTab(tabIndex, pageIndex, pageSize),
                padding: EdgeInsets.fromLTRB(
                  AppDimens.dp12,
                  AppDimens.dp8,
                  AppDimens.dp12,
                  AppDimens.dp12,
                ),
                itemBuilder: (context, item, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: AppDimens.dp10),
                    child: _ApprovalCard(
                      item: item,
                      controller: widget.controller,
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _TopFilterSection extends StatelessWidget {
  const _TopFilterSection({
    required this.controller,
    required this.tabController,
  });

  final AppointmentApprovalController controller;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        AppDimens.dp12,
        AppDimens.dp10,
        AppDimens.dp12,
        AppDimens.dp8,
      ),
      padding: EdgeInsets.fromLTRB(
        AppDimens.dp10,
        AppDimens.dp10,
        AppDimens.dp10,
        AppDimens.dp10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp12),
        border: Border.all(color: const Color(0xFFE1E6EF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CustomSlidingTabBar(
            labels: controller.tabItems.map((item) => item.label).toList(),
            currentIndex: controller.currentTabIndex,
            onChanged: controller.onTabChanged,
            controller: tabController,
          ),
          SizedBox(height: AppDimens.dp8),
          Row(
            children: [
              Expanded(
                child: CustomDateRangePicker(
                  startDate: controller.dateRange?.start,
                  endDate: controller.dateRange?.end,
                  onDateRangeSelected: controller.onDateRangeSelected,
                  compact: true,
                ),
              ),
              SizedBox(width: AppDimens.dp8),
              SizedBox(
                width: AppDimens.dp34,
                height: AppDimens.dp34,
                child: FilledButton(
                  onPressed: () => _showFilterBottomSheet(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF1F7BFF),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.dp10),
                    ),
                  ),
                  child: const Icon(Icons.tune, size: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showFilterBottomSheet(BuildContext context) async {
    int? tempReservationType = controller.reservationType;
    int? tempStatus = controller.selectedStatus;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppDimens.dp16,
                  AppDimens.dp12,
                  AppDimens.dp16,
                  AppDimens.dp16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '筛选条件',
                      style: TextStyle(
                        fontSize: AppDimens.sp16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E2A3A),
                      ),
                    ),
                    SizedBox(height: AppDimens.dp12),
                    _FilterDropdownField(
                      title: '预约类型',
                      value: tempReservationType,
                      options: controller.reservationTypeOptions,
                      onChanged: (value) {
                        setModalState(() => tempReservationType = value);
                      },
                    ),
                    if (controller.currentTabIndex != 0) ...[
                      SizedBox(height: AppDimens.dp10),
                      _FilterDropdownField(
                        title: '状态',
                        value: tempStatus,
                        options: controller.statusOptions,
                        onChanged: (value) {
                          setModalState(() => tempStatus = value);
                        },
                      ),
                    ],
                    SizedBox(height: AppDimens.dp14),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              controller.applyFilters(
                                nextReservationType: null,
                                nextStatus: null,
                              );
                              Navigator.of(bottomSheetContext).pop();
                            },
                            child: const Text('重置'),
                          ),
                        ),
                        SizedBox(width: AppDimens.dp10),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              controller.applyFilters(
                                nextReservationType: tempReservationType,
                                nextStatus: tempStatus,
                              );
                              Navigator.of(bottomSheetContext).pop();
                            },
                            child: const Text('确定'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _FilterDropdownField extends StatelessWidget {
  const _FilterDropdownField({
    required this.title,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String title;
  final int? value;
  final List<WorkbenchFilterOption<int?>> options;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.dp10),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F8FC),
        borderRadius: BorderRadius.circular(AppDimens.dp10),
        border: Border.all(color: const Color(0xFFDFE4ED)),
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
          onChanged: onChanged,
          hint: Text(
            title,
            style: TextStyle(
              color: const Color(0xFF7D8A9A),
              fontSize: AppDimens.sp12,
            ),
          ),
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

class _ApprovalCard extends StatelessWidget {
  const _ApprovalCard({required this.item, required this.controller});

  final AppointmentApprovalItemModel item;
  final AppointmentApprovalController controller;

  @override
  Widget build(BuildContext context) {
    final currentStatus = controller.resolveStatus(item);
    final statusText = controller.statusText(currentStatus);
    final statusStyle = _statusStyle(currentStatus);
    final title = (item.carNumb != null && item.carNumb!.isNotEmpty)
        ? item.carNumb!
        : (item.realName ?? '--');
    final reservationTypeText = controller.reservationTypeText(
      item.reservationType,
    );

    return AppInfoStatusCard(
      title: title,
      statusText: statusText,
      statusStyle: statusStyle,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '预约类型：$reservationTypeText',
            style: TextStyle(
              color: const Color(0xFF3C4656),
              fontSize: AppDimens.sp12,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: AppDimens.dp6),
          Text(
            '提交时间：${controller.submitTimeText(item)}',
            style: TextStyle(
              color: const Color(0xFF5E6A7C),
              fontSize: AppDimens.sp12,
            ),
          ),
        ],
      ),
      trailingAction: _buildActionButtons(controller, item),
    );
  }

  Widget _buildActionButtons(
    AppointmentApprovalController controller,
    AppointmentApprovalItemModel item,
  ) {
    final buttons = <Widget>[
      SizedBox(
        width: AppDimens.dp56,
        height: AppDimens.dp26,
        child: OutlinedButton(
          onPressed: () =>
              WorkbenchRoutes.toAppointmentApprovalDetail(item: item),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF8DA0B8)),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.dp4),
            ),
          ),
          child: Text(
            '查看',
            style: TextStyle(
              color: const Color(0xFF5D7189),
              fontSize: AppDimens.sp12,
            ),
          ),
        ),
      ),
    ];

    if (controller.canApprove(item)) {
      buttons.add(SizedBox(width: AppDimens.dp8));
      buttons.add(
        SizedBox(
          width: AppDimens.dp56,
          height: AppDimens.dp26,
          child: OutlinedButton(
            onPressed: () async {
              final id = item.id ?? '';
              if (id.isEmpty) return;
              final approved =
                  await WorkbenchRoutes.toAppointmentApprovalApprove(
                    item: item,
                  );
              if (approved == true) {
                controller.refreshCurrentList();
              }
            },
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
      );
    }

    return Row(mainAxisSize: MainAxisSize.min, children: buttons);
  }

  AppCardStatusStyle _statusStyle(int status) {
    switch (status) {
      case 1:
      case 4:
        return const AppCardStatusStyle(
          textColor: Color(0xFF0E8C4C),
          backgroundColor: Color(0xFFE7F8EE),
          borderColor: Color(0xFFB8E8CC),
        );
      case 2:
      case 5:
        return const AppCardStatusStyle(
          textColor: Color(0xFFDA5A18),
          backgroundColor: Color(0xFFFFF1E8),
          borderColor: Color(0xFFF6D0B8),
        );
      case 6:
        return const AppCardStatusStyle(
          textColor: Color(0xFF667085),
          backgroundColor: Color(0xFFF2F4F7),
          borderColor: Color(0xFFD0D5DD),
        );
      default:
        return const AppCardStatusStyle(
          textColor: Color(0xFF1E4FCF),
          backgroundColor: Color(0xFFEAF1FF),
          borderColor: Color(0xFFC7D9FF),
        );
    }
  }
}
