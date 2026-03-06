import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/components/app_standard_card.dart';
import '../../../../../core/components/toast/toast_widget.dart';
import '../../../../../core/components/custom_refresh.dart';
import '../../../../../core/components/custom_sliding_tab_bar.dart';
import '../../../../../core/components/date_picker/custom_date_range_picker.dart';
import '../../../../../core/constants/dimens.dart';
import '../../../../../data/models/workbench/park_inspection_plan_item_model.dart';
import '../../../../../data/models/workbench/park_inspection_task_item_model.dart';
import '../../../../../router/module_routes/workbench_routes.dart';
import 'park_inspection_controller.dart';

class ParkInspectionView extends GetView<ParkInspectionController> {
  const ParkInspectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParkInspectionController>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: const Text('园区巡检')),
          body: _ParkInspectionBody(controller: logic),
        );
      },
    );
  }
}

class _ParkInspectionBody extends StatefulWidget {
  const _ParkInspectionBody({required this.controller});

  final ParkInspectionController controller;

  @override
  State<_ParkInspectionBody> createState() => _ParkInspectionBodyState();
}

class _ParkInspectionBodyState extends State<_ParkInspectionBody>
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
  void didUpdateWidget(covariant _ParkInspectionBody oldWidget) {
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
              return CustomEasyRefreshList<ParkInspectionTaskItemModel>(
                key: ValueKey('park-inspection-$tabIndex'),
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
                    child: _TaskCard(item: item, controller: widget.controller),
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

  final ParkInspectionController controller;
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
          Row(
            children: [
              Expanded(
                child: CustomSlidingTabBar(
                  labels: controller.tabItems
                      .map((item) => item.label)
                      .toList(),
                  currentIndex: controller.currentTabIndex,
                  onChanged: controller.onTabChanged,
                  controller: tabController,
                ),
              ),
              SizedBox(width: AppDimens.dp8),
              FilledButton.icon(
                onPressed: () => _showDispatchSheet(context),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF1F7BFF),
                  padding: EdgeInsets.symmetric(horizontal: AppDimens.dp12),
                ),
                icon: const Icon(Icons.add_circle_outline, size: 16),
                label: const Text('派发'),
              ),
            ],
          ),
          SizedBox(height: AppDimens.dp8),
          Row(
            children: [
              Expanded(child: _KeywordField(controller: controller)),
              SizedBox(width: AppDimens.dp8),
              SizedBox(
                width: AppDimens.dp34,
                height: AppDimens.dp34,
                child: FilledButton(
                  onPressed: () => _showFilterSheet(context),
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

  Future<void> _showFilterSheet(BuildContext context) async {
    String? tempTypeCode = controller.selectedTypeCode;
    String? tempDispatchType = controller.selectedDispatchType;
    DateTimeRange? tempDateRange = controller.dateRange;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
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
                    _OptionDropdownField(
                      title: '巡检类型',
                      value: tempTypeCode,
                      options: controller.typeOptions,
                      onChanged: (value) {
                        setModalState(() => tempTypeCode = value);
                      },
                    ),
                    SizedBox(height: AppDimens.dp10),
                    _OptionDropdownField(
                      title: '派发方式',
                      value: tempDispatchType,
                      options: controller.dispatchOptions,
                      onChanged: (value) {
                        setModalState(() => tempDispatchType = value);
                      },
                    ),
                    SizedBox(height: AppDimens.dp10),
                    Text(
                      '任务日期',
                      style: TextStyle(
                        color: const Color(0xFF5D6B7D),
                        fontSize: AppDimens.sp12,
                      ),
                    ),
                    SizedBox(height: AppDimens.dp6),
                    CustomDateRangePicker(
                      startDate: tempDateRange?.start,
                      endDate: tempDateRange?.end,
                      compact: true,
                      onDateRangeSelected: (start, end) {
                        setModalState(() {
                          if (start == null || end == null) {
                            tempDateRange = null;
                          } else {
                            tempDateRange = DateTimeRange(
                              start: start,
                              end: end,
                            );
                          }
                        });
                      },
                    ),
                    SizedBox(height: AppDimens.dp14),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              controller.applyFilters(
                                nextTypeCode: null,
                                nextDispatchType: null,
                                nextDateRange: null,
                              );
                              Navigator.of(sheetContext).pop();
                            },
                            child: const Text('重置'),
                          ),
                        ),
                        SizedBox(width: AppDimens.dp10),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              controller.applyFilters(
                                nextTypeCode: tempTypeCode,
                                nextDispatchType: tempDispatchType,
                                nextDateRange: tempDateRange,
                              );
                              Navigator.of(sheetContext).pop();
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

  Future<void> _showDispatchSheet(BuildContext context) async {
    await controller.loadDispatchPlans();
    if (!context.mounted) return;

    final dateController = TextEditingController();
    String keyword = '';
    ParkInspectionPlanItemModel? selectedPlan;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF4F7FB),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredPlans = controller.dispatchPlans.where((item) {
              final text = '${item.planName ?? ''} ${(item.planCode ?? '')}'
                  .toLowerCase();
              return keyword.trim().isEmpty ||
                  text.contains(keyword.trim().toLowerCase());
            }).toList();

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppDimens.dp16,
                  AppDimens.dp12,
                  AppDimens.dp16,
                  AppDimens.dp16,
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.82,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: AppDimens.dp40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD0D8E6),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                      SizedBox(height: AppDimens.dp12),
                      Text(
                        '手动派发任务',
                        style: TextStyle(
                          color: const Color(0xFF223146),
                          fontSize: AppDimens.sp16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: AppDimens.dp12),
                      TextField(
                        onChanged: (value) {
                          setModalState(() => keyword = value);
                        },
                        decoration: InputDecoration(
                          hintText: '搜索计划名称',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AppDimens.dp12,
                            vertical: AppDimens.dp10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimens.dp10),
                            borderSide: const BorderSide(
                              color: Color(0xFFD9E2EF),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimens.dp10),
                            borderSide: const BorderSide(
                              color: Color(0xFFD9E2EF),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppDimens.dp12),
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(
                              width: AppDimens.dp150,
                              child: AppStandardCard(
                                child: controller.dispatchLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : ListView.separated(
                                        itemCount: filteredPlans.length,
                                        separatorBuilder: (context, index) =>
                                            Divider(
                                              height: 1,
                                              color: const Color(0xFFF0F2F6),
                                            ),
                                        itemBuilder: (context, index) {
                                          final item = filteredPlans[index];
                                          final selected =
                                              selectedPlan?.id == item.id;
                                          return InkWell(
                                            onTap: () {
                                              setModalState(() {
                                                selectedPlan = item;
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: AppDimens.dp10,
                                                vertical: AppDimens.dp10,
                                              ),
                                              decoration: BoxDecoration(
                                                color: selected
                                                    ? const Color(0xFFEFF5FF)
                                                    : null,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      AppDimens.dp10,
                                                    ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.planName ?? '--',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: const Color(
                                                        0xFF223146,
                                                      ),
                                                      fontSize: AppDimens.sp13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: AppDimens.dp4,
                                                  ),
                                                  Text(
                                                    item.planCode ?? '--',
                                                    style: TextStyle(
                                                      color: const Color(
                                                        0xFF7B8798,
                                                      ),
                                                      fontSize: AppDimens.sp11,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ),
                            SizedBox(width: AppDimens.dp12),
                            Expanded(
                              child: AppStandardCard(
                                child: selectedPlan == null
                                    ? const Center(child: Text('请选择左侧巡检计划'))
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _DetailLine(
                                            label: '计划名称',
                                            value:
                                                selectedPlan!.planName ?? '--',
                                          ),
                                          _DetailLine(
                                            label: '计划编码',
                                            value:
                                                selectedPlan!.planCode ?? '--',
                                          ),
                                          _DetailLine(
                                            label: '巡检类型',
                                            value: controller.typeText(
                                              selectedPlan!.typeCode,
                                            ),
                                          ),
                                          _DetailLine(
                                            label: '多人巡检',
                                            value:
                                                (selectedPlan!.isMultiPerson ??
                                                        '') ==
                                                    '1'
                                                ? '是'
                                                : '否',
                                          ),
                                          SizedBox(height: AppDimens.dp12),
                                          Text(
                                            '任务日期',
                                            style: TextStyle(
                                              color: const Color(0xFF5D6B7D),
                                              fontSize: AppDimens.sp12,
                                            ),
                                          ),
                                          SizedBox(height: AppDimens.dp6),
                                          TextField(
                                            controller: dateController,
                                            readOnly: true,
                                            onTap: () async {
                                              final picked =
                                                  await showDatePicker(
                                                    context: context,
                                                    firstDate: DateTime(2024),
                                                    lastDate: DateTime(2100),
                                                    initialDate: DateTime.now(),
                                                  );
                                              if (picked == null) return;
                                              dateController.text =
                                                  '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                                            },
                                            decoration: InputDecoration(
                                              hintText: '请选择任务日期',
                                              suffixIcon: const Icon(
                                                Icons.date_range_rounded,
                                              ),
                                              filled: true,
                                              fillColor: const Color(
                                                0xFFF7F9FC,
                                              ),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    horizontal: AppDimens.dp12,
                                                    vertical: AppDimens.dp10,
                                                  ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      AppDimens.dp10,
                                                    ),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFFD9E2EF),
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      AppDimens.dp10,
                                                    ),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFFD9E2EF),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppDimens.dp12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(sheetContext).pop(),
                              child: const Text('取消'),
                            ),
                          ),
                          SizedBox(width: AppDimens.dp10),
                          Expanded(
                            child: FilledButton(
                              onPressed: controller.dispatchSubmitting
                                  ? null
                                  : () async {
                                      if (selectedPlan?.id == null) {
                                        AppToast.showWarning('请选择巡检计划');
                                        return;
                                      }
                                      if (dateController.text.trim().isEmpty) {
                                        AppToast.showWarning('请选择任务日期');
                                        return;
                                      }
                                      final success = await controller
                                          .dispatchTask(
                                            planId: selectedPlan!.id!,
                                            taskDate: dateController.text
                                                .trim(),
                                          );
                                      if (success && context.mounted) {
                                        Navigator.of(sheetContext).pop();
                                      }
                                    },
                              child: controller.dispatchSubmitting
                                  ? const SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('派发'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
    dateController.dispose();
  }
}

class _KeywordField extends StatelessWidget {
  const _KeywordField({required this.controller});

  final ParkInspectionController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimens.dp34,
      child: TextField(
        controller: controller.keywordController,
        textInputAction: TextInputAction.search,
        onSubmitted: controller.applyKeyword,
        decoration: InputDecoration(
          hintText: '请输入任务编码',
          hintStyle: TextStyle(
            color: const Color(0xFF9AA2AE),
            fontSize: AppDimens.sp12,
          ),
          isCollapsed: true,
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppDimens.dp10,
            vertical: AppDimens.dp10,
          ),
          filled: true,
          fillColor: const Color(0xFFF6F8FC),
          suffixIcon: IconButton(
            onPressed: () =>
                controller.applyKeyword(controller.keywordController.text),
            icon: const Icon(Icons.search, size: 18),
          ),
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

class _OptionDropdownField extends StatelessWidget {
  const _OptionDropdownField({
    required this.title,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String title;
  final String? value;
  final List<ParkInspectionOption> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: const Color(0xFF5D6B7D),
            fontSize: AppDimens.sp12,
          ),
        ),
        SizedBox(height: AppDimens.dp6),
        DropdownButtonFormField<String?>(
          initialValue: value,
          items: options
              .map(
                (item) => DropdownMenuItem<String?>(
                  value: item.value,
                  child: Text(item.label),
                ),
              )
              .toList(),
          onChanged: onChanged,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
      ],
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({required this.item, required this.controller});

  final ParkInspectionTaskItemModel item;
  final ParkInspectionController controller;

  @override
  Widget build(BuildContext context) {
    return AppStandardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.planName ?? '--',
                      style: TextStyle(
                        color: const Color(0xFF223146),
                        fontSize: AppDimens.sp14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: AppDimens.dp4),
                    Text(
                      '任务编码：${item.taskCode ?? '--'}',
                      style: TextStyle(
                        color: const Color(0xFF7B8798),
                        fontSize: AppDimens.sp11,
                      ),
                    ),
                  ],
                ),
              ),
              _PillBadge(
                text: controller.taskStatusText(item.taskStatus),
                color: controller.taskStatusColor(item.taskStatus),
              ),
            ],
          ),
          SizedBox(height: AppDimens.dp12),
          Wrap(
            spacing: AppDimens.dp8,
            runSpacing: AppDimens.dp8,
            children: [
              _MetricChip(
                label: '巡检类型',
                value: controller.typeText(item.typeCode),
              ),
              _MetricChip(
                label: '派发方式',
                value: controller.dispatchTypeText(item.dispatchType),
              ),
              _MetricChip(label: '执行人', value: item.executorName ?? '--'),
              _MetricChip(label: '任务日期', value: item.taskDate ?? '--'),
            ],
          ),
          SizedBox(height: AppDimens.dp12),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: '总点位',
                  value: '${item.totalPoints}',
                  color: const Color(0xFF4A84F5),
                ),
              ),
              SizedBox(width: AppDimens.dp8),
              Expanded(
                child: _MiniStat(
                  label: '已完成',
                  value: '${item.completedPoints}',
                  color: const Color(0xFF22A06B),
                ),
              ),
              SizedBox(width: AppDimens.dp8),
              Expanded(
                child: _MiniStat(
                  label: '异常数',
                  value: '${item.abnormalCount}',
                  color: const Color(0xFFE06A4B),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimens.dp12),
          Row(
            children: [
              _PillBadge(
                text: controller.resultStatusText(item.resultStatus),
                color: controller.resultStatusColor(item.resultStatus),
                soft: true,
              ),
              const Spacer(),
              TextButton(
                onPressed: () async {
                  final changed = await WorkbenchRoutes.toParkInspectionDetail(
                    item: item,
                  );
                  if (changed == true) controller.refreshPage();
                },
                child: const Text('查看'),
              ),
              FilledButton(
                onPressed: () async {
                  final changed = await WorkbenchRoutes.toParkInspectionDetail(
                    item: item,
                  );
                  if (changed == true) controller.refreshPage();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF1F7BFF),
                ),
                child: Text(controller.primaryActionText(item)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PillBadge extends StatelessWidget {
  const _PillBadge({
    required this.text,
    required this.color,
    this.soft = false,
  });

  final String text;
  final Color color;
  final bool soft;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp10,
        vertical: AppDimens.dp5,
      ),
      decoration: BoxDecoration(
        color: soft ? color.withValues(alpha: 0.12) : color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: soft ? color : Colors.white,
          fontSize: AppDimens.sp11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.label, required this.value});

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
        color: const Color(0xFFF7FAFF),
        borderRadius: BorderRadius.circular(AppDimens.dp10),
      ),
      child: Text(
        '$label：$value',
        style: TextStyle(
          color: const Color(0xFF4B5A6C),
          fontSize: AppDimens.sp11,
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp10,
        vertical: AppDimens.dp10,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDimens.dp10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF7B8798),
              fontSize: AppDimens.sp11,
            ),
          ),
          SizedBox(height: AppDimens.dp6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: AppDimens.sp16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimens.dp10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppDimens.dp80,
            child: Text(
              '$label：',
              style: TextStyle(
                color: const Color(0xFF7B8798),
                fontSize: AppDimens.sp12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: const Color(0xFF223146),
                fontSize: AppDimens.sp12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
