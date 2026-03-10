import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/components/custom_refresh.dart';
import '../../../../core/components/toast/toast_widget.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/dimens.dart';
import '../../../../data/models/vehicle_query/vehicle_query_models.dart';
import 'detail_page/vehicle_query_detail_binding.dart';
import 'detail_page/vehicle_query_detail_page.dart';
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
            _VehicleCountCardList(items: controller.countCards, loading: controller.statsLoading, onRefresh: controller.loadVehicleCountCards),
            SizedBox(height: AppDimens.dp8),
            _MainSearchPanel(controller: controller),
            SizedBox(height: AppDimens.dp10),
            Expanded(
              child: CustomEasyRefreshList<VehicleComprehensiveItemModel>(
                refreshTrigger: controller.mainRefreshTrigger,
                dataLoader: controller.loadMainList,
                emptyWidget: const _MainEmptyState(),
                itemBuilder: (context, item, index) {
                  return _MainVehicleCard(item: item, onView: () => _openDetailPage(controller, item), onAddBlack: () => _showAddBlackDialog(context, controller, item));
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _openDetailPage(VehicleQueryStatisticsController controller, VehicleComprehensiveItemModel row) {
    Get.to<void>(
      () => const VehicleDetailPage(),
      binding: VehicleQueryDetailBinding(
        statisticsController: controller,
        row: row,
      ),
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
      padding: EdgeInsets.all(AppDimens.dp8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp10),
        border: Border.all(color: const Color(0xFFD9E4FF)),
        boxShadow: [BoxShadow(color: const Color(0xFF1D5DCC).withValues(alpha: 0.08), blurRadius: AppDimens.dp10, offset: Offset(0, AppDimens.dp2))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: AppDimens.dp40,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F8FF),
                borderRadius: BorderRadius.circular(AppDimens.dp8),
                border: Border.all(color: const Color(0xFFD8E3FA)),
              ),
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller.mainKeywordController,
                builder: (context, value, _) {
                  final hasText = value.text.trim().isNotEmpty;
                  return TextField(
                    controller: controller.mainKeywordController,
                    textInputAction: TextInputAction.search,
                    textAlignVertical: TextAlignVertical.center,
                    onSubmitted: (_) => controller.onSearchMainList(),
                    decoration: InputDecoration(
                      hintText: '请输入车牌号/关键词',
                      isCollapsed: true,
                      border: const OutlineInputBorder(borderSide: BorderSide.none),
                      hintStyle: TextStyle(color: const Color(0xFF8A98AF), fontSize: AppDimens.sp12),
                      contentPadding: EdgeInsets.symmetric(horizontal: AppDimens.dp2),
                      prefixIcon: Icon(Icons.search_rounded, color: const Color(0xFF4D8DFF), size: AppDimens.dp20),
                      suffixIcon: hasText
                          ? IconButton(
                              icon: Icon(Icons.close_rounded, color: const Color(0xFF9AA8BE), size: AppDimens.dp18),
                              onPressed: () {
                                controller.mainKeywordController.clear();
                                controller.onSearchMainList();
                              },
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: AppDimens.dp8),
          SizedBox(
            height: AppDimens.dp40,
            child: FilledButton(
              onPressed: controller.onSearchMainList,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF3E7BFF),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.dp8)),
                padding: EdgeInsets.symmetric(horizontal: AppDimens.dp14),
              ),
              child: const Text('查询'),
            ),
          ),
        ],
      ),
    );
  }
}

class _VehicleCountCardList extends StatelessWidget {
  const _VehicleCountCardList({required this.items, required this.loading, required this.onRefresh});

