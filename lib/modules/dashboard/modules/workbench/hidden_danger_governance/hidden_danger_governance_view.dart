import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/components/app_info_status_card.dart';
import '../../../../../core/components/custom_refresh.dart';
import '../../../../../core/components/custom_sliding_tab_bar.dart';
import '../../../../../core/components/date_picker/custom_date_range_picker.dart';
import '../../../../../core/components/select/app_user_select_field.dart';
import '../../../../../core/components/toast/toast_widget.dart';
import '../../../../../core/constants/dimens.dart';
import '../../../../../data/models/workbench/inspection_abnormal_item_model.dart';
import '../../../../../data/models/workbench/inspection_rectification_item_model.dart';
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
              return CustomEasyRefreshList<InspectionAbnormalItemModel>(
                key: ValueKey('hidden-danger-$tabIndex'),
                refreshTrigger: widget.controller.refreshTrigger,
                pageSize: 20,
                dataLoader: (pageIndex, pageSize) => widget.controller.loadPageByTab(tabIndex, pageIndex, pageSize),
                padding: EdgeInsets.fromLTRB(AppDimens.dp12, AppDimens.dp8, AppDimens.dp12, AppDimens.dp12),
                itemBuilder: (context, item, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: AppDimens.dp10),
                    child: _GovernanceCard(
                      item: item,
                      controller: widget.controller,
                      onView: () => _openDetailBottomSheet(context, widget.controller, item),
                      onPrimaryAction: () => _handlePrimaryAction(context, widget.controller, item),
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

  Future<void> _handlePrimaryAction(BuildContext context, HiddenDangerGovernanceController controller, InspectionAbnormalItemModel item) async {
    final status = (item.abnormalStatus ?? '').trim();
    if (status == HiddenDangerAbnormalStatus.pendingConfirm) {
      await _showConfirmDialog(context, controller, item);
      return;
    }
    if (status == HiddenDangerAbnormalStatus.pendingRectify || status == HiddenDangerAbnormalStatus.rectifying) {
      await _showRectifyDialog(context, controller, item);
      return;
    }
    if (status == HiddenDangerAbnormalStatus.pendingVerify) {
      await _showVerifyDialog(context, controller, item);
      return;
    }
    if (status == HiddenDangerAbnormalStatus.reassign) {
      await _showReassignDialog(context, controller, item);
      return;
    }
  }

  Future<void> _openDetailBottomSheet(BuildContext context, HiddenDangerGovernanceController controller, InspectionAbnormalItemModel item) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(AppDimens.dp12, AppDimens.dp10, AppDimens.dp12, AppDimens.dp12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '异常详情',
                style: TextStyle(fontSize: AppDimens.sp16, fontWeight: FontWeight.w700, color: const Color(0xFF1E2A3A)),
              ),
              SizedBox(height: AppDimens.dp10),
              _DetailLine(label: '巡检点位', value: controller.displayPointName(item)),
              _DetailLine(label: '巡检细则', value: controller.displayRuleName(item)),
              _DetailLine(label: '上报人', value: controller.displayReporterName(item)),
              _DetailLine(label: '是否紧急', value: controller.urgentText(item.isUrgent)),
              _DetailLine(label: '异常状态', value: controller.statusText(item.abnormalStatus)),
              _DetailLine(label: '上报时间', value: controller.displayReportTime(item)),
              _DetailLine(label: '责任对象', value: _emptyDash(item.responsibleName)),
              _DetailLine(label: '异常描述', value: controller.displayAbnormalDesc(item)),
              SizedBox(height: AppDimens.dp8),
              Text(
                '整改记录',
                style: TextStyle(fontSize: AppDimens.sp14, fontWeight: FontWeight.w700, color: const Color(0xFF1E2A3A)),
              ),
              SizedBox(height: AppDimens.dp6),
              SizedBox(
                height: AppDimens.dp220,
                child: FutureBuilder<List<InspectionRectificationItemModel>>(
                  future: controller.loadRectifications(abnormalId: (item.id ?? '').trim()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text('整改记录加载失败'));
                    }
                    final records = snapshot.data ?? const [];
                    if (records.isEmpty) {
                      return const Center(child: Text('暂无整改记录'));
                    }
                    return ListView.separated(
                      itemCount: records.length,
                      separatorBuilder: (_, _) => SizedBox(height: AppDimens.dp6),
                      itemBuilder: (context, index) {
                        final row = records[index];
                        return Container(
                          padding: EdgeInsets.all(AppDimens.dp8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F8FC),
                            borderRadius: BorderRadius.circular(AppDimens.dp8),
                            border: Border.all(color: const Color(0xFFDFE4ED)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('整改类型：${controller.rectifyTypeText(row.rectifyType)}', style: TextStyle(fontSize: AppDimens.sp11)),
                              SizedBox(height: AppDimens.dp2),
                              Text('整改人：${_emptyDash(row.rectifyUserName)}', style: TextStyle(fontSize: AppDimens.sp11)),
                              SizedBox(height: AppDimens.dp2),
                              Text('整改描述：${_emptyDash(row.rectifyDesc)}', style: TextStyle(fontSize: AppDimens.sp11)),
                              SizedBox(height: AppDimens.dp2),
                              Text('核查结果：${controller.verifyResultText(row.verifyResult)}', style: TextStyle(fontSize: AppDimens.sp11)),
                              SizedBox(height: AppDimens.dp2),
                              Text('状态：${controller.rectifyStatusText(row.status)}', style: TextStyle(fontSize: AppDimens.sp11)),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: AppDimens.dp10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (controller.canShowPrimaryAction(item.abnormalStatus))
                    SizedBox(
                      width: AppDimens.dp80,
                      height: AppDimens.dp30,
                      child: OutlinedButton(
                        onPressed: () async {
                          Navigator.of(sheetContext).pop();
                          await _handlePrimaryAction(context, controller, item);
                        },
                        child: Text(controller.actionText(item.abnormalStatus)),
                      ),
                    ),
                  if (controller.canShowPrimaryAction(item.abnormalStatus)) SizedBox(width: AppDimens.dp8),
                  SizedBox(
                    width: AppDimens.dp80,
                    height: AppDimens.dp30,
                    child: FilledButton(onPressed: () => Navigator.of(sheetContext).pop(), child: const Text('关闭')),
                  ),
                ],
              ),
            ],
          ),
        );
      },
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
    String? tempStatus = controller.selectedStatus;
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
          hintText: '请输入巡检点位、异常描述',
          hintStyle: TextStyle(color: const Color(0xFF9AA2AE), fontSize: AppDimens.sp12),
          contentPadding: EdgeInsets.symmetric(horizontal: AppDimens.dp10, vertical: AppDimens.dp8),
          filled: true,
          fillColor: const Color(0xFFF6F8FC),
          suffixIcon: IconButton(onPressed: () => controller.applyKeyword(controller.keywordController.text), icon: const Icon(Icons.search, size: 18)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.dp4),
            borderSide: const BorderSide(color: Color(0xFFDADDE3)),
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
  final String? value;
  final List<HiddenDangerStatusOption> options;
  final ValueChanged<String?> onChanged;

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
        child: DropdownButton<String?>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          style: TextStyle(color: const Color(0xFF333333), fontSize: AppDimens.sp12),
          onChanged: onChanged,
          hint: Text(
            title,
            style: TextStyle(color: const Color(0xFF7D8A9A), fontSize: AppDimens.sp12),
          ),
          items: options.map((item) => DropdownMenuItem<String?>(value: item.value, child: Text(item.label))).toList(),
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
  const _GovernanceCard({required this.item, required this.controller, required this.onView, required this.onPrimaryAction});

  final InspectionAbnormalItemModel item;
  final HiddenDangerGovernanceController controller;
  final VoidCallback onView;
  final VoidCallback onPrimaryAction;

  @override
  Widget build(BuildContext context) {
    final statusText = controller.statusText(item.abnormalStatus);

    return AppInfoStatusCard(
      title: controller.displayPointName(item),
      statusText: statusText,
      statusStyle: _statusStyle(item.abnormalStatus),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '巡检细则：${controller.displayRuleName(item)}',
            style: TextStyle(color: const Color(0xFF3C4656), fontSize: AppDimens.sp12, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: AppDimens.dp6),
          Text(
            '异常描述：${controller.displayAbnormalDesc(item)}',
            style: TextStyle(color: const Color(0xFF5E6A7C), fontSize: AppDimens.sp12),
          ),
          SizedBox(height: AppDimens.dp6),
          Text(
            '上报人：${controller.displayReporterName(item)}',
            style: TextStyle(color: const Color(0xFF5E6A7C), fontSize: AppDimens.sp12),
          ),
          SizedBox(height: AppDimens.dp6),
          Text(
            '是否紧急：${controller.urgentText(item.isUrgent)}',
            style: TextStyle(color: const Color(0xFF5E6A7C), fontSize: AppDimens.sp12),
          ),
          SizedBox(height: AppDimens.dp6),
          Text(
            '上报时间：${controller.displayReportTime(item)}',
            style: TextStyle(color: const Color(0xFF5E6A7C), fontSize: AppDimens.sp12),
          ),
          SizedBox(height: AppDimens.dp6),
          Text(
            '现场照片：${controller.displayPhotoSummary(item.photoUrls)}',
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
          onPressed: onView,
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

    if (controller.canShowPrimaryAction(item.abnormalStatus)) {
      buttons.add(SizedBox(width: AppDimens.dp8));
      buttons.add(
        SizedBox(
          width: AppDimens.dp56,
          height: AppDimens.dp26,
          child: OutlinedButton(
            onPressed: onPrimaryAction,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF1F7BFF)),
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.dp4)),
            ),
            child: Text(
              controller.actionText(item.abnormalStatus),
              style: TextStyle(color: const Color(0xFF1F7BFF), fontSize: AppDimens.sp12),
            ),
          ),
        ),
      );
    }

    return Row(mainAxisSize: MainAxisSize.min, children: buttons);
  }

  AppCardStatusStyle _statusStyle(String? status) {
    if (status == HiddenDangerAbnormalStatus.completed) {
      return const AppCardStatusStyle(textColor: Color(0xFF0E8C4C), backgroundColor: Color(0xFFE7F8EE), borderColor: Color(0xFFB8E8CC));
    }
    if (status == HiddenDangerAbnormalStatus.reassign) {
      return const AppCardStatusStyle(textColor: Color(0xFFDA5A18), backgroundColor: Color(0xFFFFF1E8), borderColor: Color(0xFFF6D0B8));
    }
    return const AppCardStatusStyle(textColor: Color(0xFF1E4FCF), backgroundColor: Color(0xFFEAF1FF), borderColor: Color(0xFFC7D9FF));
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimens.dp4),
      child: Text(
        '$label：$value',
        style: TextStyle(color: const Color(0xFF3C4656), fontSize: AppDimens.sp12),
      ),
    );
  }
}

