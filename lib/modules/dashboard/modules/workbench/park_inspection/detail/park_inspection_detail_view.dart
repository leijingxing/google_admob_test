import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/components/app_standard_card.dart';
import '../../../../../../core/constants/dimens.dart';
import '../../../../../../core/utils/file_service.dart';
import '../../../../../../data/models/workbench/inspection_abnormal_item_model.dart';
import '../../../../../../data/models/workbench/park_inspection_task_record_model.dart';
import '../park_inspection_controller.dart';
import 'cancel/park_inspection_cancel_binding.dart';
import 'cancel/park_inspection_cancel_view.dart';
import 'check_rule/park_inspection_check_rule_binding.dart';
import 'check_rule/park_inspection_check_rule_view.dart';
import 'check_in/park_inspection_check_in_binding.dart';
import 'check_in/park_inspection_check_in_view.dart';
import 'complete/park_inspection_complete_binding.dart';
import 'complete/park_inspection_complete_view.dart';
import 'park_inspection_detail_controller.dart';
import 'record_detail/park_inspection_record_detail_binding.dart';
import 'record_detail/park_inspection_record_detail_view.dart';
import 'report_abnormal/park_inspection_report_abnormal_binding.dart';
import 'report_abnormal/park_inspection_report_abnormal_view.dart';

