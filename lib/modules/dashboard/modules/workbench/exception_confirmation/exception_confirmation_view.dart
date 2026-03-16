import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/components/app_info_status_card.dart';
import '../../../../../core/components/app_text_field.dart';
import '../../../../../core/components/custom_refresh.dart';
import '../../../../../core/components/custom_sliding_tab_bar.dart';
import '../../../../../core/components/date_picker/custom_date_range_picker.dart';
import '../../../../../core/constants/dimens.dart';
import '../../../../../core/components/toast/toast_widget.dart';
import '../../../../../core/utils/file_service.dart';
import '../../../../../data/models/workbench/exception_confirmation_item_model.dart';
import 'exception_confirmation_detail_page.dart';
import 'exception_confirmation_controller.dart';

/// 异常确认页面。
class ExceptionConfirmationView
    extends GetView<ExceptionConfirmationController> {
  const ExceptionConfirmationView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExceptionConfirmationController>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: Text(logic.pageTitle)),
          body: _ExceptionConfirmationBody(controller: logic),
        );
      },
    );
  }
}

class _ExceptionConfirmationBody extends StatefulWidget {
  const _ExceptionConfirmationBody({required this.controller});

  final ExceptionConfirmationController controller;

  @override
  State<_ExceptionConfirmationBody> createState() =>
      _ExceptionConfirmationBodyState();
}