Future<void> _showConfirmDialog(BuildContext context, HiddenDangerGovernanceController controller, InspectionAbnormalItemModel item) async {
  final enterpriseNameController = TextEditingController();
  final deadlineController = TextEditingController();

  String verifyResult = 'CONFIRMED';
  String? responsibleType;
  AppSelectedUser? selectedResponsibleUser;
  AppSelectedUser? selectedRectifyUser;
  bool submitting = false;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('确认异常'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _DialogDropdownField<String>(
                    label: '核验结果',
                    value: verifyResult,
                    items: const [
                      DropdownMenuItem(value: 'CONFIRMED', child: Text('确认')),
                      DropdownMenuItem(value: 'REJECTED', child: Text('驳回')),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setDialogState(() => verifyResult = value);
                    },
                  ),
                  if (verifyResult == 'CONFIRMED') ...[
                    SizedBox(height: AppDimens.dp8),
                    _DialogDropdownField<String?>(
                      label: '责任类型',
                      value: responsibleType,
                      items: const [
                        DropdownMenuItem<String?>(value: 'ENTERPRISE', child: Text('企业')),
                        DropdownMenuItem<String?>(value: 'PERSONNEL', child: Text('个人')),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          responsibleType = value;
                          if (value != 'PERSONNEL') {
                            selectedResponsibleUser = null;
                          }
                          if (value != 'ENTERPRISE') {
                            enterpriseNameController.clear();
                          }
                        });
                      },
                    ),
                    SizedBox(height: AppDimens.dp8),
                    if (responsibleType == 'ENTERPRISE') _DialogTextField(controller: enterpriseNameController, label: '责任对象名称', hintText: '请输入企业/部门名称'),
                    if (responsibleType == 'PERSONNEL')
                      AppUserSelectField(
                        label: '责任对象名称',
                        hintText: '请选择责任人员',
                        value: selectedResponsibleUser,
                        required: true,
                        onChanged: (value) {
                          setDialogState(() {
                            selectedResponsibleUser = value;
                          });
                        },
                      ),
                    SizedBox(height: AppDimens.dp8),
                    AppUserSelectField(
                      label: '整改人员',
                      hintText: '请选择整改人员',
                      value: selectedRectifyUser,
                      required: true,
                      onChanged: (value) {
                        setDialogState(() {
                          selectedRectifyUser = value;
                        });
                      },
                    ),
                    SizedBox(height: AppDimens.dp8),
                    _DialogDateTimeField(controller: deadlineController, label: '整改期限'),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: submitting ? null : () => Navigator.of(dialogContext).pop(), child: const Text('取消')),
              FilledButton(
                onPressed: submitting
                    ? null
                    : () async {
                        if (verifyResult == 'CONFIRMED') {
                          if ((responsibleType ?? '').isEmpty) {
                            AppToast.showWarning('请选择责任类型');
                            return;
                          }
                          if (responsibleType == 'ENTERPRISE') {
                            if (enterpriseNameController.text.trim().isEmpty) {
                              AppToast.showWarning('请输入责任对象名称');
                              return;
                            }
                          } else {
                            if (selectedResponsibleUser == null) {
                              AppToast.showWarning('请选择责任人员');
                              return;
                            }
                          }
                          if (selectedRectifyUser == null) {
                            AppToast.showWarning('请选择整改人员');
                            return;
                          }
                          if (deadlineController.text.trim().isEmpty) {
                            AppToast.showWarning('请选择整改期限');
                            return;
                          }
                        }
                        setDialogState(() => submitting = true);
                        final success = await controller.confirmAbnormal(
                          item: item,
                          verifyResult: verifyResult,
                          responsibleType: responsibleType,
                          responsibleId: responsibleType == 'PERSONNEL' ? selectedResponsibleUser?.id : null,
                          responsibleName: responsibleType == 'PERSONNEL' ? selectedResponsibleUser?.displayName : enterpriseNameController.text.trim(),
                          rectifyUserId: selectedRectifyUser?.id,
                          rectifyUserName: selectedRectifyUser?.displayName,
                          deadline: deadlineController.text.trim(),
                        );
                        setDialogState(() => submitting = false);
                        if (success && dialogContext.mounted) {
                          Navigator.of(dialogContext).pop();
                        }
                      },
                child: const Text('确定'),
              ),
            ],
          );
        },
      );
    },
  );

  enterpriseNameController.dispose();
  deadlineController.dispose();
}