class ParkInspectionDetailView extends GetView<ParkInspectionDetailController> {
  const ParkInspectionDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParkInspectionDetailController>(
      builder: (logic) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            Get.back<bool>(result: logic.didChange);
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('巡检详情'),
              leading: IconButton(
                onPressed: () => Get.back<bool>(result: logic.didChange),
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
            ),
            backgroundColor: const Color(0xFFF4F7FB),
            body: logic.loading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      AppDimens.dp12,
                      AppDimens.dp10,
                      AppDimens.dp12,
                      AppDimens.dp24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _OverviewCard(controller: logic),
                        SizedBox(height: AppDimens.dp12),
                        _TaskInfoCard(controller: logic),
                        SizedBox(height: AppDimens.dp12),
                        if (logic.canOperate) ...[
                          _ActionSection(controller: logic),
                          SizedBox(height: AppDimens.dp12),
                        ],
                        _SectionHeader(
                          title: '巡检记录',
                          subtitle: '${logic.records.length}条',
                        ),
                        SizedBox(height: AppDimens.dp8),
                        if (logic.records.isEmpty)
                          AppStandardCard(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: AppDimens.dp18,
                              ),
                              child: const Center(child: Text('暂无巡检记录')),
                            ),
                          )
                        else
                          ...logic.records.map((record) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: AppDimens.dp10),
                              child: _RecordCard(
                                record: record,
                                controller: logic,
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.controller});

  final ParkInspectionDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppDimens.dp16,
        AppDimens.dp16,
        AppDimens.dp16,
        AppDimens.dp14,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFF2F7FF)],
        ),
        borderRadius: BorderRadius.circular(AppDimens.dp18),
        border: Border.all(color: const Color(0xFFD9E6FB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.item.planName ?? '--',
                      style: TextStyle(
                        color: const Color(0xFF223146),
                        fontSize: AppDimens.sp18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: AppDimens.dp6),
                    Text(
                      '任务编码：${controller.item.taskCode ?? '--'}',
                      style: TextStyle(
                        color: const Color(0xFF6B7A90),
                        fontSize: AppDimens.sp12,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusBadge(
                text: controller.taskStatusText(controller.item.taskStatus),
                color: _taskStatusColor(controller.item.taskStatus),
              ),
            ],
          ),
          SizedBox(height: AppDimens.dp14),
          Container(height: 1, color: const Color(0xFFDCE6F5)),
          SizedBox(height: AppDimens.dp14),
          Row(
            children: [
              Expanded(
                child: _OverviewMetric(
                  label: '巡检类型',
                  value: controller.typeText(controller.item.typeCode),
                ),
              ),
              SizedBox(width: AppDimens.dp10),
              Expanded(
                child: _OverviewMetric(
                  label: '任务日期',
                  value: controller.item.taskDate ?? '--',
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimens.dp10),
          Row(
            children: [
              Expanded(
                child: _OverviewMetric(
                  label: '执行人',
                  value: controller.item.executorName ?? '--',
                ),
              ),
              SizedBox(width: AppDimens.dp10),
              Expanded(
                child: _OverviewMetric(
                  label: '结果状态',
                  value: controller.resultStatusText(
                    controller.item.resultStatus,
                  ),
                  highlight:
                      (controller.item.resultStatus ?? '').trim() == 'ABNORMAL',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _taskStatusColor(String? status) {
    switch ((status ?? '').trim()) {
      case ParkInspectionTaskStatus.pending:
        return const Color(0xFF4A84F5);
      case ParkInspectionTaskStatus.inProgress:
        return const Color(0xFFEAA53A);
      case ParkInspectionTaskStatus.completed:
        return const Color(0xFF22A06B);
      case ParkInspectionTaskStatus.cancelled:
        return const Color(0xFF8A97A8);
      default:
        return const Color(0xFF7B8798);
    }
  }
}

class _TaskInfoCard extends StatelessWidget {
  const _TaskInfoCard({required this.controller});

  final ParkInspectionDetailController controller;

  @override
  Widget build(BuildContext context) {
    return AppStandardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(title: '基础信息', subtitle: '任务概要', compact: true),
          SizedBox(height: AppDimens.dp12),
          _InfoLine(label: '计划名称', value: controller.item.planName ?? '--'),
          _InfoLine(label: '任务编码', value: controller.item.taskCode ?? '--'),
          _InfoLine(
            label: '派发方式',
            value: _dispatchText(controller.item.dispatchType),
          ),
          _InfoLine(
            label: '任务关联人员',
            value: controller.item.executorNames ?? '--',
          ),
          _InfoLine(label: '总点位', value: '${controller.item.totalPoints}'),
          _InfoLine(label: '已完成', value: '${controller.item.completedPoints}'),
          _InfoLine(label: '异常数', value: '${controller.item.abnormalCount}'),
          _InfoLine(label: '备注', value: controller.item.remark ?? '--'),
        ],
      ),
    );
  }

  String _dispatchText(String? value) {
    switch ((value ?? '').trim()) {
      case 'AUTO':
        return '自动派发';
      case 'MANUAL_WEB':
        return '手动派发';
      case 'MANUAL_APP':
        return 'APP派发';
      default:
        return '--';
    }
  }
}

class _ActionSection extends StatelessWidget {
  const _ActionSection({required this.controller});

  final ParkInspectionDetailController controller;

  @override
  Widget build(BuildContext context) {
    return AppStandardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(title: '任务操作', subtitle: '执行动作', compact: true),
          SizedBox(height: AppDimens.dp12),
          Wrap(
            spacing: AppDimens.dp10,
            runSpacing: AppDimens.dp10,
            children: [
              if (controller.taskStatus == ParkInspectionTaskStatus.pending)
                FilledButton.icon(
                  onPressed: controller.startLoading
                      ? null
                      : () async {
                          final success = await controller.startTask();
                          if (success) Get.forceAppUpdate();
                        },
                  icon: controller.startLoading
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.play_arrow_rounded),
                  label: const Text('开始巡检'),
                ),
              if (controller.taskStatus == ParkInspectionTaskStatus.inProgress)
                FilledButton.icon(
                  onPressed: () async {
                    final result = await Get.to<bool>(
                      () => const ParkInspectionCheckInView(),
                      binding: ParkInspectionCheckInBinding(),
                    );
                    if (result == true) {
                      Get.forceAppUpdate();
                    }
                  },
                  icon: const Icon(Icons.place_outlined),
                  label: const Text('点位打卡'),
                ),
              if (controller.taskStatus == ParkInspectionTaskStatus.inProgress)
                FilledButton.icon(
                  onPressed: controller.completeLoading
                      ? null
                      : () async {
                          final result = await Get.to<bool>(
                            () => const ParkInspectionCompleteView(),
                            binding: ParkInspectionCompleteBinding(),
                          );
                          if (result == true) {
                            Get.forceAppUpdate();
                          }
                        },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF22A06B),
                  ),
                  icon: const Icon(Icons.task_alt_outlined),
                  label: const Text('完成巡检'),
                ),
              if (controller.taskStatus == ParkInspectionTaskStatus.pending)
                OutlinedButton.icon(
                  onPressed: () async {
                    final result = await Get.to<bool>(
                      () => const ParkInspectionCancelView(),
                      binding: ParkInspectionCancelBinding(),
                    );
                    if (result == true) {
                      Get.forceAppUpdate();
                    }
                  },
                  icon: const Icon(Icons.close_rounded),
                  label: const Text('取消任务'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  const _RecordCard({required this.record, required this.controller});

  final ParkInspectionTaskRecordModel record;
  final ParkInspectionDetailController controller;

  @override
  Widget build(BuildContext context) {
    return AppStandardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  record.pointName ?? '--',
                  style: TextStyle(
                    color: const Color(0xFF223146),
                    fontSize: AppDimens.sp14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _StatusBadge(
                text: controller.resultStatusText(record.resultStatus),
                color: (record.resultStatus ?? '').trim() == 'ABNORMAL'
                    ? const Color(0xFFE06A4B)
                    : const Color(0xFF22A06B),
                soft: true,
              ),
            ],
          ),
          SizedBox(height: AppDimens.dp10),
          _InfoLine(label: '执行人', value: record.executorName ?? '--'),
          _InfoLine(label: '打卡时间', value: record.checkTime ?? '--'),
          _InfoLine(label: '打卡位置', value: record.position ?? '--'),
          _InfoLine(label: '备注', value: record.remark ?? '--'),
          SizedBox(height: AppDimens.dp6),
          Wrap(
            spacing: AppDimens.dp8,
            runSpacing: AppDimens.dp8,
            children: [
              OutlinedButton(
                onPressed: () {
                  Get.to<void>(
                    () => const ParkInspectionRecordDetailView(),
                    binding: ParkInspectionRecordDetailBinding(),
                    arguments: record,
                  );
                },
                child: const Text('明细'),
              ),
              if (controller.taskStatus == ParkInspectionTaskStatus.inProgress)
                FilledButton(
                  onPressed: () {
                    Get.to<void>(
                      () => const ParkInspectionCheckRuleView(),
                      binding: ParkInspectionCheckRuleBinding(),
                      arguments: record,
                    );
                  },
                  child: const Text('检查细则'),
                ),
              if (controller.taskStatus == ParkInspectionTaskStatus.inProgress)
                FilledButton(
                  onPressed: () {
                    Get.to<void>(
                      () => const ParkInspectionReportAbnormalView(),
                      binding: ParkInspectionReportAbnormalBinding(),
                      arguments: record,
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFE06A4B),
                  ),
                  child: const Text('上报异常'),
                ),
              if ((record.resultStatus ?? '').trim() == 'ABNORMAL')
                TextButton(
                  onPressed: () =>
                      _showAbnormalSheet(context, controller, record),
                  child: const Text('异常记录'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showAbnormalSheet(
    BuildContext context,
    ParkInspectionDetailController controller,
    ParkInspectionTaskRecordModel record,
  ) async {
    final abnormals = await controller.loadAbnormals(
      recordId: (record.id ?? '').trim(),
    );
    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF4F7FB),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppDimens.dp16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '异常记录',
                  style: TextStyle(
                    color: const Color(0xFF223146),
                    fontSize: AppDimens.sp16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppDimens.dp12),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: abnormals.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: AppDimens.dp8),
                    itemBuilder: (context, index) {
                      return _AbnormalTile(
                        item: abnormals[index],
                        controller: controller,
                      );
                    },
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

class _AbnormalTile extends StatelessWidget {
  const _AbnormalTile({required this.item, required this.controller});

  final InspectionAbnormalItemModel item;
  final ParkInspectionDetailController controller;

  @override
  Widget build(BuildContext context) {
    return AppStandardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.ruleNameById(item.ruleId),
            style: TextStyle(
              color: const Color(0xFF223146),
              fontSize: AppDimens.sp14,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppDimens.dp8),
          _InfoLine(label: '上报人', value: item.reporterName ?? '--'),
          _InfoLine(label: '异常描述', value: item.abnormalDesc ?? '--'),
          _InfoLine(
            label: '是否紧急',
            value: (item.isUrgent ?? '').trim() == '1' ? '是' : '否',
          ),
          _InfoLine(
            label: '异常状态',
            value: _abnormalStatusText(item.abnormalStatus),
          ),
          _AttachmentPreview(ids: item.photoUrls ?? const <String>[]),
        ],
      ),
    );
  }

  String _abnormalStatusText(String? value) {
    switch ((value ?? '').trim()) {
      case 'PENDING_CONFIRM':
        return '待确认';
      case 'PENDING_RECTIFY':
        return '待整改';
      case 'RECTIFYING':
        return '整改中';
      case 'PENDING_VERIFY':
        return '待核查';
      case 'COMPLETED':
        return '已完成';
      case 'REASSIGN':
        return '待重新指派';
      default:
        return '--';
    }
  }
}

class _AttachmentPreview extends StatelessWidget {
  const _AttachmentPreview({required this.ids});

  final List<String> ids;

  @override
  Widget build(BuildContext context) {
    if (ids.isEmpty) {
      return const Text('--');
    }
    return Wrap(
      spacing: AppDimens.dp8,
      runSpacing: AppDimens.dp8,
      children: ids.map((id) {
        final imageUrl = FileService.getFaceUrl(id);
        return InkWell(
          onTap: imageUrl == null
              ? null
              : () => FileService.openFile(imageUrl, title: '附件预览'),
          child: Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FB),
              borderRadius: BorderRadius.circular(AppDimens.dp10),
              border: Border.all(color: const Color(0xFFE2E8F2)),
            ),
            child: imageUrl == null
                ? const Icon(Icons.image_not_supported_outlined)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimens.dp10),
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

class _OverviewMetric extends StatelessWidget {
  const _OverviewMetric({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp12,
        vertical: AppDimens.dp10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFF),
        borderRadius: BorderRadius.circular(AppDimens.dp12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF8090A6),
              fontSize: AppDimens.sp11,
            ),
          ),
          SizedBox(height: AppDimens.dp6),
          Text(
            value,
            style: TextStyle(
              color: highlight
                  ? const Color(0xFFE06A4B)
                  : const Color(0xFF1D2B3A),
              fontSize: AppDimens.sp13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.text,
    required this.color,
    this.soft = false,
  });

  final String text;
  final Color color;
  final bool soft;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp12,
        vertical: AppDimens.dp6,
      ),
      decoration: BoxDecoration(
        color: soft ? color.withValues(alpha: 0.12) : color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: soft ? color : Colors.white,
          fontSize: AppDimens.sp11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    this.compact = false,
  });

  final String title;
  final String subtitle;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: compact ? AppDimens.dp16 : AppDimens.dp18,
          decoration: BoxDecoration(
            color: const Color(0xFF4A84F5),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        SizedBox(width: AppDimens.dp8),
        Text(
          title,
          style: TextStyle(
            color: const Color(0xFF223146),
            fontSize: compact ? AppDimens.sp14 : AppDimens.dp18,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(width: AppDimens.dp8),
        Text(
          subtitle,
          style: TextStyle(
            color: const Color(0xFF7B8798),
            fontSize: AppDimens.sp12,
          ),
        ),
      ],
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
      padding: EdgeInsets.only(bottom: AppDimens.dp10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppDimens.dp80,
            child: Text(
              '$label：',
              style: TextStyle(
                color: const Color(0xFF7B8798),
                fontSize: AppDimens.sp12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: const Color(0xFF223146),
                fontSize: AppDimens.sp12,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
