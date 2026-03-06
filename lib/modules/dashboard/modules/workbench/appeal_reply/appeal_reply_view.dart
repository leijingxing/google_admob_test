import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/components/app_info_status_card.dart';
import '../../../../../core/components/custom_refresh.dart';
import '../../../../../core/components/custom_sliding_tab_bar.dart';
import '../../../../../core/components/date_picker/custom_date_range_picker.dart';
import '../../../../../core/constants/dimens.dart';
import '../../../../../data/models/workbench/appeal_reply_item_model.dart';
import '../../../../../router/module_routes/workbench_routes.dart';
import 'appeal_reply_controller.dart';

/// 申诉回复页面。
class AppealReplyView extends GetView<AppealReplyController> {
  const AppealReplyView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppealReplyController>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: const Text('申诉回复')),
          body: _AppealReplyBody(controller: logic),
        );
      },
    );
  }
}

class _AppealReplyBody extends StatefulWidget {
  const _AppealReplyBody({required this.controller});

  final AppealReplyController controller;

  @override
  State<_AppealReplyBody> createState() => _AppealReplyBodyState();
}

class _AppealReplyBodyState extends State<_AppealReplyBody>
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
  void didUpdateWidget(covariant _AppealReplyBody oldWidget) {
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
              return CustomEasyRefreshList<AppealReplyItemModel>(
                key: ValueKey('appeal-reply-$tabIndex'),
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
                    child: _AppealReplyCard(
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

  final AppealReplyController controller;
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
          CustomDateRangePicker(
            startDate: controller.dateRange?.start,
            endDate: controller.dateRange?.end,
            onDateRangeSelected: controller.onDateRangeSelected,
            compact: true,
          ),
          SizedBox(height: AppDimens.dp8),
          _KeywordField(controller: controller),
        ],
      ),
    );
  }
}

class _KeywordField extends StatelessWidget {
  const _KeywordField({required this.controller});

  final AppealReplyController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimens.dp34,
      child: TextField(
        controller: controller.keywordController,
        textInputAction: TextInputAction.search,
        onSubmitted: controller.applyKeyword,
        decoration: InputDecoration(
          hintText: '请输入姓名/车牌、异常描述、申诉描述、申诉人',
          hintStyle: TextStyle(
            color: const Color(0xFF9AA2AE),
            fontSize: AppDimens.sp12,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppDimens.dp10,
            vertical: AppDimens.dp8,
          ),
          filled: true,
          fillColor: const Color(0xFFF6F8FC),
          suffixIcon: IconButton(
            onPressed: () =>
                controller.applyKeyword(controller.keywordController.text),
            icon: const Icon(Icons.search, size: 18),
          ),
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

class _AppealReplyCard extends StatelessWidget {
  const _AppealReplyCard({required this.item, required this.controller});

  final AppealReplyItemModel item;
  final AppealReplyController controller;

  @override
  Widget build(BuildContext context) {
    return AppInfoStatusCard(
      title: _display(item.targetValue),
      statusText: controller.statusText(item.status),
      statusStyle: _statusStyle(item.status),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '申诉类型：${controller.appealTypeText(item.appealType)}',
            style: TextStyle(
              color: const Color(0xFF3C4656),
              fontSize: AppDimens.sp12,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: AppDimens.dp6),
          Text(
            '异常描述：${_display(item.abnormalDesc)}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF5E6A7C),
              fontSize: AppDimens.sp12,
            ),
          ),
          SizedBox(height: AppDimens.dp6),
          Text(
            '申诉描述：${_display(item.appealDesc)}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF5E6A7C),
              fontSize: AppDimens.sp12,
            ),
          ),
          SizedBox(height: AppDimens.dp6),
          Text(
            '申诉人：${_display(item.applicant)}',
            style: TextStyle(
              color: const Color(0xFF5E6A7C),
              fontSize: AppDimens.sp12,
            ),
          ),
          SizedBox(height: AppDimens.dp6),
          Text(
            '申诉时间：${_display(item.appealTime)}',
            style: TextStyle(
              color: const Color(0xFF5E6A7C),
              fontSize: AppDimens.sp12,
            ),
          ),
          if ((item.reply ?? '').trim().isNotEmpty) ...[
            SizedBox(height: AppDimens.dp6),
            Text(
              '回复描述：${_display(item.reply)}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color(0xFF5E6A7C),
                fontSize: AppDimens.sp12,
              ),
            ),
          ],
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
          onPressed: () => WorkbenchRoutes.toAppealReplyDetail(item: item),
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

    if (controller.canReply(item)) {
      buttons.add(SizedBox(width: AppDimens.dp8));
      buttons.add(
        SizedBox(
          width: AppDimens.dp56,
          height: AppDimens.dp26,
          child: OutlinedButton(
            onPressed: () async {
              final handled = await WorkbenchRoutes.toAppealReplyHandle(
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
              '回复',
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

  String _display(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? '--' : text;
  }
}