Future<void> _showRectifyDialog(BuildContext context, HiddenDangerGovernanceController controller, InspectionAbnormalItemModel item) async {
  final descController = TextEditingController();
  final photoUrlsController = TextEditingController();
  AppSelectedUser? selectedRectifyUser;

  bool submitting = false;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('提交整改'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppUserSelectField(
                    label: '整改人员',
                    hintText: '请选择整改人员',
                    value: selectedRectifyUser,
                    required: true,
                    onChanged: (value) {
                      setDialogState(() {
                        selectedRectifyUser = value;
                      });
                    },
                  ),
                  SizedBox(height: AppDimens.dp8),
                  _DialogTextField(controller: descController, label: '整改描述', hintText: '请输入整改描述', maxLines: 3),
                  SizedBox(height: AppDimens.dp8),
                  _DialogTextField(controller: photoUrlsController, label: '整改照片ID', hintText: '逗号分隔，可选'),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: submitting ? null : () => Navigator.of(dialogContext).pop(), child: const Text('取消')),
              FilledButton(
                onPressed: submitting
                    ? null
                    : () async {
                        if (selectedRectifyUser == null) {
                          AppToast.showWarning('请选择整改人员');
                          return;
                        }
                        if (descController.text.trim().isEmpty) {
                          AppToast.showWarning('请输入整改描述');
                          return;
                        }
                        final photoUrls = photoUrlsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                        setDialogState(() => submitting = true);
                        final success = await controller.submitRectification(
                          item: item,
                          rectifyUserId: selectedRectifyUser?.id ?? '',
                          rectifyUserName: selectedRectifyUser?.displayName ?? '',
                          rectifyDesc: descController.text.trim(),
                          photoUrls: photoUrls.isEmpty ? null : photoUrls,
                        );
                        setDialogState(() => submitting = false);
                        if (success && dialogContext.mounted) {
                          Navigator.of(dialogContext).pop();
                        }
                      },
                child: const Text('确定'),
              ),
            ],
          );
        },
      );
    },
  );

  descController.dispose();
  photoUrlsController.dispose();
}

