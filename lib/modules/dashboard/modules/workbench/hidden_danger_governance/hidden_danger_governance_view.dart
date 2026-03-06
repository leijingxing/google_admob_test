import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/components/app_info_status_card.dart';
import '../../../../../core/components/custom_refresh.dart';
import '../../../../../core/components/custom_sliding_tab_bar.dart';
import '../../../../../core/components/date_picker/custom_date_range_picker.dart';
import '../../../../../core/components/toast/toast_widget.dart';
import '../../../../../core/constants/dimens.dart';
import 'hidden_danger_governance_controller.dart';

/// 隐患治理页面。
class HiddenDangerGovernanceView extends GetView<HiddenDangerGovernanceController> {
  const HiddenDangerGovernanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HiddenDangerGovernanceController>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: const Text('隐患治理')),
          body: _GovernanceTabbedBody(controller: logic),
        );
      },
    );
  }
}

class _GovernanceTabbedBody extends StatefulWidget {
  const _GovernanceTabbedBody({required this.controller});

  final HiddenDangerGovernanceController controller;

  @override
  State<_GovernanceTabbedBody> createState() => _GovernanceTabbedBodyState();
}

class _GovernanceTabbedBodyState extends State<_GovernanceTabbedBody> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.controller.tabItems.length, vsync: this, initialIndex: widget.controller.currentTabIndex)..addListener(_handleTabChanged);
  }

  @override
  void didUpdateWidget(covariant _GovernanceTabbedBody oldWidget) {
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
        _TopFilterSection(controller: widget.controller, tabController: _tabController),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: List.generate(widget.controller.tabItems.length, (tabIndex) {
              return CustomEasyRefreshList<HiddenDangerGovernanceItem>(
                key: ValueKey('hidden-danger-$tabIndex'),
                refreshTrigger: widget.controller.refreshTrigger,
                pageSize: 20,
                dataLoader: (pageIndex, pageSize) => widget.controller.loadPageByTab(tabIndex, pageIndex, pageSize),
                padding: EdgeInsets.fromLTRB(AppDimens.dp12, AppDimens.dp8, AppDimens.dp12, AppDimens.dp12),
                itemBuilder: (context, item, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: AppDimens.dp10),
                    child: _GovernanceCard(item: item, controller: widget.controller),
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
  const _TopFilterSection({required this.controller, required this.tabController});

  final HiddenDangerGovernanceController controller;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(AppDimens.dp12, AppDimens.dp10, AppDimens.dp12, AppDimens.dp8),
      padding: EdgeInsets.fromLTRB(AppDimens.dp10, AppDimens.dp10, AppDimens.dp10, AppDimens.dp10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp12),
        border: Border.all(color: const Color(0xFFE1E6EF)),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        children: [
          CustomSlidingTabBar(labels: controller.tabItems.map((item) => item.label).toList(), currentIndex: controller.currentTabIndex, onChanged: controller.onTabChanged, controller: tabController),
          SizedBox(height: AppDimens.dp8),
          Row(
            children: [
              Expanded(child: _TopKeywordField(controller: controller)),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.dp10)),
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
    bool? tempEmergency = controller.selectedEmergency;
    int? tempStatus = controller.selectedStatus;
    DateTimeRange? tempDateRange = controller.dateRange;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(AppDimens.dp16, AppDimens.dp12, AppDimens.dp16, AppDimens.dp16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '筛选条件',
                      style: TextStyle(fontSize: AppDimens.sp16, fontWeight: FontWeight.w700, color: const Color(0xFF1E2A3A)),
                    ),
                    SizedBox(height: AppDimens.dp12),
                    _BoolFilterDropdownField(
                      title: '是否紧急',
                      value: tempEmergency,
                      options: controller.emergencyOptions,
                      onChanged: (value) {
                        setModalState(() => tempEmergency = value);
                      },
                    ),
                    SizedBox(height: AppDimens.dp10),
                    _StatusFilterDropdownField(
                      title: '状态',
                      value: tempStatus,
                      options: controller.statusOptions,
                      onChanged: (value) {
                        setModalState(() => tempStatus = value);
                      },
                    ),
                    SizedBox(height: AppDimens.dp10),
                    _DateRangeFilterField(
                      range: tempDateRange,
                      onChanged: (value) {
                        setModalState(() => tempDateRange = value);
                      },
                    ),
                    SizedBox(height: AppDimens.dp14),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              controller.applyFilters(nextEmergency: null, nextStatus: null, nextKeywords: '', nextDateRange: null);
                              Navigator.of(bottomSheetContext).pop();
                            },
                            child: const Text('重置'),
                          ),
                        ),
                        SizedBox(width: AppDimens.dp10),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              controller.applyFilters(nextEmergency: tempEmergency, nextStatus: tempStatus, nextKeywords: controller.keywordController.text, nextDateRange: tempDateRange);
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

class _TopKeywordField extends StatelessWidget {
  const _TopKeywordField({required this.controller});

  final HiddenDangerGovernanceController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimens.dp34,
      child: TextField(
        controller: controller.keywordController,
        textInputAction: TextInputAction.search,
        onSubmitted: controller.applyKeyword,
        decoration: InputDecoration(
          isCollapsed: true,
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          hintText: '请输入巡检点位、异常描述',
          hintStyle: TextStyle(color: const Color(0xFF9AA2AE), fontSize: AppDimens.sp12),
          contentPadding: EdgeInsets.symmetric(horizontal: AppDimens.dp10, vertical: AppDimens.dp10),
          filled: true,
          fillColor: const Color(0xFFF6F8FC),
          suffixIcon: IconButton(onPressed: () => controller.applyKeyword(controller.keywordController.text), icon: const Icon(Icons.search, size: 18)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.dp4),
            borderSide: const BorderSide(color: Color(0xFFDADDE3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.dp4),
            borderSide: const BorderSide(color: Color(0xFF1F7BFF)),
          ),
        ),
      ),
    );
  }
}