  final List<VehicleCountCardData> items;
  final bool loading;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: items
              .map(
                (item) => Padding(
                  padding: EdgeInsets.only(bottom: AppDimens.dp6),
                  child: _VehicleCountCard(item: item),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _VehicleCountCard extends StatelessWidget {
  const _VehicleCountCard({required this.item});

  final VehicleCountCardData item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimens.dp6),
      decoration: BoxDecoration(color: item.accentColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppDimens.dp8)),
      child: Row(
        children: [
          Container(
            width: AppDimens.dp64,
            padding: EdgeInsets.symmetric(vertical: AppDimens.dp6, horizontal: AppDimens.dp6),
            decoration: BoxDecoration(color: item.accentColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(AppDimens.dp6)),
            child: Column(
              children: [
                Icon(Icons.local_shipping_rounded, size: AppDimens.sp14, color: item.accentColor),
                SizedBox(height: AppDimens.dp2),
                Text(
                  item.name,
                  style: TextStyle(color: item.accentColor, fontSize: AppDimens.sp12, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          SizedBox(width: AppDimens.dp6),
          Expanded(
            child: Row(
              children: item.metrics.map((metric) {
                return Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${metric.value}',
                        style: TextStyle(color: _metricTextColor(metric.label), fontSize: AppDimens.sp14, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: AppDimens.dp2),
                      Text(
                        metric.label,
                        style: TextStyle(color: _metricTextColor(metric.label), fontSize: AppDimens.sp10, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Color _metricTextColor(String label) {
    if (label == '黑名单') {
      return const Color(0xFF1F9D67);
    }
    return const Color(0xFF3B4960);
  }
}

class _MainVehicleCard extends StatelessWidget {
  const _MainVehicleCard({required this.item, required this.onView, required this.onAddBlack});

  final VehicleComprehensiveItemModel item;
  final VoidCallback onView;
  final VoidCallback onAddBlack;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimens.dp8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp10),
        border: Border.all(color: const Color(0xFFDDE6F7)),
        boxShadow: [BoxShadow(color: const Color(0xFF1A3D73).withValues(alpha: 0.06), blurRadius: AppDimens.dp10, offset: Offset(0, AppDimens.dp2))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onView,
          onLongPress: onAddBlack,
          borderRadius: BorderRadius.circular(AppDimens.dp10),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimens.dp8, vertical: AppDimens.dp10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: AppDimens.dp22,
                      height: AppDimens.dp22,
                      decoration: BoxDecoration(color: const Color(0xFFEAF2FF), borderRadius: BorderRadius.circular(AppDimens.dp6)),
                      child: Icon(Icons.directions_car_filled_rounded, size: AppDimens.sp12, color: const Color(0xFF4D8DFF)),
                    ),
                    SizedBox(width: AppDimens.dp6),
                    Expanded(
                      child: Text(
                        '车牌号：${item.carNumb}',
                        style: TextStyle(color: const Color(0xFF202020), fontSize: AppDimens.sp16, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: AppDimens.dp8, vertical: AppDimens.dp4),
                      decoration: BoxDecoration(color: _categoryColor(item.carCategory).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppDimens.dp12)),
                      child: Text(
                        VehicleQueryStatisticsController.carCategoryText(item.carCategory),
                        style: TextStyle(color: _categoryColor(item.carCategory), fontSize: AppDimens.sp12, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppDimens.dp6),
                Wrap(
                  spacing: AppDimens.dp6,
                  runSpacing: AppDimens.dp6,
                  children: [
                    _MainCardTag(label: '黑/白名单', value: _blackWhiteStatusText(item.validityStatus), color: _statusColor(item.validityStatus)),
                    _MainCardTag(label: '车辆属性', value: item.trailer == 1 ? '挂车' : '非挂车', color: const Color(0xFF3F7EFF)),
                  ],
                ),
                SizedBox(height: AppDimens.dp8),
                Row(
                  children: [
                    Expanded(
                      child: _MainCardMetric(label: '准入', value: '${item.accessCount}', color: const Color(0xFF397BFF)),
                    ),
                    SizedBox(width: AppDimens.dp6),
                    Expanded(
                      child: _MainCardMetric(label: '出入', value: '${item.inCount}/${item.outCount}', color: const Color(0xFF2CA7A0)),
                    ),
                    SizedBox(width: AppDimens.dp6),
                    Expanded(
                      child: _MainCardMetric(label: '违规', value: '${item.violationCount}', color: const Color(0xFFF58A34)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _blackWhiteStatusText(int validityStatus) {
    return VehicleQueryStatisticsController.validityStatusText(validityStatus);
  }

  Color _statusColor(int validityStatus) {
    if (validityStatus == 2) return const Color(0xFFE85D5D);
    if (validityStatus == 0) return const Color(0xFF1FA56E);
    if (validityStatus == 1) return const Color(0xFF2C9BFF);
    return const Color(0xFF8898AE);
  }

  Color _categoryColor(int carCategory) {
    if (carCategory == 1) return const Color(0xFFE25C5C);
    if (carCategory == 2) return const Color(0xFFFF9D2E);
    if (carCategory == 3) return const Color(0xFF2C9BFF);
    return const Color(0xFF3BAEDB);
  }
}

class _MainCardTag extends StatelessWidget {
  const _MainCardTag({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.dp8, vertical: AppDimens.dp4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppDimens.dp12)),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label：',
              style: TextStyle(color: const Color(0xFF607188), fontSize: AppDimens.sp10),
            ),
            TextSpan(
              text: value,
              style: TextStyle(color: color, fontSize: AppDimens.sp12, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainCardMetric extends StatelessWidget {
  const _MainCardMetric({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppDimens.dp6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(AppDimens.dp8)),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(color: color, fontSize: AppDimens.sp14, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: AppDimens.dp2),
          Text(
            label,
            style: TextStyle(color: const Color(0xFF6D7D93), fontSize: AppDimens.sp10, fontWeight: FontWeight.w600),
          ),
        ],
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
