import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/components/app_standard_card.dart';
import '../../../../../../core/constants/dimens.dart';
import '../../../../../../data/models/workbench/park_inspection_task_record_model.dart';
import '../park_inspection_controller.dart';
import 'abnormal_record/park_inspection_abnormal_record_binding.dart';
import 'abnormal_record/park_inspection_abnormal_record_view.dart';
import 'cancel/park_inspection_cancel_binding.dart';
import 'cancel/park_inspection_cancel_view.dart';
import 'check_in/park_inspection_check_in_binding.dart';
import 'check_in/park_inspection_check_in_view.dart';
import 'check_rule/park_inspection_check_rule_binding.dart';
import 'check_rule/park_inspection_check_rule_view.dart';
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
                    padding: EdgeInsets.fromLTRB(AppDimens.dp12, AppDimens.dp10, AppDimens.dp12, AppDimens.dp24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _OverviewCard(controller: logic),
                        SizedBox(height: AppDimens.dp12),
                        _TaskInfoCard(controller: logic),
                        if (logic.canOperate) ...[SizedBox(height: AppDimens.dp12), _ActionSection(controller: logic)],
                        SizedBox(height: AppDimens.dp12),
                        _RecordSection(controller: logic),
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
    return AppStandardCard(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(AppDimens.dp14, AppDimens.dp14, AppDimens.dp14, AppDimens.dp14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFF2F8FF), Color(0xFFFAFCFF)]),
          borderRadius: BorderRadius.circular(AppDimens.dp12),
          border: Border.all(color: const Color(0xFFD8E6FF)),
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
                        style: TextStyle(color: const Color(0xFF223146), fontSize: AppDimens.sp18, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: AppDimens.dp6),
                      Text(
                        '任务编码：${controller.item.taskCode ?? '--'}',
                        style: TextStyle(color: const Color(0xFF6B7A90), fontSize: AppDimens.sp12),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(text: controller.taskStatusText(controller.item.taskStatus), color: _taskStatusColor(controller.item.taskStatus)),
              ],
            ),
            SizedBox(height: AppDimens.dp14),
            Container(height: 1, color: const Color(0xFFDCE6F5)),
            SizedBox(height: AppDimens.dp14),
            Row(
              children: [
                Expanded(
                  child: _OverviewMetric(label: '巡检类型', value: controller.typeText(controller.item.typeCode), icon: Icons.category_outlined),
                ),
                SizedBox(width: AppDimens.dp10),
                Expanded(
                  child: _OverviewMetric(label: '任务日期', value: controller.item.taskDate ?? '--', icon: Icons.event_note_rounded),
                ),
              ],
            ),
            SizedBox(height: AppDimens.dp10),
            Row(
              children: [
                Expanded(
                  child: _OverviewMetric(label: '执行人', value: controller.item.executorName ?? '--', icon: Icons.person_outline_rounded),
                ),
                SizedBox(width: AppDimens.dp10),
                Expanded(
                  child: _OverviewMetric(
                    label: '结果状态',
                    value: controller.resultStatusText(controller.item.resultStatus),
                    icon: Icons.verified_outlined,
                    highlight: (controller.item.resultStatus ?? '').trim() == 'ABNORMAL',
                  ),
                ),
              ],
            ),
          ],
        ),
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
          _InfoLine(label: '派发方式', value: _dispatchText(controller.item.dispatchType)),
          _InfoLine(label: '任务关联人员', value: controller.item.executorNames ?? '--'),
          Row(
            children: [
              Expanded(
                child: _StatBox(label: '总点位', value: '${controller.item.totalPoints}'),
              ),
              SizedBox(width: AppDimens.dp8),
              Expanded(
                child: _StatBox(label: '已完成', value: '${controller.item.completedPoints}'),
              ),
              SizedBox(width: AppDimens.dp8),
              Expanded(
                child: _StatBox(label: '异常数', value: '${controller.item.abnormalCount}', highlight: controller.item.abnormalCount > 0),
              ),
            ],
          ),
          SizedBox(height: AppDimens.dp10),
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
                _ActionButton(
                  label: '开始巡检',
                  icon: Icons.play_arrow_rounded,
                  color: const Color(0xFF3A78F2),
                  loading: controller.startLoading,
                  onPressed: () async {
                    final success = await controller.startTask();
                    if (success) Get.forceAppUpdate();
                  },
                ),
              if (controller.taskStatus == ParkInspectionTaskStatus.inProgress)
                _ActionButton(
                  label: '点位打卡',
                  icon: Icons.place_outlined,
                  color: const Color(0xFF3A78F2),
                  onPressed: () async {
                    final result = await Get.to<bool>(() => const ParkInspectionCheckInView(), binding: ParkInspectionCheckInBinding());
                    if (result == true) {
                      Get.forceAppUpdate();
                    }
                  },
                ),
              if (controller.taskStatus == ParkInspectionTaskStatus.inProgress)
                _ActionButton(
                  label: '完成巡检',
                  icon: Icons.task_alt_outlined,
                  color: const Color(0xFF22A06B),
                  loading: controller.completeLoading,
                  onPressed: () async {
                    final result = await Get.to<bool>(() => const ParkInspectionCompleteView(), binding: ParkInspectionCompleteBinding());
                    if (result == true) {
                      Get.forceAppUpdate();
                    }
                  },
                ),
              if (controller.taskStatus == ParkInspectionTaskStatus.pending)
                _ActionOutlineButton(
                  label: '取消任务',
                  icon: Icons.close_rounded,
                  color: const Color(0xFF8A97A8),
                  onPressed: () async {
                    final result = await Get.to<bool>(() => const ParkInspectionCancelView(), binding: ParkInspectionCancelBinding());
                    if (result == true) {
                      Get.forceAppUpdate();
                    }
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecordSection extends StatelessWidget {
  const _RecordSection({required this.controller});

  final ParkInspectionDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: '巡检记录', subtitle: '${controller.records.length}条'),
        SizedBox(height: AppDimens.dp8),
        if (controller.records.isEmpty)
          AppStandardCard(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppDimens.dp24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: AppDimens.dp54,
                    height: AppDimens.dp54,
                    decoration: BoxDecoration(color: const Color(0xFFEFF4FB), borderRadius: BorderRadius.circular(AppDimens.dp18)),
                    child: const Icon(Icons.inbox_outlined, size: 28, color: Color(0xFF8A97A8)),
                  ),
                  SizedBox(height: AppDimens.dp12),
                  const Text('暂无巡检记录'),
                ],
              ),
            ),
          )
        else
          ...controller.records.map((record) {
            return Padding(
              padding: EdgeInsets.only(bottom: AppDimens.dp10),
              child: _RecordCard(record: record, controller: controller),
            );
          }),
      ],
    );
  }
}

