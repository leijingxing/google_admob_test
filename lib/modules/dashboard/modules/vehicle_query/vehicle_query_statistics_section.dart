import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/components/custom_refresh.dart';
import '../../../../core/components/toast/toast_widget.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/dimens.dart';
import '../../../../data/models/vehicle_query/vehicle_query_models.dart';
import 'vehicle_query_detail_sheet.dart';
import 'vehicle_query_statistics_controller.dart';

/// 车辆查询统计区块。
class VehicleQueryStatisticsSection extends StatelessWidget {
  const VehicleQueryStatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VehicleQueryStatisticsController>(
      init: Get.isRegistered<VehicleQueryStatisticsController>() ? Get.find<VehicleQueryStatisticsController>() : VehicleQueryStatisticsController(),
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MainSearchPanel(controller: controller),
            SizedBox(height: AppDimens.dp10),
            Row(
              children: [
                Text(
                  '车辆统计',
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                IconButton(onPressed: controller.statsLoading ? null : controller.loadVehicleCountCards, icon: const Icon(Icons.refresh_rounded)),
              ],
            ),
            if (controller.statsLoading) const LinearProgressIndicator(minHeight: 1.5),
            SizedBox(height: AppDimens.dp8),
            _VehicleCountCardList(items: controller.countCards),
            SizedBox(height: AppDimens.dp10),
            Expanded(
              child: CustomEasyRefreshList<VehicleComprehensiveItemModel>(
                refreshTrigger: controller.mainRefreshTrigger,
                dataLoader: controller.loadMainList,
                emptyWidget: const _MainEmptyState(),
                itemBuilder: (context, item, index) {
                  return _MainVehicleCard(index: index, item: item, onView: () => _showDetailSheet(context, controller, item), onAddBlack: () => _showAddBlackDialog(context, controller, item));
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDetailSheet(BuildContext context, VehicleQueryStatisticsController controller, VehicleComprehensiveItemModel row) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => VehicleDetailSheet(controller: controller, row: row),
    );
  }

  Future<void> _showAddBlackDialog(BuildContext context, VehicleQueryStatisticsController controller, VehicleComprehensiveItemModel row) async {
    final remarkController = TextEditingController();
    DateTimeRange? validityRange;
    bool submitting = false;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('拉黑'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: remarkController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: '拉黑描述',
                        hintText: '请输入备注',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimens.dp10)),
                      ),
                    ),
                    SizedBox(height: AppDimens.dp12),
                    InkWell(
                      onTap: () async {
                        final now = DateTime.now();
                        final range = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(now.year - 2),
                          lastDate: DateTime(now.year + 2),
                          initialDateRange: validityRange,
                          helpText: '选择有效期限',
                        );
                        if (range == null) return;
                        setState(() {
                          validityRange = range;
                        });
                      },
                      borderRadius: BorderRadius.circular(AppDimens.dp10),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: AppDimens.dp10, vertical: AppDimens.dp12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7FAFF),
                          borderRadius: BorderRadius.circular(AppDimens.dp10),
                          border: Border.all(color: const Color(0xFFE1E9F6)),
                        ),
                        child: Text(
                          validityRange == null
                              ? '请选择有效期限'
                              : '${validityRange!.start.year}-${validityRange!.start.month}-${validityRange!.start.day} '
                                    '~ ${validityRange!.end.year}-${validityRange!.end.month}-${validityRange!.end.day}',
                          style: TextStyle(color: validityRange == null ? AppColors.textSecondary : AppColors.textPrimary, fontSize: AppDimens.sp12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: submitting ? null : () => Navigator.of(context).pop(), child: const Text('取消')),
                FilledButton(
                  onPressed: submitting
                      ? null
                      : () async {
                          final remark = remarkController.text.trim();
                          if (remark.isEmpty) {
                            AppToast.showWarning('请输入拉黑描述');
                            return;
                          }
                          if (validityRange == null) {
                            AppToast.showWarning('请选择有效期限');
                            return;
                          }

                          setState(() {
                            submitting = true;
                          });
                          final success = await controller.addBlackRecord(row: row, parkCheckDesc: remark, validityDateRange: validityRange!);
                          if (context.mounted) {
                            setState(() {
                              submitting = false;
                            });
                          }
                          if (success && context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                  child: Text(submitting ? '提交中...' : '提交'),
                ),
              ],
            );
          },
        );
      },
    );

    remarkController.dispose();
  }
}

