import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../core/components/app_form_styles.dart';
import '../../../../../../../core/components/app_standard_card.dart';
import '../../../../../../../core/components/select/custom_picker_photo.dart';
import '../../../../../../../core/constants/dimens.dart';
import '../../../../../../../core/utils/file_service.dart';
import '../park_inspection_detail_controller.dart';
import 'park_inspection_check_rule_controller.dart';

class ParkInspectionCheckRuleView extends GetView<ParkInspectionCheckRuleController> {
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
              : Column(
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(AppDimens.dp12, AppDimens.dp12, AppDimens.dp12, 0), child: const _SummaryHeader()),
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.all(AppDimens.dp12),
                        itemCount: logic.drafts.length,
                        separatorBuilder: (_, index) => SizedBox(height: AppDimens.dp12),
                        itemBuilder: (context, index) {
                          final item = logic.drafts[index];
                          return _RuleDraftCard(item: item, checkMethodText: logic.checkMethodText(item.checkMethod), onChanged: (next) => logic.updateDraft(index, next));
                        },
                      ),
                    ),
                  ],
                ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Container(
              padding: EdgeInsets.fromLTRB(AppDimens.dp12, AppDimens.dp10, AppDimens.dp12, AppDimens.dp10),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE7EDF5))),
                boxShadow: [BoxShadow(color: Color(0x0A0F172A), blurRadius: 14, offset: Offset(0, -2))],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size.fromHeight(AppDimens.dp44),
                        side: const BorderSide(color: Color(0xFFD7DFEB)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.dp10)),
                        foregroundColor: const Color(0xFF5C6B7D),
                      ),
                      onPressed: logic.submitting ? null : Get.back,
                      child: const Text('取消'),
                    ),
                  ),
                  SizedBox(width: AppDimens.dp10),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: Size.fromHeight(AppDimens.dp44),
                        backgroundColor: const Color(0xFF3A78F2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.dp10)),
                        elevation: 0,
                      ),
                      onPressed: logic.submitting ? null : logic.submit,
                      child: logic.submitting ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('批量提交'),
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

class _SummaryHeader extends StatelessWidget {
  const _SummaryHeader();

  @override
  Widget build(BuildContext context) {
    return AppStandardCard(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppDimens.dp12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFF2F8FF), Color(0xFFFAFCFF)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(AppDimens.dp10),
          border: Border.all(color: const Color(0xFFD8E6FF)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: AppDimens.dp30,
                  height: AppDimens.dp30,
                  decoration: BoxDecoration(color: const Color(0xFFE8F1FF), borderRadius: BorderRadius.circular(AppDimens.dp9)),
                  child: const Icon(Icons.fact_check_outlined, size: 18, color: Color(0xFF3A78F2)),
                ),
                SizedBox(width: AppDimens.dp10),
                Expanded(
                  child: Text(
                    '细则检查说明',
                    style: TextStyle(color: const Color(0xFF243447), fontSize: AppDimens.sp13, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppDimens.dp8),
            Text(
              '请为未检查项补充检查结果。若检查结果为不通过，请上传现场附件，便于后续核查与追溯。',
              style: TextStyle(color: const Color(0xFF6C7A8C), fontSize: AppDimens.sp12, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}

class _RuleDraftCard extends StatelessWidget {
  const _RuleDraftCard({required this.item, required this.checkMethodText, required this.onChanged});

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.ruleName.isEmpty ? '--' : item.ruleName,
                  style: TextStyle(color: const Color(0xFF223146), fontSize: AppDimens.sp14, fontWeight: FontWeight.w700, height: 1.4),
                ),
              ),
              SizedBox(width: AppDimens.dp10),
              _StatusBadge(text: item.checked ? '已检查' : '待检查', color: item.checked ? const Color(0xFF22A06B) : const Color(0xFF8A97A8)),
            ],
          ),
          SizedBox(height: AppDimens.dp12),
          _SectionTitle(text: '检查信息'),
          SizedBox(height: AppDimens.dp10),
          _InfoLine(label: '检查标准', value: item.checkStandard.isEmpty ? '--' : item.checkStandard),
          _InfoLine(label: '检查方式', value: checkMethodText),
          _FieldLabel(text: '检查结果', required: !item.checked),
          SizedBox(height: AppDimens.dp8),
          DropdownButtonFormField<String>(
            initialValue: item.resultStatus.isEmpty ? null : item.resultStatus,
            isExpanded: true,
            itemHeight: null,
            borderRadius: AppFormStyles.dropdownBorderRadius,
            dropdownColor: AppFormStyles.dropdownBackgroundColor,
            menuMaxHeight: AppFormStyles.dropdownMenuMaxHeight,
            items: const [
              DropdownMenuItem(value: 'PASS', child: AppDropdownMenuText('通过')),
              DropdownMenuItem(value: 'FAIL', child: AppDropdownMenuText('不通过')),
              DropdownMenuItem(value: 'UNINVOLVED', child: AppDropdownMenuText('不涉及')),
            ],
            selectedItemBuilder: (context) {
              return const [AppDropdownSelectedText('通过'), AppDropdownSelectedText('不通过'), AppDropdownSelectedText('不涉及')];
            },
            onChanged: item.checked ? null : (value) => onChanged(item.copyWith(resultStatus: value ?? '')),
            decoration: AppFormStyles.inputDecoration(
              hintText: '请选择检查结果',
              enabled: !item.checked,
              prefixIcon: const Icon(Icons.assignment_turned_in_outlined, size: 18, color: Color(0xFF7B8798)),
            ),
          ),
          SizedBox(height: AppDimens.dp14),
          _SectionTitle(text: '补充说明'),
          SizedBox(height: AppDimens.dp10),
          const _FieldLabel(text: '备注'),
          SizedBox(height: AppDimens.dp8),
          if (item.checked)
            _ReadonlyBox(text: item.remark.trim().isEmpty ? '无' : item.remark)
          else
            TextFormField(
              initialValue: item.remark,
              onChanged: (value) => onChanged(item.copyWith(remark: value)),
              minLines: 3,
              maxLines: 4,
              decoration: AppFormStyles.inputDecoration(hintText: '请输入备注'),
            ),
          SizedBox(height: AppDimens.dp14),
          _SectionTitle(text: '附件信息'),
          SizedBox(height: AppDimens.dp10),
          if (item.checked)
            _AttachmentPreview(ids: item.attachments)
          else if (item.resultStatus == 'FAIL')
            CustomPickerPhoto(
              title: '附件',
              imagesList: item.attachments,
              callback: (value) => onChanged(item.copyWith(attachments: value)),
            )
          else
            const _ReadonlyBox(text: '--'),
        ],
      ),
    );
  }
}

