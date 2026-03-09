import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../core/components/app_standard_card.dart';
import '../../../../../../../core/components/select/custom_picker_photo.dart';
import '../../../../../../../core/constants/dimens.dart';
import 'park_inspection_report_abnormal_controller.dart';

class ParkInspectionReportAbnormalView
    extends GetView<ParkInspectionReportAbnormalController> {
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
            child: AppStandardCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoLine(
                    label: '巡检点位',
                    value: logic.record.pointName ?? '--',
                  ),
                  DropdownButtonFormField<String>(
                    initialValue: logic.selectedRuleId,
                    isExpanded: true,
                    items: logic.detailController.planRules
                        .map(
                          (item) => DropdownMenuItem<String>(
                            value: item.ruleId ?? item.id,
                            child: Text(
                              item.ruleName ?? '--',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: logic.onRuleChanged,
                    decoration: _inputDecoration(hintText: '请选择巡检细则'),
                  ),
                  SizedBox(height: AppDimens.dp10),
                  TextField(
                    controller: logic.descController,
                    minLines: 3,
                    maxLines: 4,
                    decoration: _inputDecoration(hintText: '请输入异常描述'),
                  ),
                  SizedBox(height: AppDimens.dp10),
                  Row(
                    children: [
                      Text('是否紧急', style: TextStyle(fontSize: AppDimens.sp12)),
                      SizedBox(width: AppDimens.dp10),
                      ChoiceChip(
                        label: const Text('是'),
                        selected: logic.isUrgent == '1',
                        onSelected: (_) => logic.onUrgentChanged('1'),
                      ),
                      SizedBox(width: AppDimens.dp8),
                      ChoiceChip(
                        label: const Text('否'),
                        selected: logic.isUrgent == '0',
                        onSelected: (_) => logic.onUrgentChanged('0'),
                      ),
                    ],
                  ),
                  SizedBox(height: AppDimens.dp10),
                  CustomPickerPhoto(
                    title: '现场照片',
                    imagesList: logic.photoIds,
                    callback: logic.onPhotosChanged,
                  ),
                ],
              ),
            ),
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
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFE06A4B),
                      ),
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
                          : const Text('上报异常'),
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

InputDecoration _inputDecoration({String? hintText}) {
  return InputDecoration(
    hintText: hintText,
    filled: true,
    fillColor: const Color(0xFFF8FAFD),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimens.dp10),
      borderSide: const BorderSide(color: Color(0xFFD7DFEB)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimens.dp10),
      borderSide: const BorderSide(color: Color(0xFFD7DFEB)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimens.dp10),
      borderSide: const BorderSide(color: Color(0xFF1F7BFF)),
    ),
  );
}
