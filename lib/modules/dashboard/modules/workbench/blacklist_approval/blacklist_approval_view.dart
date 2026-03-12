import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/components/app_info_status_card.dart';
import '../../../../../core/components/app_text_field.dart';
import '../../../../../core/components/custom_refresh.dart';
import '../../../../../core/components/custom_sliding_tab_bar.dart';
import '../../../../../core/components/date_picker/custom_date_range_picker.dart';
import '../../../../../core/constants/dimens.dart';
import '../../../../../core/utils/user_manager.dart';
import '../../../../../data/models/workbench/blacklist_approval_item_model.dart';
import '../../../../../router/module_routes/workbench_routes.dart';
import 'blacklist_approval_controller.dart';

/// 黑名单审批页面。
class BlacklistApprovalView extends GetView<BlacklistApprovalController> {
  const BlacklistApprovalView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BlacklistApprovalController>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: const Text('黑名单审批')),
          body: _BlacklistApprovalBody(controller: logic),
        );
      },
    );
  }
}

class _BlacklistApprovalBody extends StatefulWidget {
  const _BlacklistApprovalBody({required this.controller});

  final BlacklistApprovalController controller;

  @override
  State<_BlacklistApprovalBody> createState() => _BlacklistApprovalBodyState();
}

class _BlacklistApprovalBodyState extends State<_BlacklistApprovalBody>
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
  void didUpdateWidget(covariant _BlacklistApprovalBody oldWidget) {
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
        _FilterSection(
          controller: widget.controller,
          tabController: _tabController,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: List.generate(widget.controller.tabItems.length, (
              tabIndex,
            ) {
              return CustomEasyRefreshList(
                key: ValueKey('blacklist-approval-$tabIndex'),
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
                    child: _BlacklistApprovalCard(
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

class _FilterSection extends StatelessWidget {
  const _FilterSection({required this.controller, required this.tabController});

  final BlacklistApprovalController controller;
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
              Expanded(child: _TypeDropdown(controller: controller)),
              SizedBox(width: AppDimens.dp8),
              Expanded(
                child: CustomDateRangePicker(
                  startDate: controller.dateRange?.start,
                  endDate: controller.dateRange?.end,
                  onDateRangeSelected: controller.onDateRangeSelected,
                  compact: true,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimens.dp8),
          _KeywordField(controller: controller),
        ],
      ),
    );
  }
}

class _TypeDropdown extends StatelessWidget {
  const _TypeDropdown({required this.controller});

  final BlacklistApprovalController controller;

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
          value: controller.selectedType,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          style: TextStyle(
            color: const Color(0xFF333333),
            fontSize: AppDimens.sp12,
          ),
          onChanged: controller.onTypeChanged,
          hint: Text(
            '请选择',
            style: TextStyle(
              color: const Color(0xFF7D8A9A),
              fontSize: AppDimens.sp12,
            ),
          ),
          items: controller.typeOptions
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

class _KeywordField extends StatelessWidget {
  const _KeywordField({required this.controller});

  final BlacklistApprovalController controller;

  @override
  Widget build(BuildContext context) {
    return AppTextField.search(
      controller: controller.keywordController,
      hintText: '请输入关键字搜索',
      onSubmitted: controller.applyKeyword,
      onSearch: () =>
          controller.applyKeyword(controller.keywordController.text),
    );
  }
}

class _BlacklistApprovalCard extends StatelessWidget {
  const _BlacklistApprovalCard({required this.item, required this.controller});

  final BlacklistApprovalItemModel item;
  final BlacklistApprovalController controller;

  @override
  Widget build(BuildContext context) {
    final statusText = controller.checkStatusText(item.parkCheckStatus);
    final remarkText = (item.remark ?? '').trim();

    return AppInfoStatusCard(
      title: controller.titleText(item),
      statusText: statusText,
      statusStyle: _statusStyle(item.parkCheckStatus),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '类型：${controller.typeText(item.type)}',
            style: TextStyle(
              color: const Color(0xFF3C4656),
              fontSize: AppDimens.sp12,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: AppDimens.dp6),
          Text(
            '发起人：${controller.creatorText(item)}',
            style: TextStyle(
              color: const Color(0xFF5E6A7C),
              fontSize: AppDimens.sp12,
            ),
          ),
          SizedBox(height: AppDimens.dp6),
          Text(
            '拉黑描述：${remarkText.isEmpty ? '--' : remarkText}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF5E6A7C),
              fontSize: AppDimens.sp12,
            ),
          ),
          SizedBox(height: AppDimens.dp6),
          Row(
            children: [
              Expanded(
                child: Text(
                  '时间：${controller.timeText(item)}',
                  style: TextStyle(
                    color: const Color(0xFF5E6A7C),
                    fontSize: AppDimens.sp12,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimens.dp8,
                  vertical: AppDimens.dp2,
                ),
                decoration: BoxDecoration(
                  color: item.status == 1 || item.state == 1
                      ? const Color(0xFFFFF3E6)
                      : const Color(0xFFF1F3F7),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  controller.validStatusText(item),
                  style: TextStyle(
                    color: item.status == 1 || item.state == 1
                        ? const Color(0xFFBA6A08)
                        : const Color(0xFF6E7B8C),
                    fontSize: AppDimens.sp10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
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
          onPressed: () =>
              WorkbenchRoutes.toBlacklistApprovalDetail(item: item),
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

    if (!UserManager.isCompanyUser && item.parkCheckStatus == 0) {
      buttons.add(SizedBox(width: AppDimens.dp8));
      buttons.add(
        SizedBox(
          width: AppDimens.dp56,
          height: AppDimens.dp26,
          child: OutlinedButton(
            onPressed: () async {
              final handled = await WorkbenchRoutes.toBlacklistApprovalApprove(
                item: item,
              );
              if (handled == true) {
                controller.triggerRefresh();
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
    } else if (!UserManager.isCompanyUser && item.parkCheckStatus == 1) {
      buttons.add(SizedBox(width: AppDimens.dp8));
      buttons.add(
        SizedBox(
          width: 72,
          height: AppDimens.dp26,
          child: OutlinedButton(
            onPressed: () async {
              final handled = await WorkbenchRoutes.toBlacklistAuthorization(
                item: item,
              );
              if (handled == true) {
                controller.triggerRefresh();
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
              '更改授权',
              style: TextStyle(
                color: const Color(0xFF1F7BFF),
                fontSize: AppDimens.sp11,
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
        return const AppCardStatusStyle(
          textColor: Color(0xFF0E8C4C),
          backgroundColor: Color(0xFFE7F8EE),
          borderColor: Color(0xFFB8E8CC),
        );
      case 2:
        return const AppCardStatusStyle(
          textColor: Color(0xFFDA5A18),
          backgroundColor: Color(0xFFFFF1E8),
          borderColor: Color(0xFFF6D0B8),
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
