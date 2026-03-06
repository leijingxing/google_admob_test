import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/components/custom_refresh.dart';
import '../../../../core/components/date_picker/custom_date_range_picker.dart';
import '../../../../core/constants/dimens.dart';
import '../../../../data/models/personnel_query/personnel_query_models.dart';
import 'detail_page/personnel_query_detail_binding.dart';
import 'detail_page/personnel_query_detail_page.dart';
import 'personnel_query_statistics_controller.dart';

/// 人员查询统计区块。
class PersonnelQueryStatisticsSection extends StatelessWidget {
  const PersonnelQueryStatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PersonnelQueryStatisticsController>(
      init: Get.isRegistered<PersonnelQueryStatisticsController>()
          ? Get.find<PersonnelQueryStatisticsController>()
          : PersonnelQueryStatisticsController(),
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PersonnelCountCard(
              countData: controller.countData,
              loading: controller.statsLoading,
              onRefresh: controller.loadPersonnelCount,
            ),
            SizedBox(height: AppDimens.dp8),
            _MainSearchPanel(controller: controller),
            SizedBox(height: AppDimens.dp10),
            Expanded(
              child: CustomEasyRefreshList<PersonnelComprehensiveItemModel>(
                refreshTrigger: controller.mainRefreshTrigger,
                dataLoader: controller.loadMainList,
                emptyWidget: const _MainEmptyState(),
                itemBuilder: (context, item, index) {
                  return _MainPersonnelCard(
                    item: item,
                    onView: () => _openDetailPage(controller, item),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _openDetailPage(
    PersonnelQueryStatisticsController controller,
    PersonnelComprehensiveItemModel row,
  ) {
    Get.to<void>(
      () => const PersonnelQueryDetailPage(),
      binding: PersonnelQueryDetailBinding(
        statisticsController: controller,
        row: row,
      ),
    );
  }
}

class _PersonnelCountCard extends StatelessWidget {
  const _PersonnelCountCard({
    required this.countData,
    required this.loading,
    required this.onRefresh,
  });

  final PersonnelCountModel countData;
  final bool loading;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            AppDimens.dp12,
            AppDimens.dp12,
            AppDimens.dp12,
            AppDimens.dp10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.dp12),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1E66C6), Color(0xFF4C92F6)],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x2D1E66C6),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '人员总览',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.95),
                  fontSize: AppDimens.sp14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: AppDimens.dp8),
              Row(
                children: [
                  _TopMetric(
                    label: '总数',
                    value: countData.totalCount,
                    textColor: const Color(0xFFFFFFFF),
                  ),
                  _TopMetric(
                    label: '黑名单',
                    value: countData.blackListCount,
                    textColor: const Color(0xFFB6FFD8),
                  ),
                  _TopMetric(
                    label: '白名单',
                    value: countData.whiteListCount,
                    textColor: const Color(0xFFE5F0FF),
                  ),
                  _TopMetric(
                    label: '预约',
                    value: countData.reservationCount,
                    textColor: const Color(0xFFE5F0FF),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: AppDimens.dp2,
          right: AppDimens.dp2,
          child: IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: loading ? null : onRefresh,
            icon: const Icon(
              Icons.refresh_rounded,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
        if (loading)
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.dp2),
              child: const LinearProgressIndicator(minHeight: 1.5),
            ),
          ),
      ],
    );
  }
}

class _TopMetric extends StatelessWidget {
  const _TopMetric({
    required this.label,
    required this.value,
    required this.textColor,
  });