class _RecordCard extends StatelessWidget {
  const _RecordCard({required this.record, required this.controller});

  final ParkInspectionTaskRecordModel record;
  final ParkInspectionDetailController controller;

  @override
  Widget build(BuildContext context) {
    final isAbnormal = (record.resultStatus ?? '').trim() == 'ABNORMAL';
    return AppStandardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  record.pointName ?? '--',
                  style: TextStyle(color: const Color(0xFF223146), fontSize: AppDimens.sp14, fontWeight: FontWeight.w700, height: 1.4),
                ),
              ),
              SizedBox(width: AppDimens.dp10),
              _StatusBadge(text: controller.resultStatusText(record.resultStatus), color: isAbnormal ? const Color(0xFFE06A4B) : const Color(0xFF22A06B), soft: true),
            ],
          ),
          SizedBox(height: AppDimens.dp12),
          const _SectionHeader(title: '记录信息', subtitle: '执行详情', compact: true),
          SizedBox(height: AppDimens.dp10),
          _InfoLine(label: '执行人', value: record.executorName ?? '--'),
          _InfoLine(label: '打卡时间', value: record.checkTime ?? '--'),
          _InfoLine(label: '打卡位置', value: record.position ?? '--'),
          _InfoLine(label: '备注', value: record.remark ?? '--'),
          SizedBox(height: AppDimens.dp8),
          Wrap(
            spacing: AppDimens.dp8,
            runSpacing: AppDimens.dp8,
            children: [
              _ActionOutlineButton(
                label: '明细',
                icon: Icons.notes_rounded,
                color: const Color(0xFF5C6B7D),
                onPressed: () {
                  Get.to<void>(() => const ParkInspectionRecordDetailView(), binding: ParkInspectionRecordDetailBinding(), arguments: record);
                },
              ),
              if (controller.taskStatus == ParkInspectionTaskStatus.inProgress)
                _ActionButton(
                  label: '检查细则',
                  icon: Icons.fact_check_outlined,
                  color: const Color(0xFF3A78F2),
                  onPressed: () {
                    Get.to<void>(() => const ParkInspectionCheckRuleView(), binding: ParkInspectionCheckRuleBinding(), arguments: record);
                  },
                ),
              if (controller.taskStatus == ParkInspectionTaskStatus.inProgress)
                _ActionButton(
                  label: '上报异常',
                  icon: Icons.report_problem_outlined,
                  color: const Color(0xFFE06A4B),
                  onPressed: () {
                    Get.to<void>(() => const ParkInspectionReportAbnormalView(), binding: ParkInspectionReportAbnormalBinding(), arguments: record);
                  },
                ),
              if (isAbnormal)
                _ActionOutlineButton(
                  label: '异常记录',
                  icon: Icons.warning_amber_rounded,
                  color: const Color(0xFFE06A4B),
                  onPressed: () {
                    Get.to<void>(() => const ParkInspectionAbnormalRecordView(), binding: ParkInspectionAbnormalRecordBinding(), arguments: record);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverviewMetric extends StatelessWidget {
  const _OverviewMetric({required this.label, required this.value, required this.icon, this.highlight = false});

  final String label;
  final String value;
  final IconData icon;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.dp12, vertical: AppDimens.dp10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.dp12),
        border: Border.all(color: const Color(0xFFDCE6F5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: const Color(0xFF8090A6)),
              SizedBox(width: AppDimens.dp6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(color: const Color(0xFF8090A6), fontSize: AppDimens.sp11),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimens.dp6),
          Text(
            value,
            style: TextStyle(color: highlight ? const Color(0xFFE06A4B) : const Color(0xFF1D2B3A), fontSize: AppDimens.sp13, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value, this.highlight = false});

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.dp10, vertical: AppDimens.dp10),
      decoration: BoxDecoration(color: const Color(0xFFF7FAFF), borderRadius: BorderRadius.circular(AppDimens.dp12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: const Color(0xFF8090A6), fontSize: AppDimens.sp11),
          ),
          SizedBox(height: AppDimens.dp6),
          Text(
            value,
            style: TextStyle(color: highlight ? const Color(0xFFE06A4B) : const Color(0xFF1D2B3A), fontSize: AppDimens.sp13, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.icon, required this.color, required this.onPressed, this.loading = false});

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: AppDimens.dp14, vertical: AppDimens.dp12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.dp10)),
        elevation: 0,
      ),
      onPressed: loading ? null : onPressed,
      icon: loading ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Icon(icon),
      label: Text(label),
    );
  }
}