class _BoolFilterDropdownField extends StatelessWidget {
  const _BoolFilterDropdownField({required this.title, required this.value, required this.options, required this.onChanged});

  final String title;
  final bool? value;
  final List<HiddenDangerBoolOption> options;
  final ValueChanged<bool?> onChanged;

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
        child: DropdownButton<bool?>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          style: TextStyle(color: const Color(0xFF333333), fontSize: AppDimens.sp12),
          onChanged: onChanged,
          hint: Text(
            title,
            style: TextStyle(color: const Color(0xFF7D8A9A), fontSize: AppDimens.sp12),
          ),
          items: options.map((item) => DropdownMenuItem<bool?>(value: item.value, child: Text(item.label))).toList(),
        ),
      ),
    );
  }
}

class _StatusFilterDropdownField extends StatelessWidget {
  const _StatusFilterDropdownField({required this.title, required this.value, required this.options, required this.onChanged});

  final String title;
  final int? value;
  final List<HiddenDangerStatusOption> options;
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
          style: TextStyle(color: const Color(0xFF333333), fontSize: AppDimens.sp12),
          onChanged: onChanged,
          hint: Text(
            title,
            style: TextStyle(color: const Color(0xFF7D8A9A), fontSize: AppDimens.sp12),
          ),
          items: options.map((item) => DropdownMenuItem<int?>(value: item.value, child: Text(item.label))).toList(),
        ),
      ),
    );
  }
}

class _DateRangeFilterField extends StatelessWidget {
  const _DateRangeFilterField({required this.range, required this.onChanged});

