import 'package:flutter/material.dart';

import '../../../../core/components/custom_refresh.dart';
import '../../../../core/components/toast/toast_widget.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/dimens.dart';
import '../../../../data/models/vehicle_query/vehicle_query_models.dart';
import 'vehicle_query_statistics_controller.dart';

/// 车辆详情抽屉。
class VehicleDetailSheet extends StatefulWidget {
  const VehicleDetailSheet({
    super.key,
    required this.controller,
    required this.row,
  });

  final VehicleQueryStatisticsController controller;
  final VehicleComprehensiveItemModel row;

  @override
  State<VehicleDetailSheet> createState() => _VehicleDetailSheetState();
}

class _VehicleDetailSheetState extends State<VehicleDetailSheet> {
  late Future<ComprehensiveDetailCountModel> _detailFuture;

  @override
  void initState() {
    super.initState();
    _detailFuture = widget.controller.loadDetailCount(
      carNumb: widget.row.carNumb,
      idCard: widget.row.idCard,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.6,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppDimens.dp18),
            ),
          ),
          child: DefaultTabController(
            length: 4,
            child: Column(
              children: [
                SizedBox(height: AppDimens.dp12),
                Container(
                  width: AppDimens.dp48,
                  height: AppDimens.dp5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD6DFEA),
                    borderRadius: BorderRadius.circular(AppDimens.dp8),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppDimens.dp16,
                    AppDimens.dp12,
                    AppDimens.dp8,
                    AppDimens.dp6,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '车辆详情 - ${widget.row.carNumb}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: AppDimens.sp16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimens.dp12),
                  child: FutureBuilder<ComprehensiveDetailCountModel>(
                    future: _detailFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          height: AppDimens.dp64,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return _DetailCountError(
                          onRetry: () {
                            setState(() {
                              _detailFuture = widget.controller.loadDetailCount(
                                carNumb: widget.row.carNumb,
                                idCard: widget.row.idCard,
                              );
                            });
                          },
                        );
                      }
                      final count =
                          snapshot.data ??
                          const ComprehensiveDetailCountModel();
                      return _DetailCountTabs(count: count);
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(
                    AppDimens.dp12,
                    AppDimens.dp8,
                    AppDimens.dp12,
                    0,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F8FD),
                    borderRadius: BorderRadius.circular(AppDimens.dp10),
                  ),
                  child: TabBar(
                    labelColor: const Color(0xFF2D6FDB),
                    unselectedLabelColor: const Color(0xFF5D708A),
                    labelStyle: TextStyle(
                      fontSize: AppDimens.sp12,
                      fontWeight: FontWeight.w700,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontSize: AppDimens.sp12,
                      fontWeight: FontWeight.w500,
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppDimens.dp8),
                    ),
                    tabs: const [
                      Tab(text: '授权记录'),
                      Tab(text: '出入记录'),
                      Tab(text: '违规记录'),
                      Tab(text: '拉黑记录'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _AuthorizationRecordTab(
                        controller: widget.controller,
                        row: widget.row,
                      ),
                      _AccessRecordTab(
                        controller: widget.controller,
                        row: widget.row,
                      ),
                      _ViolationRecordTab(
                        controller: widget.controller,
                        row: widget.row,
                      ),
                      _BlackRecordTab(
                        controller: widget.controller,
                        row: widget.row,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DetailCountTabs extends StatelessWidget {
  const _DetailCountTabs({required this.count});

  final ComprehensiveDetailCountModel count;

  @override
  Widget build(BuildContext context) {
    final items = [
      _DetailCountItem(label: '授权记录', value: count.authorizationCount),
      _DetailCountItem(label: '出入记录', value: count.accessRecordCount),
      _DetailCountItem(label: '违规记录', value: count.violationCount),
      _DetailCountItem(label: '拉黑记录', value: count.blackListCount),
    ];

    return Row(
      children: items
          .map(
            (item) => Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: item == items.last ? 0 : AppDimens.dp8,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: AppDimens.dp10,
                  horizontal: AppDimens.dp6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimens.dp10),
                  color: const Color(0xFFF2F6FE),
                  border: Border.all(color: const Color(0xFFDCE7F8)),
                ),
                child: Column(
                  children: [
                    Text(
                      '${item.value}',
                      style: TextStyle(
                        color: const Color(0xFF2E64B6),
                        fontSize: AppDimens.sp16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: AppDimens.dp2),
                    Text(
                      item.label,
                      style: TextStyle(
                        color: const Color(0xFF4F6482),
                        fontSize: AppDimens.sp10,
                      ),
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

  const _DetailCountItem({required this.label, required this.value});
}

class _DetailCountError extends StatelessWidget {
  const _DetailCountError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppDimens.dp8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '统计加载失败',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: AppDimens.sp12,
              ),
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

  final VehicleQueryStatisticsController controller;
  final VehicleComprehensiveItemModel row;

  @override
  State<_AuthorizationRecordTab> createState() =>
      _AuthorizationRecordTabState();
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

  Future<void> _pickRange(bool parkCheck) async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 1),
      initialDateRange: parkCheck ? _parkCheckRange : _inDateRange,
      helpText: parkCheck ? '选择审批时间' : '选择入园时间',
    );
    if (range == null) return;
    setState(() {
      if (parkCheck) {
        _parkCheckRange = range;
      } else {
        _inDateRange = range;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppDimens.dp12,
        AppDimens.dp10,
        AppDimens.dp12,
        0,
      ),
      child: Column(
        children: [
          _SubSearchBar(
            keywordController: _keywordController,
            firstRangeText: _rangeText(_parkCheckRange, '审批时间'),
            secondRangeText: _rangeText(_inDateRange, '入园时间'),
            onFirstRangeTap: () => _pickRange(true),
            onSecondRangeTap: () => _pickRange(false),
            onSearch: _search,
            onReset: _reset,
          ),
          SizedBox(height: AppDimens.dp8),
          Expanded(
            child: CustomEasyRefreshList<VehicleAuthorizationRecordModel>(
              refreshTrigger: _refreshTrigger,
              dataLoader: (pageIndex, pageSize) {
                return widget.controller.loadAuthorizationRecords(
                  pageIndex,
                  pageSize,
                  keyWords: _keywordController.text.trim(),
                  parkCheckTime: _parkCheckRange,
                  inDate: _inDateRange,
                  carNumb: widget.row.carNumb,
                  idCard: '',
                  type: '',
                );
              },
              itemBuilder: (context, item, index) {
                return _RecordCard(
                  title: '审批时间：${_emptyDash(item.approvalTime)}',
                  rows: [
                    '授权期限：${_emptyDash(item.validityBeginTime)} / ${_emptyDash(item.validityEndTime)}',
                    '准入类别：${VehicleQueryStatisticsController.recordTypeLabelMap[item.recordType] ?? '未知'}',
                    '联系电话：${_emptyDash(item.userPhone)}',
                    '目的地：${_emptyDash(item.destination)}',
                    '入园时间：${_emptyDash(item.inDate)}',
                  ],
                  actions: [
                    TextButton(
                      onPressed: () => AppToast.showInfo('移动端暂未接入详情跳转'),
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

  final VehicleQueryStatisticsController controller;
  final VehicleComprehensiveItemModel row;

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

  Future<void> _pickRange(bool inDate) async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 1),
      initialDateRange: inDate ? _inDateRange : _outDateRange,
      helpText: inDate ? '选择入园时间' : '选择出园时间',
    );
    if (range == null) return;
    setState(() {
      if (inDate) {
        _inDateRange = range;
      } else {
        _outDateRange = range;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppDimens.dp12,
        AppDimens.dp10,
        AppDimens.dp12,
        0,
      ),
      child: Column(
        children: [
          _SubSearchBar(
            keywordController: _keywordController,
            firstRangeText: _rangeText(_inDateRange, '入园时间'),
            secondRangeText: _rangeText(_outDateRange, '出园时间'),
            onFirstRangeTap: () => _pickRange(true),
            onSecondRangeTap: () => _pickRange(false),
            onSearch: _search,
            onReset: _reset,
          ),
          SizedBox(height: AppDimens.dp8),
          Expanded(
            child: CustomEasyRefreshList<VehicleAccessRecordModel>(
              refreshTrigger: _refreshTrigger,
              dataLoader: (pageIndex, pageSize) {
                return widget.controller.loadAccessRecords(
                  pageIndex,
                  pageSize,
                  keyWords: _keywordController.text.trim(),
                  inDate: _inDateRange,
                  outDate: _outDateRange,
                  carNumb: widget.row.carNumb,
                  idCard: widget.row.idCard,
                  type: '',
                );
              },
              itemBuilder: (context, item, index) {
                return _RecordCard(
                  title: '联系电话：${_emptyDash(item.userPhone)}',
                  rows: [
                    '目的地：${_emptyDash(item.destination)}',
                    '准入类别：${VehicleQueryStatisticsController.recordTypeLabelMap[item.recordType] ?? '未知'}',
                    '入园时间/闸机：${_emptyDash(item.inDate)} / ${_emptyDash(item.inDeviceName)}',
                    '出园时间/闸机：${_emptyDash(item.outDate)} / ${_emptyDash(item.outDeviceName)}',
                    '违规次数：${item.violationCount}',
                  ],
                  actions: [
                    TextButton(
                      onPressed: () => AppToast.showInfo('移动端暂未接入详情跳转'),
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

class _ViolationRecordTab extends StatefulWidget {
  const _ViolationRecordTab({required this.controller, required this.row});

  final VehicleQueryStatisticsController controller;
  final VehicleComprehensiveItemModel row;

  @override
  State<_ViolationRecordTab> createState() => _ViolationRecordTabState();
}

class _ViolationRecordTabState extends State<_ViolationRecordTab> {
  final TextEditingController _keywordController = TextEditingController();
  final ValueNotifier<int> _refreshTrigger = ValueNotifier<int>(0);
  DateTimeRange? _warningRange;

  @override
  void dispose() {
    _keywordController.dispose();
    _refreshTrigger.dispose();
    super.dispose();
  }

  void _search() => _refreshTrigger.value++;

  void _reset() {
    _keywordController.clear();
    _warningRange = null;
    _refreshTrigger.value++;
    setState(() {});
  }

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 1),
      initialDateRange: _warningRange,
      helpText: '选择违规时间',
    );
    if (range == null) return;
    setState(() => _warningRange = range);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppDimens.dp12,
        AppDimens.dp10,
        AppDimens.dp12,
        0,
      ),
      child: Column(
        children: [
          _SubSearchBar(
            keywordController: _keywordController,
            firstRangeText: _rangeText(_warningRange, '违规时间'),
            secondRangeText: null,
            onFirstRangeTap: _pickRange,
            onSecondRangeTap: null,
            onSearch: _search,
            onReset: _reset,
          ),
          SizedBox(height: AppDimens.dp8),
          Expanded(
            child: CustomEasyRefreshList<VehicleViolationRecordModel>(
              refreshTrigger: _refreshTrigger,
              dataLoader: (pageIndex, pageSize) {
                return widget.controller.loadViolationRecords(
                  pageIndex,
                  pageSize,
                  keyword: _keywordController.text.trim(),
                  warningStartTime: _warningRange,
                  carNum: widget.row.carNumb,
                );
              },
              itemBuilder: (context, item, index) {
                return _RecordCard(
                  title: '违规类型：${_emptyDash(item.subModuleTypeName)}',
                  rows: [
                    '违规描述：${_emptyDash(item.description)}',
                    '违规时间：${_emptyDash(item.warningStartTime)}',
                    '违规地点：${_emptyDash(item.position)}',
                  ],
                  footer:
                      item.warningFileUrl == null ||
                          item.warningFileUrl!.isEmpty
                      ? null
                      : Padding(
                          padding: EdgeInsets.only(top: AppDimens.dp8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppDimens.dp8),
                            child: Image.network(
                              item.warningFileUrl!,
                              height: AppDimens.dp120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) {
                                return Container(
                                  height: AppDimens.dp120,
                                  color: const Color(0xFFF0F4FA),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '影像加载失败',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: AppDimens.sp12,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BlackRecordTab extends StatefulWidget {
  const _BlackRecordTab({required this.controller, required this.row});

  final VehicleQueryStatisticsController controller;
  final VehicleComprehensiveItemModel row;

  @override
  State<_BlackRecordTab> createState() => _BlackRecordTabState();
}

class _BlackRecordTabState extends State<_BlackRecordTab> {
  final TextEditingController _keywordController = TextEditingController();
  final ValueNotifier<int> _refreshTrigger = ValueNotifier<int>(0);

  @override
  void dispose() {
    _keywordController.dispose();
    _refreshTrigger.dispose();
    super.dispose();
  }

  void _search() => _refreshTrigger.value++;

  void _reset() {
    _keywordController.clear();
    _refreshTrigger.value++;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppDimens.dp12,
        AppDimens.dp10,
        AppDimens.dp12,
        0,
      ),
      child: Column(
        children: [
          _SubSearchBar(
            keywordController: _keywordController,
            firstRangeText: null,
            secondRangeText: null,
            onFirstRangeTap: null,
            onSecondRangeTap: null,
            onSearch: _search,
            onReset: _reset,
          ),
          SizedBox(height: AppDimens.dp8),
          Expanded(
            child: CustomEasyRefreshList<VehicleBlackRecordModel>(
              refreshTrigger: _refreshTrigger,
              dataLoader: (pageIndex, pageSize) {
                return widget.controller.loadBlackRecords(
                  pageIndex,
                  pageSize,
                  keyword: _keywordController.text.trim(),
                  carNumb: widget.row.carNumb,
                  realName: '',
                  type: 2,
                );
              },
              itemBuilder: (context, item, index) {
                return _RecordCard(
                  title: '联系电话：${_emptyDash(item.userPhone)}',
                  rows: [
                    '操作类型：${VehicleQueryStatisticsController.blackRecordStatusLabelMap[item.status] ?? '未知'}',
                    '操作人：${_emptyDash(item.createBy)}',
                    '操作时间：${_emptyDash(item.createDate)}',
                    '描述：${_emptyDash(item.remark)}',
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

class _RecordCard extends StatelessWidget {
  const _RecordCard({
    required this.title,
    required this.rows,
    this.actions = const <Widget>[],
    this.footer,
  });

  final String title;
  final List<String> rows;
  final List<Widget> actions;
  final Widget? footer;

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
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: const Color(0xFF253B56),
                      fontSize: AppDimens.sp12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                ...actions,
              ],
            ),
            SizedBox(height: AppDimens.dp6),
            ...rows.map(
              (text) => Padding(
                padding: EdgeInsets.only(bottom: AppDimens.dp4),
                child: Text(
                  text,
                  style: TextStyle(
                    color: const Color(0xFF5A6E87),
                    fontSize: AppDimens.sp10,
                  ),
                ),
              ),
            ),
            if (footer case final footerWidget?) footerWidget,
          ],
        ),
      ),
    );
  }
}

class _SubSearchBar extends StatelessWidget {
  const _SubSearchBar({
    required this.keywordController,
    required this.onSearch,
    required this.onReset,
    this.firstRangeText,
    this.secondRangeText,
    this.onFirstRangeTap,
    this.onSecondRangeTap,
  });

  final TextEditingController keywordController;
  final String? firstRangeText;
  final String? secondRangeText;
  final VoidCallback? onFirstRangeTap;
  final VoidCallback? onSecondRangeTap;
  final VoidCallback onSearch;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(
            width: AppDimens.dp140,
            child: TextField(
              controller: keywordController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => onSearch(),
              decoration: InputDecoration(
                isDense: true,
                hintText: '请输入查询关键词',
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
          ),
          if (firstRangeText != null) ...[
            SizedBox(width: AppDimens.dp8),
            _RangeButton(text: firstRangeText!, onTap: onFirstRangeTap),
          ],
          if (secondRangeText != null) ...[
            SizedBox(width: AppDimens.dp8),
            _RangeButton(text: secondRangeText!, onTap: onSecondRangeTap),
          ],
          SizedBox(width: AppDimens.dp8),
          FilledButton.tonal(
            onPressed: onSearch,
            style: FilledButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.symmetric(
                horizontal: AppDimens.dp10,
                vertical: AppDimens.dp8,
              ),
            ),
            child: const Text('搜索'),
          ),
          SizedBox(width: AppDimens.dp6),
          OutlinedButton(
            onPressed: onReset,
            style: OutlinedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.symmetric(
                horizontal: AppDimens.dp10,
                vertical: AppDimens.dp8,
              ),
            ),
            child: const Text('重置'),
          ),
        ],
      ),
    );
  }
}

class _RangeButton extends StatelessWidget {
  const _RangeButton({required this.text, this.onTap});

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.dp10),
      child: Container(
        height: AppDimens.dp44,
        constraints: BoxConstraints(minWidth: AppDimens.dp112),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.dp10,
          vertical: AppDimens.dp8,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAFF),
          borderRadius: BorderRadius.circular(AppDimens.dp10),
          border: Border.all(color: const Color(0xFFE1E9F6)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.date_range_rounded,
              size: AppDimens.sp12,
              color: const Color(0xFF5F738D),
            ),
            SizedBox(width: AppDimens.dp4),
            Text(
              text,
              style: TextStyle(
                color: const Color(0xFF4A607C),
                fontSize: AppDimens.sp10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _rangeText(DateTimeRange? range, String placeholder) {
  if (range == null) return placeholder;
  final s = '${range.start.year}-${range.start.month}-${range.start.day}';
  final e = '${range.end.year}-${range.end.month}-${range.end.day}';
  return '$s ~ $e';
}

String _emptyDash(String? text) {
  if (text == null || text.trim().isEmpty) {
    return '--';
  }
  return text;
}
