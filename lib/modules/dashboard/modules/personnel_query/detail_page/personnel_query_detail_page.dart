import 'package:closed_off_app/core/components/custom_refresh.dart';
import 'package:closed_off_app/core/components/date_picker/custom_date_range_picker.dart';
import 'package:closed_off_app/core/components/toast/toast_widget.dart';
import 'package:closed_off_app/core/constants/app_colors.dart';
import 'package:closed_off_app/core/constants/dimens.dart';
import 'package:closed_off_app/core/utils/file_service.dart';
import 'package:closed_off_app/data/models/personnel_query/personnel_query_models.dart';
import 'package:closed_off_app/data/models/vehicle_query/vehicle_query_models.dart';
import 'package:closed_off_app/data/models/workbench/appointment_approval_item_model.dart';
import 'package:closed_off_app/modules/dashboard/modules/personnel_query/detail_page/personnel_query_detail_controller.dart';
import 'package:closed_off_app/modules/dashboard/modules/personnel_query/personnel_query_statistics_controller.dart';
import 'package:closed_off_app/router/module_routes/workbench_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 人员详情页面。
class PersonnelQueryDetailPage extends GetView<PersonnelQueryDetailController> {
  const PersonnelQueryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PersonnelQueryDetailController>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: const Text('人员详情')),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF3F8FF), Color(0xFFEAF2FF)],
              ),
            ),
            child: DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  SizedBox(height: AppDimens.dp10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppDimens.dp12),
                    child: _PersonnelSummaryCard(row: logic.row),
                  ),
                  SizedBox(height: AppDimens.dp8),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppDimens.dp12),
                    child: FutureBuilder<ComprehensiveDetailCountModel>(
                      future: logic.detailCountFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            height: AppDimens.dp80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                AppDimens.dp12,
                              ),
                              border: Border.all(
                                color: const Color(0xFFDCE7F8),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return _DetailCountError(
                            onRetry: logic.reloadDetailCount,
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
                    padding: EdgeInsets.all(AppDimens.dp4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppDimens.dp12),
                      border: Border.all(color: const Color(0xFFDDE6F5)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0D1A4D9B),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TabBar(
                      labelColor: Colors.white,
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
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2D6FDB), Color(0xFF4A8DF4)],
                        ),
                        borderRadius: BorderRadius.circular(AppDimens.dp8),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x292D6FDB),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      tabs: const [
                        Tab(text: '授权记录'),
                        Tab(text: '出入记录'),
                        Tab(text: '违规记录'),
                        Tab(text: '拉黑记录'),
                      ],
                    ),
                  ),
                  SizedBox(height: AppDimens.dp8),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(
                        AppDimens.dp12,
                        0,
                        AppDimens.dp12,
                        0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppDimens.dp14),
                          topRight: Radius.circular(AppDimens.dp14),
                        ),
                        border: Border.all(color: const Color(0xFFDDE6F5)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0A000000),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppDimens.dp14),
                          topRight: Radius.circular(AppDimens.dp14),
                        ),
                        child: TabBarView(
                          children: [
                            _AuthorizationRecordTab(
                              controller: logic.statisticsController,
                              row: logic.row,
                            ),
                            _AccessRecordTab(
                              controller: logic.statisticsController,
                              row: logic.row,
                            ),
                            _ViolationRecordTab(
                              controller: logic.statisticsController,
                              row: logic.row,
                            ),
                            _BlackRecordTab(
                              controller: logic.statisticsController,
                              row: logic.row,
                            ),
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

class _PersonnelSummaryCard extends StatelessWidget {
  const _PersonnelSummaryCard({required this.row});

  final PersonnelComprehensiveItemModel row;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimens.dp12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1D5FB2), Color(0xFF3D86DC)],
        ),
        borderRadius: BorderRadius.circular(AppDimens.dp14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x331D5FB2),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _emptyDash(row.name),
            style: TextStyle(
              color: Colors.white,
              fontSize: AppDimens.sp20,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppDimens.dp8),
          _SummaryInfo(text: '证件号码：${_emptyDash(row.idCard)}'),
          SizedBox(height: AppDimens.dp4),
          _SummaryInfo(text: '联系电话：${_emptyDash(row.phone)}'),
          SizedBox(height: AppDimens.dp4),
          _SummaryInfo(text: '所属单位：${_emptyDash(row.unit)}'),
        ],
      ),
    );
  }
}