class _ExceptionConfirmationBodyState extends State<_ExceptionConfirmationBody>
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
  void didUpdateWidget(covariant _ExceptionConfirmationBody oldWidget) {
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
        _ExceptionFilterSection(
          controller: widget.controller,
          tabController: _tabController,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: List.generate(widget.controller.tabItems.length, (
              tabIndex,
            ) {
              return CustomEasyRefreshList<ExceptionConfirmationItemModel>(
                key: ValueKey('exception-confirmation-$tabIndex'),
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
                    child: _ExceptionConfirmationCard(
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

class _ExceptionFilterSection extends StatelessWidget {
  const _ExceptionFilterSection({
    required this.controller,
    required this.tabController,
  });

  final ExceptionConfirmationController controller;
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
              Expanded(
                child: AppTextField.search(
                  controller: controller.keywordController,
                  hintText: '请输入上报人、异常描述或备注',
                  onSubmitted: controller.applyKeyword,
                  onSearch: () => controller.applyKeyword(
                    controller.keywordController.text,
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.dp10),
                    ),
                  ),
                  child: const Icon(Icons.tune, size: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showFilterBottomSheet(BuildContext context) async {
    DateTimeRange? tempDateRange = controller.dateRange;

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
                    CustomDateRangePicker(
                      startDate: tempDateRange?.start,
                      endDate: tempDateRange?.end,
                      onDateRangeSelected: (start, end) {
                        if (start == null && end == null) {
                          setModalState(() => tempDateRange = null);
                          return;
                        }
                        if (start != null && end != null) {
                          final sortedStart = start.isBefore(end) ? start : end;
                          final sortedEnd = start.isBefore(end) ? end : start;
                          setModalState(() {
                            tempDateRange = DateTimeRange(
                              start: sortedStart,
                              end: sortedEnd,
                            );
                          });
                          return;
                        }
                        final date = start ?? end!;
                        setModalState(() {
                          tempDateRange = DateTimeRange(start: date, end: date);
                        });
                      },
                    ),
                    SizedBox(height: AppDimens.dp14),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              controller.keywordController.clear();
                              controller.applyFilters(nextDateRange: null);
                              Navigator.of(bottomSheetContext).pop();
                            },
                            child: const Text('重置'),
                          ),
                        ),
                        SizedBox(width: AppDimens.dp10),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              controller.applyFilters(
                                nextDateRange: tempDateRange,
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
}

class _ExceptionConfirmationCard extends StatelessWidget {
  const _ExceptionConfirmationCard({
    required this.item,
    required this.controller,
  });

  final ExceptionConfirmationItemModel item;
  final ExceptionConfirmationController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimens.dp12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.exceptionLocation?.trim().isNotEmpty == true
                      ? item.exceptionLocation!
                      : '异常位置未填写',
                  style: TextStyle(
                    fontSize: AppDimens.sp15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E2A3A),
                  ),
                ),
              ),
              _StatusBadge(
                text: controller.statusText(item.confirmStatus),
                style: controller.statusStyle(item.confirmStatus),
              ),
            ],
          ),
          SizedBox(height: AppDimens.dp10),
          _InfoLine(label: '上报人', value: item.reportUserName ?? '--'),
          _InfoLine(label: '上报时间', value: item.reportTime ?? '--'),
          _InfoLine(label: '异常描述', value: item.exceptionDesc ?? '--'),
          if ((item.locationData ?? '').trim().isNotEmpty)
            _InfoLine(label: '位置经纬度', value: item.locationData!),
          if ((item.remark ?? '').trim().isNotEmpty)
            _InfoLine(label: '备注', value: item.remark!),
          if (item.confirmStatus == 1) ...[
            _InfoLine(label: '确认人', value: item.confirmerName ?? '--'),
            _InfoLine(label: '确认时间', value: item.confirmerTime ?? '--'),
            _InfoLine(label: '是否有效', value: controller.validText(item.isValid)),
          ],
          if ((item.exceptionImage ?? const <String>[]).isNotEmpty) ...[
            SizedBox(height: AppDimens.dp8),
            _ThumbList(photoUrls: item.exceptionImage!),
          ],
          SizedBox(height: AppDimens.dp12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _openDetailPage(context),
                  child: const Text('查看详情'),
                ),
              ),
              if (controller.canConfirm(item)) ...[
                SizedBox(width: AppDimens.dp10),
                Expanded(
                  child: FilledButton(
                    onPressed: () => _showConfirmSheet(context),
                    child: const Text('确认'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openDetailPage(BuildContext context) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (context) => ExceptionConfirmationDetailPage(item: item),
      ),
    );
  }

  Future<void> _showConfirmSheet(BuildContext context) async {
    final remarkController = TextEditingController(text: item.remark ?? '');
    int selectedValid = item.isValid == 2 ? 2 : 1;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (bottomSheetContext) {
        bool isSubmitting = false;

        return StatefulBuilder(
          builder: (context, setModalState) {
            Future<void> submit() async {
              final remark = remarkController.text.trim();
              if (remark.isEmpty) {
                AppToast.showWarning('请输入备注');
                return;
              }
              final id = item.id?.trim() ?? '';
              if (id.isEmpty) {
                AppToast.showWarning('异常记录缺少ID');
                return;
              }

              setModalState(() => isSubmitting = true);
              final success = await controller.confirmItem(
                id: id,
                isValid: selectedValid,
                remark: remark,
              );
              if (!context.mounted) return;
              setModalState(() => isSubmitting = false);
              if (success) {
                Navigator.of(bottomSheetContext).pop();
              }
            }

            return SafeArea(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppDimens.dp16,
                    AppDimens.dp12,
                    AppDimens.dp16,
                    AppDimens.dp16 + MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: AppDimens.dp40,
                          height: AppDimens.dp4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9E1EC),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                      SizedBox(height: AppDimens.dp14),
                      Text(
                        '确认异常',
                        style: TextStyle(
                          fontSize: AppDimens.sp18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E2A3A),
                        ),
                      ),
                      SizedBox(height: AppDimens.dp6),
                      Text(
                        '请先判断该异常是否有效，再填写本次确认说明。',
                        style: TextStyle(
                          fontSize: AppDimens.sp12,
                          color: const Color(0xFF6B7A8C),
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: AppDimens.dp14),
                      Container(
                        padding: EdgeInsets.all(AppDimens.dp12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7FAFE),
                          borderRadius: BorderRadius.circular(AppDimens.dp14),
                          border: Border.all(color: const Color(0xFFE4EBF3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.report_problem_outlined,
                              color: Color(0xFF3D7FFF),
                            ),
                            SizedBox(width: AppDimens.dp8),
                            Expanded(
                              child: Text(
                                item.exceptionLocation?.trim().isNotEmpty ==
                                        true
                                    ? item.exceptionLocation!
                                    : '异常位置未填写',
                                style: TextStyle(
                                  fontSize: AppDimens.sp13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF243447),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppDimens.dp14),
                      Text(
                        '是否有效',
                        style: TextStyle(
                          fontSize: AppDimens.sp13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2A3647),
                        ),
                      ),
                      SizedBox(height: AppDimens.dp10),
                      Row(
                        children: [
                          Expanded(
                            child: _ConfirmOptionCard(
                              title: '有效',
                              subtitle: '保留异常并继续处理',
                              selected: selectedValid == 1,
                              icon: Icons.verified_outlined,
                              selectedColor: const Color(0xFF2FA36B),
                              onTap: () =>
                                  setModalState(() => selectedValid = 1),
                            ),
                          ),
                          SizedBox(width: AppDimens.dp10),
                          Expanded(
                            child: _ConfirmOptionCard(
                              title: '无效',
                              subtitle: '误报或无需继续跟进',
                              selected: selectedValid == 2,
                              icon: Icons.block_outlined,
                              selectedColor: const Color(0xFFE07A34),
                              onTap: () =>
                                  setModalState(() => selectedValid = 2),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppDimens.dp14),
                      Text(
                        '备注',
                        style: TextStyle(
                          fontSize: AppDimens.sp13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2A3647),
                        ),
                      ),
                      SizedBox(height: AppDimens.dp8),
                      TextField(
                        controller: remarkController,
                        minLines: 4,
                        maxLines: 6,
                        decoration: InputDecoration(
                          hintText: '请输入确认备注',
                          filled: true,
                          fillColor: const Color(0xFFF8FAFD),
                          contentPadding: EdgeInsets.all(AppDimens.dp12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimens.dp14),
                            borderSide: const BorderSide(
                              color: Color(0xFFD7DFEB),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimens.dp14),
                            borderSide: const BorderSide(
                              color: Color(0xFFD7DFEB),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimens.dp14),
                            borderSide: const BorderSide(
                              color: Color(0xFF1F7BFF),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppDimens.dp16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: isSubmitting
                                  ? null
                                  : () =>
                                        Navigator.of(bottomSheetContext).pop(),
                              style: OutlinedButton.styleFrom(
                                minimumSize: Size.fromHeight(AppDimens.dp44),
                                side: const BorderSide(
                                  color: Color(0xFFD2DBE8),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppDimens.dp12,
                                  ),
                                ),
                              ),
                              child: const Text('取消'),
                            ),
                          ),
                          SizedBox(width: AppDimens.dp10),
                          Expanded(
                            child: FilledButton(
                              onPressed: isSubmitting ? null : submit,
                              style: FilledButton.styleFrom(
                                minimumSize: Size.fromHeight(AppDimens.dp44),
                                backgroundColor: const Color(0xFF1F7BFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppDimens.dp12,
                                  ),
                                ),
                              ),
                              child: Text(isSubmitting ? '提交中...' : '确认提交'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _ThumbList extends StatelessWidget {
  const _ThumbList({required this.photoUrls});

  final List<String> photoUrls;

  @override
  Widget build(BuildContext context) {
    if (photoUrls.isEmpty) {
      return Text(
        '暂无照片',
        style: TextStyle(
          fontSize: AppDimens.sp12,
          color: const Color(0xFF94A3B8),
        ),
      );
    }

    return Wrap(
      spacing: AppDimens.dp8,
      runSpacing: AppDimens.dp8,
      children: photoUrls.map((url) {
        final imageUrl = FileService.getFaceUrl(url);
        return GestureDetector(
          onTap: imageUrl == null
              ? null
              : () => FileService.openFile(imageUrl, title: '现场照片'),
          child: Container(
            width: AppDimens.dp84,
            height: AppDimens.dp64,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F5FA),
              borderRadius: BorderRadius.circular(AppDimens.dp10),
              border: Border.all(color: const Color(0xFFD8E1EC)),
            ),
            child: imageUrl == null
                ? const Icon(Icons.broken_image_outlined)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimens.dp9),
                    child: Image.network(
                      imageUrl,
                      headers: FileService.imageHeaders(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image_outlined),
                    ),
                  ),
          ),
        );
      }).toList(),
    );
  }
}

class _ConfirmOptionCard extends StatelessWidget {
  const _ConfirmOptionCard({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.icon,
    required this.selectedColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final IconData icon;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.all(AppDimens.dp12),
        decoration: BoxDecoration(
          color: selected
              ? selectedColor.withValues(alpha: 0.10)
              : const Color(0xFFF8FAFD),
          borderRadius: BorderRadius.circular(AppDimens.dp14),
          border: Border.all(
            color: selected ? selectedColor : const Color(0xFFD9E1EC),
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: AppDimens.dp28,
                  height: AppDimens.dp28,
                  decoration: BoxDecoration(
                    color: selected
                        ? selectedColor.withValues(alpha: 0.16)
                        : const Color(0xFFEFF3F8),
                    borderRadius: BorderRadius.circular(AppDimens.dp10),
                  ),
                  child: Icon(
                    icon,
                    size: 16,
                    color: selected ? selectedColor : const Color(0xFF7D8A9A),
                  ),
                ),
                const Spacer(),
                Icon(
                  selected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: 18,
                  color: selected ? selectedColor : const Color(0xFFB6C0CC),
                ),
              ],
            ),
            SizedBox(height: AppDimens.dp10),
            Text(
              title,
              style: TextStyle(
                fontSize: AppDimens.sp13,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF243447),
              ),
            ),
            SizedBox(height: AppDimens.dp4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: AppDimens.sp11,
                color: const Color(0xFF6B7A8C),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.text, required this.style});

  final String text;
  final AppCardStatusStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp8,
        vertical: AppDimens.dp3,
      ),
      decoration: BoxDecoration(
        color: style.backgroundColor,
        border: Border.all(color: style.borderColor),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: style.textColor,
          fontSize: AppDimens.sp12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimens.dp6),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: AppDimens.sp12,
            color: const Color(0xFF475569),
            height: 1.5,
          ),
          children: [
            TextSpan(
              text: '$label：',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: value.trim().isEmpty ? '--' : value),
          ],
        ),
      ),
    );
  }
}