  final String label;
  final int value;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '$value',
            style: TextStyle(
              color: textColor,
              fontSize: AppDimens.sp18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppDimens.dp2),
          Text(
            label,
            style: TextStyle(
              color: textColor.withValues(alpha: 0.9),
              fontSize: AppDimens.sp10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MainSearchPanel extends StatelessWidget {
  const _MainSearchPanel({required this.controller});

  final PersonnelQueryStatisticsController controller;

  @override
  Widget build(BuildContext context) {
    final range = controller.mainDateRange;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimens.dp8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp10),
        border: Border.all(color: const Color(0xFFD9E4FF)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D5DCC).withValues(alpha: 0.08),
            blurRadius: AppDimens.dp10,
            offset: Offset(0, AppDimens.dp2),
          ),
        ],
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
                        onSubmitted: (_) => controller.onSearchMainList(),
                        decoration: InputDecoration(
                          hintText: '请输入姓名/电话/证件号/单位',
                          isCollapsed: true,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: TextStyle(
                            color: const Color(0xFF8A98AF),
                            fontSize: AppDimens.sp12,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AppDimens.dp2,
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: const Color(0xFF4D8DFF),
                            size: AppDimens.dp20,
                          ),
                          suffixIcon: hasText
                              ? IconButton(
                                  icon: Icon(
                                    Icons.close_rounded,
                                    color: const Color(0xFF9AA8BE),
                                    size: AppDimens.dp18,
                                  ),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.dp8),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Icon(Icons.tune_rounded, size: 18),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.dp8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: AppDimens.dp14),
                  ),
                  child: const Text('查询'),
                ),
              ),
            ],
          ),
          if (range != null) ...[
            SizedBox(height: AppDimens.dp8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: AppDimens.dp8,
                vertical: AppDimens.dp6,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF6FAFF),
                borderRadius: BorderRadius.circular(AppDimens.dp8),
                border: Border.all(color: const Color(0xFFE1E9F5)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.event_note_rounded,
                    size: AppDimens.sp14,
                    color: const Color(0xFF5B6F8A),
                  ),
                  SizedBox(width: AppDimens.dp4),
                  Expanded(
                    child: Text(
                      '开始时间：${_formatDate(range.start)}  结束时间：${_formatDate(range.end)}',
                      style: TextStyle(
                        color: const Color(0xFF5B6F8A),
                        fontSize: AppDimens.sp11,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      controller.onMainDateRangeChanged(null);
                      controller.onSearchMainList();
                    },
                    child: const Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: Color(0xFF8DA0B8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _showFilterBottomSheet(BuildContext context) async {
    DateTimeRange? tempRange = controller.mainDateRange;

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
                    _FilterDateRangeField(
                      title: '开始时间',
                      range: tempRange,
                      onChanged: (value) {
                        setModalState(() => tempRange = value);
                      },
                    ),
                    SizedBox(height: AppDimens.dp14),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              controller.onMainDateRangeChanged(null);
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
                              controller.onMainDateRangeChanged(tempRange);
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

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}

class _MainPersonnelCard extends StatelessWidget {
  const _MainPersonnelCard({required this.item, required this.onView});

  final PersonnelComprehensiveItemModel item;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimens.dp8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp10),
        border: Border.all(color: const Color(0xFFDDE6F7)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A3D73).withValues(alpha: 0.06),
            blurRadius: AppDimens.dp10,
            offset: Offset(0, AppDimens.dp2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onView,
          borderRadius: BorderRadius.circular(AppDimens.dp10),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.dp8,
              vertical: AppDimens.dp10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: AppDimens.dp22,
                      height: AppDimens.dp22,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF2FF),
                        borderRadius: BorderRadius.circular(AppDimens.dp6),
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        size: AppDimens.sp13,
                        color: const Color(0xFF4D8DFF),
                      ),
                    ),
                    SizedBox(width: AppDimens.dp6),
                    Expanded(
                      child: Text(
                        item.name.isEmpty ? '--' : item.name,
                        style: TextStyle(
                          color: const Color(0xFF202020),
                          fontSize: AppDimens.sp16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimens.dp8,
                        vertical: AppDimens.dp4,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor(
                          item.validityStatus,
                        ).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppDimens.dp12),
                      ),
                      child: Text(
                        PersonnelQueryStatisticsController.validityStatusText(
                          item.validityStatus,
                        ),
                        style: TextStyle(
                          color: _statusColor(item.validityStatus),
                          fontSize: AppDimens.sp12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppDimens.dp8),
                _InfoLine(label: '联系电话', value: item.phone),
                SizedBox(height: AppDimens.dp4),
                _InfoLine(label: '证件号码', value: item.idCard),
                SizedBox(height: AppDimens.dp4),
                _InfoLine(label: '所属单位', value: item.unit),
                SizedBox(height: AppDimens.dp8),
                Row(
                  children: [
                    Expanded(
                      child: _MainCardMetric(
                        label: '预约/准入',
                        value: '${item.accessCount}',
                        color: const Color(0xFF397BFF),
                      ),
                    ),
                    SizedBox(width: AppDimens.dp6),
                    Expanded(
                      child: _MainCardMetric(
                        label: '出入',
                        value: '${item.inCount}/${item.outCount}',
                        color: const Color(0xFF2CA7A0),
                      ),
                    ),
                    SizedBox(width: AppDimens.dp6),
                    Expanded(
                      child: _MainCardMetric(
                        label: '违规',
                        value: '${item.violationCount}',
                        color: const Color(0xFFF58A34),
                      ),
                    ),
                    SizedBox(width: AppDimens.dp6),
                    Expanded(
                      child: _MainCardMetric(
                        label: '拉黑',
                        value: '${item.blackCount}',
                        color: const Color(0xFFDD5D5D),
                      ),
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

  Color _statusColor(int validityStatus) {
    if (validityStatus == 2) return const Color(0xFFE85D5D);
    if (validityStatus == 0) return const Color(0xFF1FA56E);
    if (validityStatus == 1) return const Color(0xFF2C9BFF);
    return const Color(0xFF8898AE);
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label：',
          style: TextStyle(
            color: const Color(0xFF6D7D93),
            fontSize: AppDimens.sp11,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value.trim().isEmpty ? '--' : value,
            style: TextStyle(
              color: const Color(0xFF35465C),
              fontSize: AppDimens.sp11,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _MainCardMetric extends StatelessWidget {
  const _MainCardMetric({
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
      padding: EdgeInsets.symmetric(vertical: AppDimens.dp6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDimens.dp8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: AppDimens.sp13,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppDimens.dp2),
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF6D7D93),
              fontSize: AppDimens.sp10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterDateRangeField extends StatelessWidget {
  const _FilterDateRangeField({
    required this.title,
    required this.range,
    required this.onChanged,
  });

  final String title;
  final DateTimeRange? range;
  final ValueChanged<DateTimeRange?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimens.dp10,
        AppDimens.dp9,
        AppDimens.dp10,
        AppDimens.dp10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F8FC),
        borderRadius: BorderRadius.circular(AppDimens.dp10),
        border: Border.all(color: const Color(0xFFDFE4ED)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: const Color(0xFF7D8A9A),
              fontSize: AppDimens.sp12,
            ),
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

class _MainEmptyState extends StatelessWidget {
  const _MainEmptyState();

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: Text('暂无人员数据')),
        ),
      ],
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
