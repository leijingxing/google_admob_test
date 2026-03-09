import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../core/components/app_standard_card.dart';
import '../../../../../../../core/components/select/custom_picker_photo.dart';
import '../../../../../../../core/constants/dimens.dart';
import '../park_inspection_detail_controller.dart';
import 'park_inspection_check_rule_controller.dart';

class ParkInspectionCheckRuleView
    extends GetView<ParkInspectionCheckRuleController> {
  const ParkInspectionCheckRuleView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParkInspectionCheckRuleController>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: const Text('细则检查')),
          backgroundColor: const Color(0xFFF4F7FB),
          body: logic.loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                  padding: EdgeInsets.all(AppDimens.dp12),
                  itemCount: logic.drafts.length,
                  separatorBuilder: (_, _) => SizedBox(height: AppDimens.dp10),
                  itemBuilder: (context, index) {
                    final item = logic.drafts[index];
                    return _RuleDraftCard(
                      item: item,
                      checkMethodText: logic.checkMethodText(item.checkMethod),
                      onChanged: (next) => logic.updateDraft(index, next),
                    );
                  },
                ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppDimens.dp12,
                AppDimens.dp8,
                AppDimens.dp12,
                AppDimens.dp8,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: logic.submitting ? null : Get.back,
                      child: const Text('取消'),
                    ),
                  ),
                  SizedBox(width: AppDimens.dp10),
                  Expanded(
                    child: FilledButton(
                      onPressed: logic.submitting ? null : logic.submit,
                      child: logic.submitting
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('批量提交'),
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

class _RuleDraftCard extends StatelessWidget {
  const _RuleDraftCard({
    required this.item,
    required this.checkMethodText,
    required this.onChanged,
  });

  final ParkInspectionRuleDraft item;
  final String checkMethodText;
  final ValueChanged<ParkInspectionRuleDraft> onChanged;

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
                  item.ruleName.isEmpty ? '--' : item.ruleName,
                  style: TextStyle(
                    color: const Color(0xFF223146),
                    fontSize: AppDimens.sp14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _StatusBadge(
                text: item.checked ? '已检查' : '待检查',
                color: item.checked
                    ? const Color(0xFF22A06B)
                    : const Color(0xFF8A97A8),
              ),
            ],
          ),
          SizedBox(height: AppDimens.dp8),
          _InfoLine(
            label: '检查标准',
            value: item.checkStandard.isEmpty ? '--' : item.checkStandard,
          ),
          _InfoLine(label: '检查方式', value: checkMethodText),
          SizedBox(height: AppDimens.dp6),
          DropdownButtonFormField<String>(
            initialValue: item.resultStatus.isEmpty ? null : item.resultStatus,
            items: const [
              DropdownMenuItem(value: 'PASS', child: Text('通过')),
              DropdownMenuItem(value: 'FAIL', child: Text('不通过')),
              DropdownMenuItem(value: 'UNINVOLVED', child: Text('不涉及')),
            ],
            onChanged: item.checked
                ? null
                : (value) =>
                      onChanged(item.copyWith(resultStatus: value ?? '')),
            decoration: const InputDecoration(
              labelText: '检查结果',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: AppDimens.dp10),
          TextFormField(
            initialValue: item.remark,
            onChanged: item.checked
                ? null
                : (value) => onChanged(item.copyWith(remark: value)),
            minLines: 2,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: '备注',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: AppDimens.dp10),
          if (item.checked)
            _AttachmentText(ids: item.attachments)
          else if (item.resultStatus == 'FAIL')
            CustomPickerPhoto(
              title: '附件',
              imagesList: item.attachments,
              callback: (value) => onChanged(item.copyWith(attachments: value)),
            ),
        ],
      ),
    );
  }
}

class _AttachmentText extends StatelessWidget {
  const _AttachmentText({required this.ids});

  final List<String> ids;

  @override
  Widget build(BuildContext context) {
    return Text(ids.isEmpty ? '--' : '已上传${ids.length}张附件');
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp12,
        vertical: AppDimens.dp6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: AppDimens.sp11,
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
