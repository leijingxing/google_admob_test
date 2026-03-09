import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../core/components/app_form_styles.dart';
import '../../../../../../../core/components/app_standard_card.dart';
import '../../../../../../../core/components/select/custom_picker_photo.dart';
import '../../../../../../../core/constants/dimens.dart';
import 'park_inspection_report_abnormal_controller.dart';

class ParkInspectionReportAbnormalView extends GetView<ParkInspectionReportAbnormalController> {
  const ParkInspectionReportAbnormalView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParkInspectionReportAbnormalController>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: const Text('上报异常')),
          backgroundColor: const Color(0xFFF4F7FB),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(AppDimens.dp12),
            child: Column(
              children: [
                AppStandardCard(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppDimens.dp12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFFFF5F1), Color(0xFFFFFBF9)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(AppDimens.dp10),
                      border: Border.all(color: const Color(0xFFFFD8CB)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: AppDimens.dp30,
                              height: AppDimens.dp30,
                              decoration: BoxDecoration(color: const Color(0xFFFFE9E1), borderRadius: BorderRadius.circular(AppDimens.dp9)),
                              child: const Icon(Icons.report_problem_outlined, size: 18, color: Color(0xFFE06A4B)),
                            ),
                            SizedBox(width: AppDimens.dp10),
                            Expanded(
                              child: Text(
                                '异常上报说明',
                                style: TextStyle(color: const Color(0xFF243447), fontSize: AppDimens.sp13, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppDimens.dp8),
                        Text(
                          '请选择对应巡检细则，补充异常描述与现场照片，便于后续快速定位和处置。',
                          style: TextStyle(color: const Color(0xFF6C7A8C), fontSize: AppDimens.sp12, height: 1.6),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: AppDimens.dp12),
                AppStandardCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle('基础信息'),
                      SizedBox(height: AppDimens.dp10),
                      _InfoLine(label: '巡检点位', value: logic.record.pointName ?? '--'),
                      SizedBox(height: AppDimens.dp6),
                      _fieldLabel('巡检细则', required: true),
                      SizedBox(height: AppDimens.dp8),
                      DropdownButtonFormField<String>(
                        initialValue: logic.selectedRuleId,
                        isExpanded: true,
                        itemHeight: null,
                        borderRadius: AppFormStyles.dropdownBorderRadius,
                        dropdownColor: AppFormStyles.dropdownBackgroundColor,
                        menuMaxHeight: AppFormStyles.dropdownMenuMaxHeight,
                        items: logic.detailController.planRules.map((item) => DropdownMenuItem<String>(value: item.ruleId ?? item.id, child: AppDropdownMenuText(item.ruleName ?? '--'))).toList(),
                        selectedItemBuilder: (context) {
                          return logic.detailController.planRules.map((item) => AppDropdownSelectedText(item.ruleName ?? '--')).toList();
                        },
                        onChanged: logic.onRuleChanged,
                        decoration: AppFormStyles.inputDecoration(
                          hintText: '请选择巡检细则',
                          prefixIcon: const Icon(Icons.rule_folder_outlined, size: 18, color: Color(0xFF7B8798)),
                        ),
                      ),
                      SizedBox(height: AppDimens.dp14),
                      _sectionTitle('异常内容'),
                      SizedBox(height: AppDimens.dp10),
                      _fieldLabel('异常描述', required: true),
                      SizedBox(height: AppDimens.dp8),
                      TextField(
                        controller: logic.descController,
                        minLines: 4,
                        maxLines: 5,
                        maxLength: 300,
                        decoration: AppFormStyles.inputDecoration(hintText: '请输入异常描述，建议补充异常现象、位置和影响范围'),
                      ),
                      SizedBox(height: AppDimens.dp6),
                      _fieldLabel('紧急程度', required: true),
                      SizedBox(height: AppDimens.dp8),
                      Row(
                        children: [
                          Expanded(
                            child: _UrgentOption(
                              label: '紧急',
                              desc: '需要优先处置',
                              selected: logic.isUrgent == '1',
                              accentColor: const Color(0xFFE06A4B),
                              icon: Icons.local_fire_department_outlined,
                              onTap: () => logic.onUrgentChanged('1'),
                            ),
                          ),
                          SizedBox(width: AppDimens.dp10),
                          Expanded(
                            child: _UrgentOption(
                              label: '一般',
                              desc: '按流程跟进',
                              selected: logic.isUrgent == '0',
                              accentColor: const Color(0xFF3A78F2),
                              icon: Icons.schedule_outlined,
                              onTap: () => logic.onUrgentChanged('0'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppDimens.dp14),
                      _sectionTitle('现场附件'),
                      SizedBox(height: AppDimens.dp10),
                      CustomPickerPhoto(title: '现场照片', imagesList: logic.photoIds, callback: logic.onPhotosChanged),
                    ],
                  ),
                ),
              ],
            ),
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
                        backgroundColor: const Color(0xFFE06A4B),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.dp10)),
                        elevation: 0,
                      ),
                      onPressed: logic.submitting ? null : logic.submit,
                      child: logic.submitting ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('提交上报'),
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

  Widget _sectionTitle(String text) {
    return Row(
      children: [
        Container(
          width: AppDimens.dp4,
          height: AppDimens.dp14,
          decoration: BoxDecoration(color: const Color(0xFFE06A4B), borderRadius: BorderRadius.circular(999)),
        ),
        SizedBox(width: AppDimens.dp8),
        Text(
          text,
          style: TextStyle(color: const Color(0xFF223146), fontSize: AppDimens.sp13, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _fieldLabel(String text, {bool required = false}) {
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

class _UrgentOption extends StatelessWidget {
  const _UrgentOption({required this.label, required this.desc, required this.selected, required this.accentColor, required this.icon, required this.onTap});

  final String label;
  final String desc;
  final bool selected;
  final Color accentColor;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.dp12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: AppDimens.dp12, vertical: AppDimens.dp12),
        decoration: BoxDecoration(
          color: selected ? accentColor.withValues(alpha: 0.09) : Colors.white,
          borderRadius: BorderRadius.circular(AppDimens.dp12),
          border: Border.all(color: selected ? accentColor : const Color(0xFFD7DFEB), width: selected ? 1.4 : 1),
          boxShadow: selected ? [BoxShadow(color: accentColor.withValues(alpha: 0.10), blurRadius: 12, offset: const Offset(0, 4))] : null,
        ),
        child: Row(
          children: [
            Container(
              width: AppDimens.dp30,
              height: AppDimens.dp30,
              decoration: BoxDecoration(color: selected ? accentColor.withValues(alpha: 0.14) : const Color(0xFFF4F7FB), borderRadius: BorderRadius.circular(AppDimens.dp9)),
              child: Icon(icon, size: 18, color: selected ? accentColor : const Color(0xFF8B98A8)),
            ),
            SizedBox(width: AppDimens.dp10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(color: selected ? accentColor : const Color(0xFF223146), fontSize: AppDimens.sp12, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: AppDimens.dp2),
                  Text(
                    desc,
                    style: TextStyle(color: const Color(0xFF7F8A99), fontSize: AppDimens.sp11),
                  ),
                ],
              ),
            ),
            Icon(selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, size: 18, color: selected ? accentColor : const Color(0xFFB3BFCC)),
          ],
        ),
      ),
    );
  }
}
