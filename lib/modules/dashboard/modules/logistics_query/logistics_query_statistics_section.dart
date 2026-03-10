import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/components/app_form_styles.dart';
import '../../../../core/components/custom_refresh.dart';
import '../../../../core/components/date_picker/custom_date_range_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/dimens.dart';
import '../../../../core/utils/dict_field_query_tool.dart';
import '../../../../data/models/logistics_query/logistics_query_models.dart';
import 'detail_page/logistics_query_detail_binding.dart';
import 'detail_page/logistics_query_detail_page.dart';
import 'logistics_query_statistics_controller.dart';

/// 物流查询统计区块。
class LogisticsQueryStatisticsSection extends StatelessWidget {
  const LogisticsQueryStatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LogisticsQueryStatisticsController>(
      init: Get.isRegistered<LogisticsQueryStatisticsController>() ? Get.find<LogisticsQueryStatisticsController>() : LogisticsQueryStatisticsController(),
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LogisticsCountCardList(items: controller.countCards, loading: controller.statsLoading, onRefresh: controller.loadLogisticsCountCards),
            SizedBox(height: AppDimens.dp8),
            _MainSearchPanel(controller: controller),
            SizedBox(height: AppDimens.dp10),
            Expanded(
              child: CustomEasyRefreshList<LogisticsComprehensiveItemModel>(
                refreshTrigger: controller.mainRefreshTrigger,
                dataLoader: controller.loadMainList,
                emptyWidget: const _MainEmptyState(),
                itemBuilder: (context, item, index) {
                  return _MainLogisticsCard(item: item, onView: () => _openDetailPage(controller, item));
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _openDetailPage(LogisticsQueryStatisticsController controller, LogisticsComprehensiveItemModel row) {
    Get.to<void>(
      () => const LogisticsQueryDetailPage(),
      binding: LogisticsQueryDetailBinding(statisticsController: controller, row: row),
    );
  }
}

class _MainSearchPanel extends StatelessWidget {
  const _MainSearchPanel({required this.controller});

  final LogisticsQueryStatisticsController controller;

  @override
  Widget build(BuildContext context) {
    final hasFilter = controller.mainDateRange != null || controller.mainGoodsType != null;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimens.dp8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp10),
        border: Border.all(color: const Color(0xFFD9E4FF)),
        boxShadow: [BoxShadow(color: const Color(0xFF1D5DCC).withValues(alpha: 0.08), blurRadius: AppDimens.dp10, offset: Offset(0, AppDimens.dp2))],
      ),
      child: Column(
        children: [
          Row(
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
                        style: AppFormStyles.inputTextStyle(),
                        onSubmitted: (_) => controller.onSearchMainList(),
                        decoration: AppFormStyles.inputDecoration(
                          hintText: '请输入搜索关键词',
                          isCollapsed: true,
                          filled: false,
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
                width: AppDimens.dp40,
                child: FilledButton(
                  onPressed: () => _showFilterBottomSheet(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF5E7EA7),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.dp8)),
                  ),
                  child: const Icon(Icons.tune, size: 16),
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
          if (hasFilter) ...[
            SizedBox(height: AppDimens.dp8),
            Row(
              children: [
                if (controller.mainDateRange != null)
                  Expanded(
                    child: _FilterTag(label: '开始时间', value: _formatDateRange(controller.mainDateRange!)),
                  ),
                if (controller.mainDateRange != null && controller.mainGoodsType != null) SizedBox(width: AppDimens.dp6),
                if (controller.mainGoodsType != null)
                  Expanded(
                    child: _FilterTag(label: '物资类型', value: LogisticsQueryStatisticsController.goodsTypeText(controller.mainGoodsType, fallbackRaw: true) ?? '--'),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _showFilterBottomSheet(BuildContext context) async {
    DateTimeRange? tempDateRange = controller.mainDateRange;
    int? tempGoodsType = controller.mainGoodsType;

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
                    Container(
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
                            '开始时间',
                            style: TextStyle(color: const Color(0xFF7D8A9A), fontSize: AppDimens.sp12),
                          ),
                          SizedBox(height: AppDimens.dp8),
                          CustomDateRangePicker(
                            startDate: tempDateRange?.start,
                            endDate: tempDateRange?.end,
                            compact: true,
                            onDateRangeSelected: (start, end) {
                              setModalState(() => tempDateRange = _buildDateRange(start, end));
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppDimens.dp10),
                    _GoodsTypeField(
                      value: tempGoodsType,
                      onChanged: (value) {
                        setModalState(() => tempGoodsType = value);
                      },
                    ),
                    SizedBox(height: AppDimens.dp14),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              controller.onMainDateRangeChanged(null);
                              controller.onMainGoodsTypeChanged(null);
                              controller.onSearchMainList();
                              Navigator.of(bottomSheetContext).pop();
                            },
                            child: const Text('重置'),
                          ),
                        ),
                        SizedBox(width: AppDimens.dp10),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              controller.onMainDateRangeChanged(tempDateRange);
                              controller.onMainGoodsTypeChanged(tempGoodsType);
                              controller.onSearchMainList();
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

  String _formatDateRange(DateTimeRange range) {
    String format(DateTime date) {
      final year = date.year.toString().padLeft(4, '0');
      final month = date.month.toString().padLeft(2, '0');
      final day = date.day.toString().padLeft(2, '0');
      return '$year-$month-$day';
    }

    return '${format(range.start)} ~ ${format(range.end)}';
  }
}

class _GoodsTypeField extends StatelessWidget {
  const _GoodsTypeField({required this.value, required this.onChanged});

  final int? value;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    final options = _buildOptions();

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
            '物资类型',
            style: TextStyle(color: const Color(0xFF7D8A9A), fontSize: AppDimens.sp12),
          ),
          SizedBox(height: AppDimens.dp8),
          DropdownButtonFormField<int?>(
            initialValue: value,
            isDense: true,
            style: AppFormStyles.inputTextStyle(),
            borderRadius: AppFormStyles.dropdownBorderRadius,
            dropdownColor: AppFormStyles.dropdownBackgroundColor,
            menuMaxHeight: AppFormStyles.dropdownMenuMaxHeight,
            decoration: AppFormStyles.inputDecoration(
              hintText: '请选择物资类型',
              contentPadding: EdgeInsets.symmetric(horizontal: AppDimens.dp10, vertical: AppDimens.dp8),
            ),
            items: options.map((item) => DropdownMenuItem<int?>(value: item.value, child: Text(item.label))).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  List<_DropdownOption> _buildOptions() {
    return const <_DropdownOption>[
      _DropdownOption(label: '全部', value: null),
      _DropdownOption(label: '危化品', value: 0),
      _DropdownOption(label: '危废品', value: 1),
      _DropdownOption(label: '普通货物', value: 2),
    ];
  }
}

class _DropdownOption {
  final String label;
  final int? value;

  const _DropdownOption({required this.label, required this.value});
}

class _FilterTag extends StatelessWidget {
  const _FilterTag({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.dp8, vertical: AppDimens.dp6),
      decoration: BoxDecoration(color: const Color(0xFFEFF5FF), borderRadius: BorderRadius.circular(AppDimens.dp8)),
      child: RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label：',
              style: TextStyle(color: const Color(0xFF607188), fontSize: AppDimens.sp10),
            ),
            TextSpan(
              text: value,
              style: TextStyle(color: const Color(0xFF2D6FDB), fontSize: AppDimens.sp10, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogisticsCountCardList extends StatelessWidget {
  const _LogisticsCountCardList({required this.items, required this.loading, required this.onRefresh});

  final List<LogisticsCountCardData> items;
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
                  child: _LogisticsCountCard(item: item),
                ),
              )
              .toList(),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(visualDensity: VisualDensity.compact, onPressed: loading ? null : onRefresh, icon: const Icon(Icons.refresh_rounded, size: 18)),
        ),
        if (loading)
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: ClipRRect(borderRadius: BorderRadius.circular(AppDimens.dp2), child: const LinearProgressIndicator(minHeight: 1.5)),
          ),
      ],
    );
  }
}

class _LogisticsCountCard extends StatelessWidget {
  const _LogisticsCountCard({required this.item});

  final LogisticsCountCardData item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.dp6, vertical: AppDimens.dp8),
      decoration: BoxDecoration(color: _cardSurfaceColor(item.type), borderRadius: BorderRadius.circular(AppDimens.dp10)),
      child: Row(
        children: [
          Container(
            width: AppDimens.dp64,
            padding: EdgeInsets.symmetric(vertical: AppDimens.dp6, horizontal: AppDimens.dp6),
            decoration: BoxDecoration(color: _leftPanelColor(item.type), borderRadius: BorderRadius.circular(AppDimens.dp6)),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: AppDimens.dp6, vertical: AppDimens.dp2),
                  decoration: BoxDecoration(color: _topBadgeColor(item.type), borderRadius: BorderRadius.circular(AppDimens.dp4)),
                  child: Text(
                    'TOP3',
                    style: TextStyle(color: Colors.white, fontSize: AppDimens.sp11, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(height: AppDimens.dp4),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: AppDimens.dp2),
                  decoration: BoxDecoration(color: _labelPanelColor(item.type), borderRadius: BorderRadius.circular(AppDimens.dp4)),
                  child: Text(
                    item.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: item.accentColor, fontSize: AppDimens.sp11, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppDimens.dp6),
          Expanded(
            child: Row(
              children: List.generate(item.metrics.length, (index) {
                final metric = item.metrics[index];
                return Expanded(
                  child: Row(
                    children: [
                      if (index > 0) Container(width: 1, height: AppDimens.dp28, color: Colors.white.withValues(alpha: 0.95)),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              metric.value,
                              style: TextStyle(color: _metricTextColor(index), fontSize: AppDimens.sp14, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: AppDimens.dp2),
                            Text(
                              metric.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: _metricTextColor(index), fontSize: AppDimens.sp11, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Color _cardSurfaceColor(int type) {
    if (type == 1) return const Color(0xFFEAD9DB);
    if (type == 2) return const Color(0xFFE9DFC8);
    return const Color(0xFFBCD6E6);
  }

  Color _leftPanelColor(int type) {
    if (type == 1) return const Color(0xFFF0E7E8);
    if (type == 2) return const Color(0xFFF2EADA);
    return const Color(0xFFD5EAF6);
  }

  Color _topBadgeColor(int type) {
    if (type == 1) return const Color(0xFFEC5858);
    if (type == 2) return const Color(0xFFF6A326);
    return const Color(0xFF38A7F1);
  }

  Color _labelPanelColor(int type) {
    if (type == 1) return const Color(0xFFFDECEC);
    if (type == 2) return const Color(0xFFFFF2DD);
    return const Color(0xFFE8F5FF);
  }

  Color _metricTextColor(int index) {
    if (index == 0) return const Color(0xFF0B3858);
    if (index == 1) return const Color(0xFF208D63);
    return const Color(0xFF0B3858);
  }
}

class _MainLogisticsCard extends StatelessWidget {
  const _MainLogisticsCard({required this.item, required this.onView});

  final LogisticsComprehensiveItemModel item;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    final hazardousTypeText = _hazardousTypeText(item.hazardousType);
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
                      child: Icon(Icons.inventory_2_rounded, size: AppDimens.sp12, color: const Color(0xFF4D8DFF)),
                    ),
                    SizedBox(width: AppDimens.dp6),
                    Expanded(
                      child: Text(
                        '物资名称/类型：${_goodsNameType(item)}',
                        style: TextStyle(color: const Color(0xFF202020), fontSize: AppDimens.sp16, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppDimens.dp8),
                if (hazardousTypeText != null) ...[_MainCardInfo(label: '物资类别', value: hazardousTypeText), SizedBox(height: AppDimens.dp8)],
                Row(
                  children: [
                    Expanded(
                      child: _MainCardMetric(label: '出入次数', value: '${item.outCount} / ${item.inCount}', color: const Color(0xFF397BFF)),
                    ),
                    SizedBox(width: AppDimens.dp6),
                    Expanded(
                      child: _MainCardMetric(label: '出入运输数量(m³/T)', value: '${item.outGoodsAmount} / ${item.inGoodsAmount}', color: const Color(0xFF2CA7A0)),
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

  String _goodsNameType(LogisticsComprehensiveItemModel item) {
    final goodsTypeText = LogisticsQueryStatisticsController.goodsTypeText(item.goodsType);
    final sections = <String>[if (item.goodsName.trim().isNotEmpty) item.goodsName.trim(), if (goodsTypeText != null && goodsTypeText.isNotEmpty) goodsTypeText];
    if (sections.isEmpty) return '--';
    return sections.join(' / ');
  }

  String? _hazardousTypeText(Object? hazardousType) {
    if (hazardousType == null) return null;
    final rawValue = hazardousType.toString().trim();
    if (rawValue.isEmpty) return null;

    final numericValue = int.tryParse(rawValue);
    if (numericValue != null) {
      return DictFieldQueryTool.hazardousTypeLabel(numericValue, fallback: rawValue);
    }
    return rawValue;
  }
}

class _MainCardInfo extends StatelessWidget {
  const _MainCardInfo({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: AppDimens.dp8, vertical: AppDimens.dp6),
      decoration: BoxDecoration(color: const Color(0xFFF6F8FC), borderRadius: BorderRadius.circular(AppDimens.dp8)),
      child: Text(
        '$label：$value',
        style: TextStyle(color: AppColors.textSecondary, fontSize: AppDimens.sp11, fontWeight: FontWeight.w600),
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
            style: TextStyle(color: color, fontSize: AppDimens.sp13, fontWeight: FontWeight.w700),
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
      slivers: [SliverFillRemaining(hasScrollBody: false, child: Center(child: Text('暂无物流数据')))],
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
  final singleDay = start ?? end!;
  return DateTimeRange(start: singleDay, end: singleDay);
}