Future<void> _showVerifyDialog(BuildContext context, HiddenDangerGovernanceController controller, InspectionAbnormalItemModel item) async {
  final abnormalId = (item.id ?? '').trim();
  if (abnormalId.isEmpty) {
    AppToast.showWarning('异常ID为空，无法核查');
    return;
  }
  List<InspectionRectificationItemModel> records = const [];
  try {
    records = await controller.loadRectifications(abnormalId: abnormalId, forceRefresh: true);
  } catch (_) {
    return;
  }
  final latest = controller.pickLatestPendingVerifyRectification(records);
  if (latest?.id == null || (latest!.id ?? '').trim().isEmpty) {
    AppToast.showWarning('未找到待核查整改记录');
    return;
  }

  String verifyResult = 'PASS';
  final commentController = TextEditingController();
  bool submitting = false;

  if (!context.mounted) return;
  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('核查整改'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('整改人：${_emptyDash(latest.rectifyUserName)}', style: TextStyle(fontSize: AppDimens.sp12)),
                  SizedBox(height: AppDimens.dp4),
                  Text('整改描述：${_emptyDash(latest.rectifyDesc)}', style: TextStyle(fontSize: AppDimens.sp12)),
                  SizedBox(height: AppDimens.dp8),
                  _DialogDropdownField<String>(
                    label: '核查结果',
                    value: verifyResult,
                    items: const [
                      DropdownMenuItem(value: 'PASS', child: Text('通过')),
                      DropdownMenuItem(value: 'REJECT', child: Text('驳回')),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setDialogState(() => verifyResult = value);
                    },
                  ),
                  SizedBox(height: AppDimens.dp8),
                  _DialogTextField(controller: commentController, label: '核查意见', hintText: '请输入核查意见', maxLines: 3),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: submitting ? null : () => Navigator.of(dialogContext).pop(), child: const Text('取消')),
              FilledButton(
                onPressed: submitting
                    ? null
                    : () async {
                        setDialogState(() => submitting = true);
                        final success = await controller.verifyRectification(
                          item: item,
                          rectificationId: (latest.id ?? '').trim(),
                          verifyResult: verifyResult,
                          verifyComment: commentController.text.trim(),
                        );
                        setDialogState(() => submitting = false);
                        if (success && dialogContext.mounted) {
                          Navigator.of(dialogContext).pop();
                        }
                      },
                child: const Text('确定'),
              ),
            ],
          );
        },
      );
    },
  );

  commentController.dispose();
}