class _ActionOutlineButton extends StatelessWidget {
  const _ActionOutlineButton({required this.label, required this.icon, required this.color, required this.onPressed});

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color.withValues(alpha: 0.26)),
        foregroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: AppDimens.dp14, vertical: AppDimens.dp12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.dp10)),
      ),
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.text, required this.color, this.soft = false});

  final String text;
  final Color color;
  final bool soft;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.dp12, vertical: AppDimens.dp6),
      decoration: BoxDecoration(color: soft ? color.withValues(alpha: 0.12) : color, borderRadius: BorderRadius.circular(999)),
      child: Text(
        text,
        style: TextStyle(color: soft ? color : Colors.white, fontSize: AppDimens.sp11, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle, this.compact = false});

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
          decoration: BoxDecoration(color: const Color(0xFF4A84F5), borderRadius: BorderRadius.circular(999)),
        ),
        SizedBox(width: AppDimens.dp8),
        Text(
          title,
          style: TextStyle(color: const Color(0xFF223146), fontSize: compact ? AppDimens.sp14 : AppDimens.dp18, fontWeight: FontWeight.w700),
        ),
        SizedBox(width: AppDimens.dp8),
        Text(
          subtitle,
          style: TextStyle(color: const Color(0xFF7B8798), fontSize: AppDimens.sp12),
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
              style: TextStyle(color: const Color(0xFF7B8798), fontSize: AppDimens.sp12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: const Color(0xFF223146), fontSize: AppDimens.sp12, fontWeight: FontWeight.w600, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
