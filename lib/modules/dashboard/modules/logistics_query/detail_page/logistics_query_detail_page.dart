import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/components/custom_refresh.dart';
import '../../../../../core/components/date_picker/custom_date_range_picker.dart';
import '../../../../../core/components/toast/toast_widget.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/dimens.dart';
import '../../../../../data/models/logistics_query/logistics_query_models.dart';
import '../../../../../data/models/workbench/appointment_approval_item_model.dart';
import '../../../../../router/module_routes/workbench_routes.dart';
import '../logistics_query_statistics_controller.dart';
import 'logistics_query_detail_controller.dart';

/// 物流详情页面。
class LogisticsQueryDetailPage extends GetView<LogisticsQueryDetailController> {
  const LogisticsQueryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LogisticsQueryDetailController>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: const Text('物流详情')),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFF3F8FF), Color(0xFFEAF2FF)]),
            ),
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  SizedBox(height: AppDimens.dp10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppDimens.dp12),
                    child: _LogisticsSummaryCard(row: logic.row),
                  ),
                  SizedBox(height: AppDimens.dp8),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppDimens.dp12),
                    child: FutureBuilder<LogisticsDetailCountModel>(
                      future: logic.detailCountFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Container(
                            height: AppDimens.dp80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(AppDimens.dp12),
                              border: Border.all(color: const Color(0xFFDCE7F8)),
                            ),
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(strokeWidth: 2),
                          );
                        }
                        if (snapshot.hasError) {
                          return _DetailCountError(onRetry: logic.reloadDetailCount);
                        }
                        final count = snapshot.data ?? const LogisticsDetailCountModel();
                        return _DetailCountTabs(count: count);
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(AppDimens.dp12, AppDimens.dp8, AppDimens.dp12, 0),
                    padding: EdgeInsets.all(AppDimens.dp4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppDimens.dp12),
                      border: Border.all(color: const Color(0xFFDDE6F5)),
                      boxShadow: const [BoxShadow(color: Color(0x0D1A4D9B), blurRadius: 10, offset: Offset(0, 2))],
                    ),
                    child: TabBar(
                      labelColor: Colors.white,
                      unselectedLabelColor: const Color(0xFF5D708A),
                      labelStyle: TextStyle(fontSize: AppDimens.sp12, fontWeight: FontWeight.w700),
                      unselectedLabelStyle: TextStyle(fontSize: AppDimens.sp12, fontWeight: FontWeight.w500),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF2D6FDB), Color(0xFF4A8DF4)]),
                        borderRadius: BorderRadius.circular(AppDimens.dp8),
                        boxShadow: const [BoxShadow(color: Color(0x292D6FDB), blurRadius: 8, offset: Offset(0, 2))],
                      ),
                      tabs: const [
                        Tab(text: '授权记录'),
                        Tab(text: '出入记录'),
                      ],
                    ),
                  ),
                  SizedBox(height: AppDimens.dp8),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(AppDimens.dp12, 0, AppDimens.dp12, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(AppDimens.dp14), topRight: Radius.circular(AppDimens.dp14)),
                        border: Border.all(color: const Color(0xFFDDE6F5)),
                        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2))],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(AppDimens.dp14), topRight: Radius.circular(AppDimens.dp14)),
                        child: TabBarView(
                          children: [
                            _AuthorizationRecordTab(controller: logic.statisticsController, row: logic.row),
                            _AccessRecordTab(controller: logic.statisticsController, row: logic.row),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LogisticsSummaryCard extends StatelessWidget {
  const _LogisticsSummaryCard({required this.row});

  final LogisticsComprehensiveItemModel row;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimens.dp12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF1D5FB2), Color(0xFF3D86DC)]),
        borderRadius: BorderRadius.circular(AppDimens.dp14),
        boxShadow: const [BoxShadow(color: Color(0x331D5FB2), blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '物资名称/类型',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.88), fontSize: AppDimens.sp10),
          ),
          SizedBox(height: AppDimens.dp4),
          Text(
            _goodsNameType(row),
            style: TextStyle(color: Colors.white, fontSize: AppDimens.sp18, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  String _goodsNameType(LogisticsComprehensiveItemModel item) {
    final goodsTypeText = LogisticsQueryStatisticsController.goodsTypeText(item.goodsType);
    final sections = <String>[if (item.goodsName.trim().isNotEmpty) item.goodsName.trim(), if (goodsTypeText != null && goodsTypeText.isNotEmpty) goodsTypeText];
    if (sections.isEmpty) return '--';
    return sections.join(' / ');
  }
}

class _DetailCountTabs extends StatelessWidget {
  const _DetailCountTabs({required this.count});

  final LogisticsDetailCountModel count;

  @override
  Widget build(BuildContext context) {
    final items = [
      _DetailCountItem(label: '授权记录', value: count.authorizationCount, accentColor: const Color(0xFF2D6FDB), backgroundColor: const Color(0xFFEFF4FF)),
      _DetailCountItem(label: '出入记录', value: count.accessRecordCount, accentColor: const Color(0xFF278A75), backgroundColor: const Color(0xFFE9F8F3)),
    ];

    return Row(
      children: items
          .map(
            (item) => Expanded(
              child: Container(
                margin: EdgeInsets.only(right: item == items.last ? 0 : AppDimens.dp8),
                padding: EdgeInsets.symmetric(vertical: AppDimens.dp10, horizontal: AppDimens.dp6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimens.dp10),
                  gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [item.backgroundColor, Colors.white]),
                  border: Border.all(color: item.accentColor.withValues(alpha: 0.2)),
                  boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2))],
                ),
                child: Column(
                  children: [
                    Text(
                      '${item.value}',
                      style: TextStyle(color: item.accentColor, fontSize: AppDimens.sp16, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: AppDimens.dp2),
                    Text(
                      item.label,
                      style: TextStyle(color: const Color(0xFF4F6482), fontSize: AppDimens.sp10),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _DetailCountItem {
  final String label;
  final int value;
  final Color accentColor;
  final Color backgroundColor;

  const _DetailCountItem({required this.label, required this.value, required this.accentColor, required this.backgroundColor});
}

class _DetailCountError extends StatelessWidget {
  const _DetailCountError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: AppDimens.dp10, vertical: AppDimens.dp10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp12),
        border: Border.all(color: const Color(0xFFDCE7F8)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, size: AppDimens.sp14, color: const Color(0xFFD38C20)),
          SizedBox(width: AppDimens.dp6),
          Expanded(
            child: Text(
              '统计加载失败',
              style: TextStyle(color: AppColors.textSecondary, fontSize: AppDimens.sp12),
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text('重试')),
        ],
      ),
    );
  }
}

class _AuthorizationRecordTab extends StatefulWidget {
  const _AuthorizationRecordTab({required this.controller, required this.row});

  final LogisticsQueryStatisticsController controller;
  final LogisticsComprehensiveItemModel row;

  @override
  State<_AuthorizationRecordTab> createState() => _AuthorizationRecordTabState();
}

class _AuthorizationRecordTabState extends State<_AuthorizationRecordTab> {
  final TextEditingController _keywordController = TextEditingController();
  final ValueNotifier<int> _refreshTrigger = ValueNotifier<int>(0);
  DateTimeRange? _parkCheckRange;
  DateTimeRange? _inDateRange;

  @override
  void dispose() {
    _keywordController.dispose();
    _refreshTrigger.dispose();
    super.dispose();
  }

  void _search() => _refreshTrigger.value++;

  void _reset() {
    _keywordController.clear();
    _parkCheckRange = null;
    _inDateRange = null;
    _refreshTrigger.value++;
    setState(() {});
  }

  void _onParkCheckRangeSelected(DateTime? start, DateTime? end) {
    setState(() {
      _parkCheckRange = _buildDateRange(start, end);
    });
  }

  void _onInDateRangeSelected(DateTime? start, DateTime? end) {
    setState(() {
      _inDateRange = _buildDateRange(start, end);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(AppDimens.dp12, AppDimens.dp10, AppDimens.dp12, 0),
      child: Column(
        children: [
          _SubSearchBar(
            keywordController: _keywordController,
            primaryRange: _parkCheckRange,
            primaryRangeTitle: '审批时间',
            onPrimaryRangeSelected: _onParkCheckRangeSelected,
            secondaryRange: _inDateRange,
            secondaryRangeTitle: '入园时间',
            onSecondaryRangeSelected: _onInDateRangeSelected,
            onSearch: _search,
            onReset: _reset,
          ),
          SizedBox(height: AppDimens.dp8),
          Expanded(
            child: CustomEasyRefreshList<LogisticsAuthorizationRecordModel>(
              refreshTrigger: _refreshTrigger,
              dataLoader: (pageIndex, pageSize) {
                return widget.controller.loadAuthorizationRecords(
                  pageIndex,
                  pageSize,
                  cas: widget.row.cas,
                  keyWords: _keywordController.text.trim(),
                  parkCheckTime: _parkCheckRange,
                  inDate: _inDateRange,
                );
              },
              itemBuilder: (context, item, index) {
                return _RecordCard(
                  title: '审批时间：${_emptyDash(item.parkCheckTime)}',
                  rows: [
                    '授权期限：${_emptyDash(item.validityBeginTime)} / ${_emptyDash(item.validityEndTime)}',
                    '车牌号：${_emptyDash(item.carNumb)}',
                    '装载类型：${LogisticsQueryDetailController.loadTypeText(item.loadType)}',
                    '目的地：${_emptyDash(item.destination)}',
                  ],
                  actions: [
                    TextButton(
                      onPressed: () => _openAppointmentApprovalDetail(id: item.reservationId ?? item.id, carNumb: item.carNumb),
                      child: const Text('详情'),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AccessRecordTab extends StatefulWidget {
  const _AccessRecordTab({required this.controller, required this.row});

  final LogisticsQueryStatisticsController controller;
  final LogisticsComprehensiveItemModel row;

  @override
  State<_AccessRecordTab> createState() => _AccessRecordTabState();
}

class _AccessRecordTabState extends State<_AccessRecordTab> {
  final TextEditingController _keywordController = TextEditingController();
  final ValueNotifier<int> _refreshTrigger = ValueNotifier<int>(0);
  DateTimeRange? _inDateRange;
  DateTimeRange? _outDateRange;

  @override
  void dispose() {
    _keywordController.dispose();
    _refreshTrigger.dispose();
    super.dispose();
  }

  void _search() => _refreshTrigger.value++;

  void _reset() {
    _keywordController.clear();
    _inDateRange = null;
    _outDateRange = null;
    _refreshTrigger.value++;
    setState(() {});
  }

  void _onInDateRangeSelected(DateTime? start, DateTime? end) {
    setState(() {
      _inDateRange = _buildDateRange(start, end);
    });
  }

  void _onOutDateRangeSelected(DateTime? start, DateTime? end) {
    setState(() {
      _outDateRange = _buildDateRange(start, end);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(AppDimens.dp12, AppDimens.dp10, AppDimens.dp12, 0),
      child: Column(
        children: [
          _SubSearchBar(
            keywordController: _keywordController,
            primaryRange: _inDateRange,
            primaryRangeTitle: '入园时间',
            onPrimaryRangeSelected: _onInDateRangeSelected,
            secondaryRange: _outDateRange,
            secondaryRangeTitle: '出园时间',
            onSecondaryRangeSelected: _onOutDateRangeSelected,
            onSearch: _search,
            onReset: _reset,
          ),
          SizedBox(height: AppDimens.dp8),
          Expanded(
            child: CustomEasyRefreshList<LogisticsAccessRecordModel>(
              refreshTrigger: _refreshTrigger,
              dataLoader: (pageIndex, pageSize) {
                return widget.controller.loadAccessRecords(pageIndex, pageSize, cas: widget.row.cas, keyWords: _keywordController.text.trim(), inDate: _inDateRange, outDate: _outDateRange);
              },
              itemBuilder: (context, item, index) {
                return _RecordCard(
                  title: '车牌号：${_emptyDash(item.carNumb)}',
                  rows: [
                    '目的地：${_emptyDash(item.destination)}',
                    '入园时间/闸机：${_emptyDash(item.inDate)} / ${_emptyDash(item.inDeviceName)}',
                    '运输数量：${_transportAmountText(item)}',
                    '出园时间/闸机：${_emptyDash(item.outDate)} / ${_emptyDash(item.outDeviceName)}',
                    '审批时间：${_emptyDash(item.parkCheckTime)}',
                    '授权期限：${_emptyDash(item.validityBeginTime)} / ${_emptyDash(item.validityEndTime)}',
                    '装载类型：${LogisticsQueryDetailController.loadTypeText(item.loadType)}',
                  ],
                  actions: [
                    TextButton(
                      onPressed: () => _openAppointmentApprovalDetail(id: item.reservationId ?? item.id, carNumb: item.carNumb),
                      child: const Text('详情'),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _transportAmountText(LogisticsAccessRecordModel item) {
    final transportAmount = item.transportAmount.trim();
    if (transportAmount.isNotEmpty && transportAmount != '0') {
      return transportAmount;
    }
    return '${_emptyDash(item.outGoodsAmount)} / ${_emptyDash(item.inGoodsAmount)}';
  }
}

class _RecordCard extends StatelessWidget {
  const _RecordCard({required this.title, required this.rows, this.actions = const <Widget>[]});

  final String title;
  final List<String> rows;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimens.dp8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp12),
        border: Border.all(color: const Color(0xFFE2EAF6)),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(AppDimens.dp10, AppDimens.dp9, AppDimens.dp10, AppDimens.dp8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimens.dp12)),
              gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFF4F8FF), Color(0xFFFFFFFF)]),
            ),
            child: Row(
              children: [
                Container(
                  width: AppDimens.dp3,
                  height: AppDimens.dp14,
                  decoration: BoxDecoration(color: const Color(0xFF2D6FDB), borderRadius: BorderRadius.circular(AppDimens.dp2)),
                ),
                SizedBox(width: AppDimens.dp6),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(color: const Color(0xFF253B56), fontSize: AppDimens.sp12, fontWeight: FontWeight.w700),
                  ),
                ),
                ...actions,
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(AppDimens.dp10, AppDimens.dp8, AppDimens.dp10, AppDimens.dp10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: rows
                  .map(
                    (text) => Padding(
                      padding: EdgeInsets.only(bottom: AppDimens.dp5),
                      child: Text(
                        text,
                        style: TextStyle(color: const Color(0xFF5A6E87), fontSize: AppDimens.sp10),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubSearchBar extends StatelessWidget {
  const _SubSearchBar({
    required this.keywordController,
    required this.onSearch,
    required this.onReset,
    this.primaryRange,
    this.primaryRangeTitle,
    this.onPrimaryRangeSelected,
    this.secondaryRange,
    this.secondaryRangeTitle,
    this.onSecondaryRangeSelected,
  });

  final TextEditingController keywordController;
  final DateTimeRange? primaryRange;
  final String? primaryRangeTitle;
  final Function(DateTime? start, DateTime? end)? onPrimaryRangeSelected;
  final DateTimeRange? secondaryRange;
  final String? secondaryRangeTitle;
  final Function(DateTime? start, DateTime? end)? onSecondaryRangeSelected;
  final VoidCallback onSearch;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimens.dp10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp12),
        border: Border.all(color: const Color(0xFFE1E6EF)),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: keywordController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => onSearch(),
              decoration: InputDecoration(
                isDense: true,
                hintText: '请输入查询关键词',
                hintStyle: TextStyle(color: const Color(0xFF8A9AB2), fontSize: AppDimens.sp12),
                prefixIcon: Icon(Icons.search_rounded, color: const Color(0xFF5D738F), size: AppDimens.sp16),
                filled: true,
                fillColor: const Color(0xFFF6FAFF),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimens.dp10), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimens.dp10), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimens.dp10),
                  borderSide: const BorderSide(color: Color(0xFF2D6FDB)),
                ),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.dp10)),
              ),
              child: const Icon(Icons.tune, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showFilterBottomSheet(BuildContext context) async {
    DateTimeRange? tempPrimaryRange = primaryRange;
    DateTimeRange? tempSecondaryRange = secondaryRange;

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
                    if (primaryRangeTitle != null && onPrimaryRangeSelected != null) ...[
                      _FilterDateRangeField(
                        title: primaryRangeTitle!,
                        range: tempPrimaryRange,
                        onChanged: (value) {
                          setModalState(() => tempPrimaryRange = value);
                        },
                      ),
                    ],
                    if (secondaryRangeTitle != null && onSecondaryRangeSelected != null) ...[
                      SizedBox(height: AppDimens.dp10),
                      _FilterDateRangeField(
                        title: secondaryRangeTitle!,
                        range: tempSecondaryRange,
                        onChanged: (value) {
                          setModalState(() => tempSecondaryRange = value);
                        },
                      ),
                    ],
                    if (primaryRangeTitle == null && secondaryRangeTitle == null) const _FilterPreviewField(text: '暂无额外筛选条件'),
                    SizedBox(height: AppDimens.dp14),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              onReset();
                              Navigator.of(bottomSheetContext).pop();
                            },
                            child: const Text('重置'),
                          ),
                        ),
                        SizedBox(width: AppDimens.dp10),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              _applyFilters(tempPrimaryRange, tempSecondaryRange);
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

  void _applyFilters(DateTimeRange? primaryDateRange, DateTimeRange? secondaryDateRange) {
    if (onPrimaryRangeSelected != null) {
      onPrimaryRangeSelected!.call(primaryDateRange?.start, primaryDateRange?.end);
    }
    if (onSecondaryRangeSelected != null) {
      onSecondaryRangeSelected!.call(secondaryDateRange?.start, secondaryDateRange?.end);
    }
    onSearch();
  }
}

class _FilterDateRangeField extends StatelessWidget {
  const _FilterDateRangeField({required this.title, required this.range, required this.onChanged});

  final String title;
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
            title,
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

class _FilterPreviewField extends StatelessWidget {
  const _FilterPreviewField({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimens.dp34,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: AppDimens.dp8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(AppDimens.dp6),
        border: Border.all(color: const Color(0xFFDCE2ED)),
      ),
      child: Text(
        text,
        style: TextStyle(color: const Color(0xFF7D8A9A), fontSize: AppDimens.sp12),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
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
  final singleDay = start ?? end!;
  return DateTimeRange(start: singleDay, end: singleDay);
}

void _openAppointmentApprovalDetail({String? id, String? carNumb}) {
  final detailId = (id ?? '').trim();
  if (detailId.isEmpty) {
    AppToast.showWarning('暂无预约信息');
    return;
  }
  WorkbenchRoutes.toAppointmentApprovalDetail(
    item: AppointmentApprovalItemModel(id: detailId, carNumb: carNumb),
  );
}

String _emptyDash(String? text) {
  if (text == null || text.trim().isEmpty) {
    return '--';
  }
  return text;
}