class _MainSearchPanel extends StatelessWidget {
  const _MainSearchPanel({required this.controller});

  final VehicleQueryStatisticsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimens.dp12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp14),
        border: Border.all(color: const Color(0xFFE2EAF6)),
      ),
      child: Column(
        children: [
          TextField(
            controller: controller.mainKeywordController,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => controller.onSearchMainList(),
            decoration: InputDecoration(
              hintText: '请输入搜索关键词',
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: const Color(0xFFF7FAFF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.dp10),
                borderSide: const BorderSide(color: Color(0xFFE1E9F6)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.dp10),
                borderSide: const BorderSide(color: Color(0xFFE1E9F6)),
              ),
            ),
          ),
          SizedBox(height: AppDimens.dp8),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int?>(
                  value: controller.mainCarCategory,
                  decoration: InputDecoration(
                    hintText: '车辆类型',
                    filled: true,
                    fillColor: const Color(0xFFF7FAFF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimens.dp10),
                      borderSide: const BorderSide(color: Color(0xFFE1E9F6)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimens.dp10),
                      borderSide: const BorderSide(color: Color(0xFFE1E9F6)),
                    ),
                  ),
                  items: [
                    const DropdownMenuItem<int?>(value: null, child: Text('全部类型')),
                    ...VehicleQueryStatisticsController.carCategoryLabelMap.entries.map((entry) => DropdownMenuItem<int?>(value: entry.key, child: Text(entry.value))),
                  ],
                  onChanged: controller.onMainCarCategoryChanged,
                ),
              ),
              SizedBox(width: AppDimens.dp8),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final now = DateTime.now();
                    final result = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(now.year - 2),
                      lastDate: DateTime(now.year + 1),
                      initialDateRange: controller.mainDateRange,
                      helpText: '选择开始时间-结束时间',
                    );
                    if (result == null) return;
                    controller.onMainDateRangeChanged(result);
                  },
                  borderRadius: BorderRadius.circular(AppDimens.dp10),
                  child: Container(
                    height: AppDimens.dp56,
                    padding: EdgeInsets.symmetric(horizontal: AppDimens.dp10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7FAFF),
                      borderRadius: BorderRadius.circular(AppDimens.dp10),
                      border: Border.all(color: const Color(0xFFE1E9F6)),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _mainRangeText(controller.mainDateRange),
                      style: TextStyle(color: controller.mainDateRange == null ? AppColors.textSecondary : AppColors.textPrimary, fontSize: AppDimens.sp12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimens.dp10),
          Row(
            children: [
              Expanded(
                child: FilledButton.tonalIcon(onPressed: controller.onSearchMainList, icon: const Icon(Icons.search_rounded), label: const Text('搜索')),
              ),
              SizedBox(width: AppDimens.dp8),
              Expanded(
                child: OutlinedButton.icon(onPressed: controller.onResetMainList, icon: const Icon(Icons.restart_alt_rounded), label: const Text('重置')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VehicleCountCardList extends StatelessWidget {
  const _VehicleCountCardList({required this.items});

  final List<VehicleCountCardData> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - AppDimens.dp8) / 2;
        return Wrap(
          spacing: AppDimens.dp8,
          runSpacing: AppDimens.dp8,
          children: items.map((item) {
            return SizedBox(
              width: width,
              child: _VehicleCountCard(item: item),
            );
          }).toList(),
        );
      },
    );
  }
}

class _VehicleCountCard extends StatelessWidget {
  const _VehicleCountCard({required this.item});

  final VehicleCountCardData item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimens.dp10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.dp12),
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [item.accentColor.withValues(alpha: 0.18), item.accentColor.withValues(alpha: 0.06)]),
        border: Border.all(color: item.accentColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppDimens.dp22,
                height: AppDimens.dp22,
                decoration: BoxDecoration(color: item.accentColor.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(AppDimens.dp6)),
                child: Icon(Icons.directions_car_filled_rounded, size: AppDimens.sp12, color: item.accentColor),
              ),
              SizedBox(width: AppDimens.dp6),
              Text(
                item.name,
                style: TextStyle(color: const Color(0xFF2B3E56), fontSize: AppDimens.sp12, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          SizedBox(height: AppDimens.dp8),
          Row(
            children: item.metrics.map((metric) {
              final isLast = metric == item.metrics.last;
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: isLast ? 0 : AppDimens.dp4),
                  padding: EdgeInsets.symmetric(vertical: AppDimens.dp4),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.75), borderRadius: BorderRadius.circular(AppDimens.dp8)),
                  child: Column(
                    children: [
                      Text(
                        '${metric.value}',
                        style: TextStyle(color: const Color(0xFF1F3C64), fontSize: AppDimens.sp12, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        metric.label,
                        style: TextStyle(color: const Color(0xFF4C607A), fontSize: AppDimens.sp10),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _MainVehicleCard extends StatelessWidget {
  const _MainVehicleCard({required this.index, required this.item, required this.onView, required this.onAddBlack});

  final int index;
  final VehicleComprehensiveItemModel item;
  final VoidCallback onView;
  final VoidCallback onAddBlack;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: AppDimens.dp8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.dp10),
        side: const BorderSide(color: Color(0xFFE2EAF6)),
      ),
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(AppDimens.dp10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${index + 1}. ${item.carNumb}',
                  style: TextStyle(color: const Color(0xFF223A58), fontSize: AppDimens.sp14, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                TextButton(onPressed: onView, child: const Text('查看')),
                TextButton(onPressed: onAddBlack, child: const Text('拉黑')),
              ],
            ),
            _kv('车辆类别', VehicleQueryStatisticsController.carCategoryLabelMap[item.carCategory] ?? '${item.carCategory}'),
            _kv('车牌颜色', VehicleQueryStatisticsController.carNumbColourLabelMap[item.carNumbColour] ?? '${item.carNumbColour}'),
            _kv('是否挂车', item.trailer == 1 ? '是' : '否'),
            _kv('是否黑/白名单', VehicleQueryStatisticsController.validityStatusLabelMap[item.validityStatus] ?? '${item.validityStatus}'),
            _kv('预约/准入次数', '${item.accessCount}'),
            _kv('出入次数', '${item.inCount} / ${item.outCount}'),
            _kv('违规次数', '${item.violationCount}'),
            _kv('拉黑次数', '${item.blackCount}'),
          ],
        ),
      ),
    );
  }

  Widget _kv(String key, String value) {
    return Padding(
      padding: EdgeInsets.only(top: AppDimens.dp4),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: const Color(0xFF5C708A), fontSize: AppDimens.sp10),
          children: [
            TextSpan(text: '$key：'),
            TextSpan(
              text: value,
              style: TextStyle(color: const Color(0xFF253B56), fontSize: AppDimens.sp12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainEmptyState extends StatelessWidget {
  const _MainEmptyState();

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [SliverFillRemaining(hasScrollBody: false, child: Center(child: Text('暂无车辆数据')))],
    );
  }
}

String _mainRangeText(DateTimeRange? range) {
  if (range == null) return '开始时间 - 结束时间';
  final s = '${range.start.year}-${range.start.month}-${range.start.day}';
  final e = '${range.end.year}-${range.end.month}-${range.end.day}';
  return '$s ~ $e';
}