Future<void> _showReassignDialog(BuildContext context, HiddenDangerGovernanceController controller, InspectionAbnormalItemModel item) async {
  final reasonController = TextEditingController();
  AppSelectedUser? selectedUser;

  bool submitting = false;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('重新指派'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppUserSelectField(
                    label: '新整改人员',
                    hintText: '请选择新整改人员',
                    value: selectedUser,
                    required: true,
                    onChanged: (value) {
                      setDialogState(() {
                        selectedUser = value;
                      });
                    },
                  ),
                  SizedBox(height: AppDimens.dp8),
                  _DialogTextField(controller: reasonController, label: '指派原因', hintText: '请输入重新指派原因', maxLines: 3),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: submitting ? null : () => Navigator.of(dialogContext).pop(), child: const Text('取消')),
              FilledButton(
                onPressed: submitting
                    ? null
                    : () async {
                        if (selectedUser == null) {
                          AppToast.showWarning('请选择新整改人员');
                          return;
                        }
                        setDialogState(() => submitting = true);
                        final success = await controller.reassignAbnormal(
                          item: item,
                          newRectifyUserId: selectedUser?.id ?? '',
                          newRectifyUserName: selectedUser?.displayName ?? '',
                          reassignReason: reasonController.text.trim(),
                        );
                        setDialogState(() => submitting = false);
                        if (success && dialogContext.mounted) {
                          Navigator.of(dialogContext).pop();
                        }
                      },
                child: const Text('确定'),
              ),
            ],
          );
        },
      );
    },
  );

  reasonController.dispose();
}