class _ReadonlyBox extends StatelessWidget {
  const _ReadonlyBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: AppDimens.dp12, vertical: AppDimens.dp14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(AppDimens.dp10),
        border: Border.all(color: const Color(0xFFE3EAF3)),
      ),
      child: Text(
        text,
        style: TextStyle(color: const Color(0xFF223146), fontSize: AppDimens.sp12, fontWeight: FontWeight.w500, height: 1.5),
      ),
    );
  }
}

class _AttachmentPreview extends StatelessWidget {
  const _AttachmentPreview({required this.ids});

  final List<String> ids;

  @override
  Widget build(BuildContext context) {
    if (ids.isEmpty) {
      return const _ReadonlyBox(text: '--');
    }

    return Wrap(
      spacing: AppDimens.dp8,
      runSpacing: AppDimens.dp8,
      children: ids.map((id) {
        final imageUrl = FileService.getFaceUrl(id);
        return InkWell(
          onTap: imageUrl == null ? null : () => FileService.openFile(imageUrl, title: '附件预览'),
          borderRadius: BorderRadius.circular(AppDimens.dp12),
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FB),
              borderRadius: BorderRadius.circular(AppDimens.dp12),
              border: Border.all(color: const Color(0xFFE2E8F2)),
              boxShadow: const [BoxShadow(color: Color(0x080F172A), blurRadius: 8, offset: Offset(0, 3))],
            ),
            child: imageUrl == null
                ? const Icon(Icons.image_not_supported_outlined)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimens.dp12),
                    child: Image.network(imageUrl, headers: FileService.imageHeaders(), fit: BoxFit.cover, errorBuilder: (_, _, _) => const Icon(Icons.broken_image_outlined)),
                  ),
          ),
        );
      }).toList(),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.dp12, vertical: AppDimens.dp6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: AppDimens.sp11, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text, this.required = false});

  final String text;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (required)
          const Text(
            '* ',
            style: TextStyle(color: Color(0xFFE55E59), fontWeight: FontWeight.w700),
          ),
        Text(
          text,
          style: TextStyle(color: const Color(0xFF2E3B4D), fontSize: AppDimens.sp12, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppDimens.dp4,
          height: AppDimens.dp14,
          decoration: BoxDecoration(color: const Color(0xFF3A78F2), borderRadius: BorderRadius.circular(999)),
        ),
        SizedBox(width: AppDimens.dp8),
        Text(
          text,
          style: TextStyle(color: const Color(0xFF223146), fontSize: AppDimens.sp13, fontWeight: FontWeight.w700),
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
