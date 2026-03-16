import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/components/app_info_status_card.dart';
import '../../../../../core/components/app_text_field.dart';
import '../../../../../core/components/app_standard_card.dart';
import '../../../../../core/components/custom_refresh.dart';
import '../../../../../core/components/custom_sliding_tab_bar.dart';
import '../../../../../core/components/date_picker/custom_date_range_picker.dart';
import '../../../../../core/constants/dimens.dart';
import '../../../../../data/models/workbench/spot_inspection_item_model.dart';
import '../../../../../router/module_routes/workbench_routes.dart';
import 'spot_inspection_controller.dart';

/// 车辆抽检页面。
class SpotInspectionView extends GetView<SpotInspectionController> {
  const SpotInspectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SpotInspectionController>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: const Text('车辆抽检')),
          body: _SpotInspectionBody(controller: logic),
        );
      },
    );
  }
}

class _SpotInspectionBody extends StatefulWidget {
  const _SpotInspectionBody({required this.controller});

  final SpotInspectionController controller;

  @override
  State<_SpotInspectionBody> createState() => _SpotInspectionBodyState();
}

class _SpotInspectionBodyState extends State<_SpotInspectionBody>
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
  void didUpdateWidget(covariant _SpotInspectionBody oldWidget) {
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
                key: ValueKey('spot-inspection-$tabIndex'),
                refreshTrigger: widget.controller.refreshTrigger,
                pageSize: 10,
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
                    child: _InspectionCard(
                      item: item,
                      controller: widget.controller,
                      tabIndex: tabIndex,
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

  final SpotInspectionController controller;
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
      child: Column(
        children: [
          _StatisticsCard(controller: controller),
          SizedBox(height: AppDimens.dp10),
          AppStandardCard(
            padding: EdgeInsets.all(AppDimens.dp10),
            child: Column(
              children: [
                CustomSlidingTabBar(
                  labels: controller.tabItems
                      .map((item) => item.label)
                      .toList(),
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
                    Expanded(child: _KeywordField(controller: controller)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatisticsCard extends StatelessWidget {
  const _StatisticsCard({required this.controller});

  final SpotInspectionController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _CountCard(
            title: '待抽检',
            value: controller.pendingCount,
            colors: const [Color(0xFFFFF4E8), Color(0xFFFFFBF3)],
            accentColor: const Color(0xFFE58A1F),
          ),
        ),
        SizedBox(width: AppDimens.dp8),
        Expanded(
          child: _CountCard(
            title: '已通过',
            value: controller.passCount,
            colors: const [Color(0xFFE8FFF1), Color(0xFFF4FFF8)],
            accentColor: const Color(0xFF1FA866),
          ),
        ),
        SizedBox(width: AppDimens.dp8),
        Expanded(
          child: _CountCard(
            title: '不通过',
            value: controller.failCount,
            colors: const [Color(0xFFFFECE9), Color(0xFFFFF7F5)],
            accentColor: const Color(0xFFE0644A),
          ),
        ),
      ],
    );
  }
}

class _CountCard extends StatelessWidget {
  const _CountCard({
    required this.title,
    required this.value,
    required this.colors,
    required this.accentColor,
  });

  final String title;
  final int value;
  final List<Color> colors;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp10,
        vertical: AppDimens.dp12,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(AppDimens.dp12),
        border: Border.all(color: accentColor.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: const Color(0xFF556476),
              fontSize: AppDimens.sp11,
            ),
          ),
          SizedBox(height: AppDimens.dp6),
          Text(
            '$value',
            style: TextStyle(
              color: accentColor,
              fontSize: AppDimens.sp20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _KeywordField extends StatelessWidget {
  const _KeywordField({required this.controller});

  final SpotInspectionController controller;

  @override
  Widget build(BuildContext context) {
    return AppTextField.search(
      controller: controller.keywordController,
      hintText: '请输入车牌号',
      onSubmitted: controller.applyKeyword,
      onSearch: () =>
          controller.applyKeyword(controller.keywordController.text),
    );
  }
}

class _InspectionCard extends StatelessWidget {
  const _InspectionCard({
    required this.item,
    required this.controller,
    required this.tabIndex,
  });

  final SpotInspectionItemModel item;
  final SpotInspectionController controller;
  final int tabIndex;

  @override
  Widget build(BuildContext context) {
    final isPending = tabIndex == 0;

    return AppInfoStatusCard(
      title: item.carNumb ?? '--',
      statusText: controller.vehicleStatusText(item),
      statusStyle: isPending
          ? const AppCardStatusStyle(
              textColor: Color(0xFF8A4B00),
              backgroundColor: Color(0xFFFFF4E4),
              borderColor: Color(0xFFF8D5AE),
            )
          : const AppCardStatusStyle(
              textColor: Color(0xFF0E8C4C),
              backgroundColor: Color(0xFFE7F8EE),
              borderColor: Color(0xFFB8E8CC),
            ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '危化品：${controller.goodsTypeText(item)}',
            style: TextStyle(
              color: const Color(0xFF5E6A7C),
              fontSize: AppDimens.sp12,
            ),
          ),
          SizedBox(height: AppDimens.dp6),
          Text(
            isPending
                ? '预计入园时间：${controller.reservationTimeText(item)}'
                : '抽检结果：${controller.resultText(item.securityCheckResults)}',
            style: TextStyle(
              color: const Color(0xFF5E6A7C),
              fontSize: AppDimens.sp12,
            ),
          ),
        ],
      ),
      trailingAction: SizedBox(
        width: 62,
        height: AppDimens.dp28,
        child: OutlinedButton(
          onPressed: () async {
            final handled = isPending
                ? await WorkbenchRoutes.toSpotInspectionFill(item: item)
                : await WorkbenchRoutes.toSpotInspectionDetail(item: item);
            if (handled == true) {
              controller.refreshPage();
            }
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF1F7BFF)),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.dp6),
            ),
          ),
          child: Text(
            isPending ? '抽检' : '详情',
            style: TextStyle(
              color: const Color(0xFF1F7BFF),
              fontSize: AppDimens.sp12,
            ),
          ),
        ),
      ),
    );
  }
}