class _DialogTextField extends StatelessWidget {
  const _DialogTextField({required this.controller, required this.label, required this.hintText, this.maxLines = 1});

  final TextEditingController controller;
  final String label;
  final String hintText;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: AppDimens.sp12)),
        SizedBox(height: AppDimens.dp4),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            isDense: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimens.dp6)),
          ),
        ),
      ],
    );
  }
}

class _DialogDropdownField<T> extends StatelessWidget {
  const _DialogDropdownField({required this.label, required this.value, required this.items, required this.onChanged});

  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: AppDimens.sp12)),
        SizedBox(height: AppDimens.dp4),
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items,
          onChanged: onChanged,
          decoration: InputDecoration(isDense: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimens.dp6))),
        ),
      ],
    );
  }
}

class _DialogDateTimeField extends StatelessWidget {
  const _DialogDateTimeField({required this.controller, required this.label});

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: AppDimens.sp12)),
        SizedBox(height: AppDimens.dp4),
        TextField(
          controller: controller,
          readOnly: true,
          onTap: () async {
            final now = DateTime.now();
            final date = await showDatePicker(context: context, initialDate: now, firstDate: DateTime(now.year - 2, 1, 1), lastDate: DateTime(now.year + 3, 12, 31));
            if (date == null || !context.mounted) return;
            final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(now));
            if (time == null) return;
            final full = DateTime(date.year, date.month, date.day, time.hour, time.minute, 0);
            controller.text = _formatDateTime(full);
          },
          decoration: InputDecoration(
            hintText: '请选择时间',
            isDense: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimens.dp6)),
          ),
        ),
      ],
    );
  }
}

String _formatDateTime(DateTime dateTime) {
  String pad2(int value) => value.toString().padLeft(2, '0');
  return '${dateTime.year}-${pad2(dateTime.month)}-${pad2(dateTime.day)} '
      '${pad2(dateTime.hour)}:${pad2(dateTime.minute)}:${pad2(dateTime.second)}';
}

String _emptyDash(String? value) {
  if (value == null || value.trim().isEmpty) return '--';
  return value;
}