  final DateTimeRange? range;
  final ValueChanged<DateTimeRange?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(AppDimens.dp10, AppDimens.dp9, AppDimens.dp10, AppDimens.dp10),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F8FC),
        borderRadius: BorderRadius.circular(AppDimens.dp10),
        border: Border.all(color: const Color(0xFFDFE4ED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '时间范围',
            style: TextStyle(color: const Color(0xFF7D8A9A), fontSize: AppDimens.sp12),
          ),
          SizedBox(height: AppDimens.dp8),
          CustomDateRangePicker(
            startDate: range?.start,
            endDate: range?.end,
            compact: true,
            onDateRangeSelected: (start, end) {
              onChanged(_buildDateRange(start, end));
            },
          ),
        ],
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
  final date = start ?? end!;
  return DateTimeRange(start: date, end: date);
}

class _GovernanceCard extends StatelessWidget {
  const _GovernanceCard({required this.item, required this.controller});

  final HiddenDangerGovernanceItem item;
  final HiddenDangerGovernanceController controller;

  @override
  Widget build(BuildContext context) {
    final statusText = controller.statusText(item.status);

    return AppInfoStatusCard(
      title: item.pointName,
      statusText: statusText,
      statusStyle: _statusStyle(item.status),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '异常描述：${_emptyDash(item.abnormalDesc)}',
            style: TextStyle(color: const Color(0xFF3C4656), fontSize: AppDimens.sp12, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: AppDimens.dp6),
          Text(
            '上报人：${_emptyDash(item.reporter)}',
            style: TextStyle(color: const Color(0xFF5E6A7C), fontSize: AppDimens.sp12),
          ),
          SizedBox(height: AppDimens.dp6),
          Text(
            '是否紧急：${controller.urgentText(item.urgent)}',
            style: TextStyle(color: const Color(0xFF5E6A7C), fontSize: AppDimens.sp12),
          ),
          SizedBox(height: AppDimens.dp6),
          Text(
            '上报时间：${controller.reportTimeText(item.reportTime)}',
            style: TextStyle(color: const Color(0xFF5E6A7C), fontSize: AppDimens.sp12),
          ),
        ],
      ),
      trailingAction: _buildActionButtons(),
    );
  }

  Widget _buildActionButtons() {
    final buttons = <Widget>[
      SizedBox(
        width: AppDimens.dp56,
        height: AppDimens.dp26,
        child: OutlinedButton(
          onPressed: () => AppToast.showInfo('详情页待接入'),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF8DA0B8)),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.dp4)),
          ),
          child: Text(
            '查看',
            style: TextStyle(color: const Color(0xFF5D7189), fontSize: AppDimens.sp12),
          ),
        ),
      ),
    ];

    if (item.status == 0 || item.status == 1) {
      buttons.add(SizedBox(width: AppDimens.dp8));
      buttons.add(
        SizedBox(
          width: AppDimens.dp56,
          height: AppDimens.dp26,
          child: OutlinedButton(
            onPressed: () => AppToast.showInfo('${controller.actionText(item.status)}操作待接入'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF1F7BFF)),
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.dp4)),
            ),
            child: Text(
              controller.actionText(item.status),
              style: TextStyle(color: const Color(0xFF1F7BFF), fontSize: AppDimens.sp12),
            ),
          ),
        ),
      );
    }

    return Row(mainAxisSize: MainAxisSize.min, children: buttons);
  }

  AppCardStatusStyle _statusStyle(int status) {
    switch (status) {
      case 2:
        return const AppCardStatusStyle(textColor: Color(0xFF0E8C4C), backgroundColor: Color(0xFFE7F8EE), borderColor: Color(0xFFB8E8CC));
      case 3:
        return const AppCardStatusStyle(textColor: Color(0xFF64748B), backgroundColor: Color(0xFFF0F3F7), borderColor: Color(0xFFD6DFEA));
      default:
        return const AppCardStatusStyle(textColor: Color(0xFF1E4FCF), backgroundColor: Color(0xFFEAF1FF), borderColor: Color(0xFFC7D9FF));
    }
  }
}

String _emptyDash(String? value) {
  if (value == null || value.trim().isEmpty) return '--';
  return value;
}