class _SummaryInfo extends StatelessWidget {
  const _SummaryInfo({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.9),
        fontSize: AppDimens.sp11,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _DetailCountTabs extends StatelessWidget {
  const _DetailCountTabs({required this.count});

  final ComprehensiveDetailCountModel count;

  @override
  Widget build(BuildContext context) {
    final items = [
      _DetailCountItem(
        label: '授权记录',
        value: count.authorizationCount,
        accentColor: const Color(0xFF2D6FDB),
        backgroundColor: const Color(0xFFEFF4FF),
      ),
      _DetailCountItem(
        label: '出入记录',
        value: count.accessRecordCount,
        accentColor: const Color(0xFF278A75),
        backgroundColor: const Color(0xFFE9F8F3),
      ),
      _DetailCountItem(
        label: '违规记录',
        value: count.violationCount,
        accentColor: const Color(0xFFBC6C14),
        backgroundColor: const Color(0xFFFFF5E9),
      ),
      _DetailCountItem(
        label: '拉黑记录',
        value: count.blackListCount,
        accentColor: const Color(0xFFB2433B),
        backgroundColor: const Color(0xFFFFEEEE),
      ),
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
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [item.backgroundColor, Colors.white],
                  ),
                  border: Border.all(
                    color: item.accentColor.withValues(alpha: 0.2),
                  ),
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
                    Text(
                      '${item.value}',
                      style: TextStyle(
                        color: item.accentColor,
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
  final Color accentColor;
  final Color backgroundColor;

  const _DetailCountItem({
    required this.label,
    required this.value,
    required this.accentColor,
    required this.backgroundColor,
  });
}

class _DetailCountError extends StatelessWidget {
  const _DetailCountError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp10,
        vertical: AppDimens.dp10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp12),
        border: Border.all(color: const Color(0xFFDCE7F8)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: AppDimens.sp14,
            color: const Color(0xFFD38C20),
          ),
          SizedBox(width: AppDimens.dp6),
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

  final PersonnelQueryStatisticsController controller;
  final PersonnelComprehensiveItemModel row;

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
            child: CustomEasyRefreshList<VehicleAuthorizationRecordModel>(
              refreshTrigger: _refreshTrigger,
              dataLoader: (pageIndex, pageSize) {
                return widget.controller.loadAuthorizationRecords(
                  pageIndex,
                  pageSize,
                  idCard: widget.row.idCard,
                  keyWords: _keywordController.text.trim(),
                  parkCheckTime: _parkCheckRange,
                  inDate: _inDateRange,
                );
              },
              itemBuilder: (context, item, index) {
                return _RecordCard(
                  title: '审批时间：${_emptyDash(item.approvalTime)}',
                  rows: [
                    '授权期限：${_emptyDash(item.validityBeginTime)} / ${_emptyDash(item.validityEndTime)}',
                    '准入类别：${PersonnelQueryDetailController.recordTypeText(item.recordType)}',
                    '联系电话：${_emptyDash(item.userPhone)}',
                    '目的地：${_emptyDash(item.destination)}',
                    '入园时间：${_emptyDash(item.inDate)}',
                  ],
                  actions: [
                    TextButton(
                      onPressed: () =>
                          _openAppointmentApprovalDetail(id: item.id),
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

  final PersonnelQueryStatisticsController controller;
  final PersonnelComprehensiveItemModel row;

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
            child: CustomEasyRefreshList<VehicleAccessRecordModel>(
              refreshTrigger: _refreshTrigger,
              dataLoader: (pageIndex, pageSize) {
                return widget.controller.loadAccessRecords(
                  pageIndex,
                  pageSize,
                  idCard: widget.row.idCard,
                  keyWords: _keywordController.text.trim(),
                  inDate: _inDateRange,
                  outDate: _outDateRange,
                  type: 1,
                );
              },
              itemBuilder: (context, item, index) {
                return _RecordCard(
                  title: '联系电话：${_emptyDash(item.userPhone)}',
                  rows: [
                    '目的地：${_emptyDash(item.destination)}',
                    '准入类别：${PersonnelQueryDetailController.recordTypeText(item.recordType)}',
                    '入园时间/闸机：${_emptyDash(item.inDate)} / ${_emptyDash(item.inDeviceName)}',
                    '出园时间/闸机：${_emptyDash(item.outDate)} / ${_emptyDash(item.outDeviceName)}',
                    '违规次数：${item.violationCount}',
                  ],
                  actions: [
                    TextButton(
                      onPressed: () => _openAppointmentApprovalDetail(
                        id: item.reservationOrWhileId,
                      ),
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

  final PersonnelQueryStatisticsController controller;
  final PersonnelComprehensiveItemModel row;

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

  void _onWarningRangeSelected(DateTime? start, DateTime? end) {
    setState(() {
      _warningRange = _buildDateRange(start, end);
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
            primaryRange: _warningRange,
            primaryRangeTitle: '违规时间',
            onPrimaryRangeSelected: _onWarningRangeSelected,
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
                  carNum: '',
                );
              },
              itemBuilder: (context, item, index) {
                final fullUrl = FileService.getFaceUrl(item.warningFileUrl);
                return _RecordCard(
                  title: '违规类型：${_emptyDash(item.subModuleTypeName)}',
                  rows: [
                    '违规描述：${_emptyDash(item.description)}',
                    '违规时间：${_emptyDash(item.warningStartTime)}',
                    '违规地点：${_emptyDash(item.position)}',
                  ],
                  footer: fullUrl == null || fullUrl.isEmpty
                      ? null
                      : Padding(
                          padding: EdgeInsets.only(top: AppDimens.dp8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppDimens.dp8),
                            child: Image.network(
                              fullUrl,
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

  final PersonnelQueryStatisticsController controller;
  final PersonnelComprehensiveItemModel row;

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
                  realName: widget.row.name,
                  type: 1,
                );
              },
              itemBuilder: (context, item, index) {
                return _RecordCard(
                  title: '联系电话：${_emptyDash(item.userPhone)}',
                  rows: [
                    '操作类型：${PersonnelQueryDetailController.blackRecordStatusText(item.status)}',
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
    return Container(
      margin: EdgeInsets.only(bottom: AppDimens.dp8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp12),
        border: Border.all(color: const Color(0xFFE2EAF6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              AppDimens.dp10,
              AppDimens.dp9,
              AppDimens.dp10,
              AppDimens.dp8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppDimens.dp12),
              ),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF4F8FF), Color(0xFFFFFFFF)],
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: AppDimens.dp3,
                  height: AppDimens.dp14,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D6FDB),
                    borderRadius: BorderRadius.circular(AppDimens.dp2),
                  ),
                ),
                SizedBox(width: AppDimens.dp6),
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
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppDimens.dp10,
              AppDimens.dp8,
              AppDimens.dp10,
              AppDimens.dp10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...rows.map(
                  (text) => Padding(
                    padding: EdgeInsets.only(bottom: AppDimens.dp5),
                    child: Text(
                      text,
                      style: TextStyle(
                        color: const Color(0xFF5A6E87),
                        fontSize: AppDimens.sp10,
                      ),
                    ),
                  ),
                ),
                if (footer != null)
                  Padding(
                    padding: EdgeInsets.only(top: AppDimens.dp2),
                    child: footer!,
                  ),
              ],
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

  bool get _hasExtraFilters {
    return (primaryRangeTitle != null && onPrimaryRangeSelected != null) ||
        (secondaryRangeTitle != null && onSecondaryRangeSelected != null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
                hintStyle: TextStyle(
                  color: const Color(0xFF8A9AB2),
                  fontSize: AppDimens.sp12,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: const Color(0xFF5D738F),
                  size: AppDimens.sp16,
                ),
                filled: true,
                fillColor: const Color(0xFFF6FAFF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimens.dp10),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimens.dp10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimens.dp10),
                  borderSide: const BorderSide(color: Color(0xFF2D6FDB)),
                ),
              ),
            ),
          ),
          if (_hasExtraFilters) ...[
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.dp10),
                  ),
                ),
                child: const Icon(Icons.tune, size: 16),
              ),
            ),
          ],
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
                    if (primaryRangeTitle != null &&
                        onPrimaryRangeSelected != null) ...[
                      _FilterDateRangeField(
                        title: primaryRangeTitle!,
                        range: tempPrimaryRange,
                        onChanged: (value) {
                          setModalState(() => tempPrimaryRange = value);
                        },
                      ),
                    ],
                    if (secondaryRangeTitle != null &&
                        onSecondaryRangeSelected != null) ...[
                      SizedBox(height: AppDimens.dp10),
                      _FilterDateRangeField(
                        title: secondaryRangeTitle!,
                        range: tempSecondaryRange,
                        onChanged: (value) {
                          setModalState(() => tempSecondaryRange = value);
                        },
                      ),
                    ],
                    if (primaryRangeTitle == null &&
                        secondaryRangeTitle == null)
                      const _FilterPreviewField(text: '暂无额外筛选条件'),
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
                              _applyFilters(
                                tempPrimaryRange,
                                tempSecondaryRange,
                              );
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

  void _applyFilters(
    DateTimeRange? primaryDateRange,
    DateTimeRange? secondaryDateRange,
  ) {
    if (onPrimaryRangeSelected != null) {
      onPrimaryRangeSelected!.call(
        primaryDateRange?.start,
        primaryDateRange?.end,
      );
    }
    if (onSecondaryRangeSelected != null) {
      onSecondaryRangeSelected!.call(
        secondaryDateRange?.start,
        secondaryDateRange?.end,
      );
    }
    onSearch();
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
        style: TextStyle(
          color: const Color(0xFF7D8A9A),
          fontSize: AppDimens.sp12,
        ),
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
    AppToast.showWarning('当前记录缺少详情ID');
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
