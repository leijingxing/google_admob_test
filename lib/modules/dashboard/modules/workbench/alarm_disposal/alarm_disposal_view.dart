import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/components/app_info_status_card.dart';
import '../../../../../core/components/app_text_field.dart';
import '../../../../../core/components/custom_refresh.dart';
import '../../../../../core/components/custom_sliding_tab_bar.dart';
import '../../../../../core/components/date_picker/custom_date_range_picker.dart';
import '../../../../../core/constants/dimens.dart';
import '../../../../../data/models/workbench/risk_warning_disposal_item_model.dart';
import '../../../../../router/module_routes/workbench_routes.dart';
import 'alarm_disposal_controller.dart';

/// 报警处置页面。
class AlarmDisposalView extends GetView<AlarmDisposalController> {
  const AlarmDisposalView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlarmDisposalController>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: Text(logic.pageTitle)),
          body: _AlarmDisposalBody(controller: logic),
        );
      },
    );
  }
}

class _AlarmDisposalBody extends StatefulWidget {
  const _AlarmDisposalBody({required this.controller});

  final AlarmDisposalController controller;

  @override
  State<_AlarmDisposalBody> createState() => _AlarmDisposalBodyState();
}

class _AlarmDisposalBodyState extends State<_AlarmDisposalBody>
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
  void didUpdateWidget(covariant _AlarmDisposalBody oldWidget) {
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
        _AlarmFilterSection(
          controller: widget.controller,
          tabController: _tabController,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: List.generate(widget.controller.tabItems.length, (
              tabIndex,
            ) {
              return CustomEasyRefreshList<RiskWarningDisposalItemModel>(
                key: ValueKey('alarm-disposal-$tabIndex'),
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
                    child: _AlarmDisposalCard(
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

class _AlarmFilterSection extends StatelessWidget {
  const _AlarmFilterSection({
    required this.controller,
    required this.tabController,
  });

  final AlarmDisposalController controller;
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
      padding: EdgeInsets.all(AppDimens.dp10),
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
                child: AppTextField.search(
                  controller: controller.keywordController,
                  hintText: '请输入报警名称或内容',
                  onSubmitted: controller.applyKeyword,
                  onSearch: () => controller.applyKeyword(
                    controller.keywordController.text,
                  ),
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
    int? tempWarningLevel = controller.selectedWarningLevel;
    DateTimeRange? tempDateRange = controller.dateRange;

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
                    _AlarmLevelDropdown(
                      value: tempWarningLevel,
                      options: controller.levelOptions,
                      onChanged: (value) {
                        setModalState(() => tempWarningLevel = value);
                      },
                    ),
                    SizedBox(height: AppDimens.dp10),
                    Text(
                      '报警时间',
                      style: TextStyle(
                        color: const Color(0xFF7D8A9A),
                        fontSize: AppDimens.sp11,
                      ),
                    ),
                    SizedBox(height: AppDimens.dp4),
                    CustomDateRangePicker(
                      startDate: tempDateRange?.start,
                      endDate: tempDateRange?.end,
                      onDateRangeSelected: (start, end) {
                        setModalState(() {
                          if (start == null || end == null) {
                            tempDateRange = null;
                            return;
                          }
                          final left = start.isBefore(end) ? start : end;
                          final right = start.isBefore(end) ? end : start;
                          tempDateRange = DateTimeRange(
                            start: left,
                            end: right,
                          );
                        });
                      },
                      compact: true,
                    ),
                    SizedBox(height: AppDimens.dp14),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              controller.applyFilters(
                                nextWarningLevel: null,
                                nextDateRange: null,
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
                                nextWarningLevel: tempWarningLevel,
                                nextDateRange: tempDateRange,
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

class _AlarmLevelDropdown extends StatelessWidget {
  const _AlarmLevelDropdown({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final int? value;
  final List<AlarmWarningLevelOption> options;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimens.dp34,
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
          onChanged: onChanged,
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

class _AlarmDisposalCard extends StatelessWidget {
  const _AlarmDisposalCard({required this.item, required this.controller});

  final RiskWarningDisposalItemModel item;
  final AlarmDisposalController controller;

  @override
  Widget build(BuildContext context) {
    return AppInfoStatusCard(
      title: _display(item.title),
      statusText: controller.statusText(item.warningStatus),
      statusStyle: controller.statusStyle(item.warningStatus),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow('报警内容', _display(item.description)),
          SizedBox(height: AppDimens.dp6),
          _infoRow('报警等级', controller.warningLevelText(item.warningLevel)),
          SizedBox(height: AppDimens.dp6),
          _infoRow('报警开始时间', _display(item.warningStartTime)),
          SizedBox(height: AppDimens.dp6),
          _infoRow('报警结束时间', _display(item.warningEndTime)),
        ],
      ),
      trailingAction: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: AppDimens.dp56,
            height: AppDimens.dp26,
            child: OutlinedButton(
              onPressed: () =>
                  WorkbenchRoutes.toAlarmDisposalDetail(item: item),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF8DA0B8)),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.dp4),
                ),
              ),
              child: Text(
                '详情',
                style: TextStyle(
                  color: const Color(0xFF5D7189),
                  fontSize: AppDimens.sp12,
                ),
              ),
            ),
          ),
          if (item.warningStatus == 0) ...[
            SizedBox(width: AppDimens.dp8),
            SizedBox(
              width: AppDimens.dp56,
              height: AppDimens.dp26,
              child: OutlinedButton(
                onPressed: () async {
                  final handled = await WorkbenchRoutes.toAlarmDisposalHandle(
                    item: item,
                  );
                  if (handled == true) {
                    controller.refreshTrigger.value++;
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
                  '处置',
                  style: TextStyle(
                    color: const Color(0xFF1F7BFF),
                    fontSize: AppDimens.sp12,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Text(
      '$label：$value',
      style: TextStyle(
        color: const Color(0xFF5E6A7C),
        fontSize: AppDimens.sp12,
      ),
    );
  }

  String _display(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? '--' : text;
  }
}
