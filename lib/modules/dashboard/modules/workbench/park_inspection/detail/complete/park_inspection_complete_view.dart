import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../core/components/app_standard_card.dart';
import '../../../../../../../core/constants/dimens.dart';
import 'park_inspection_complete_controller.dart';

class ParkInspectionCompleteView
    extends GetView<ParkInspectionCompleteController> {
  const ParkInspectionCompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParkInspectionCompleteController>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: const Text('完成巡检')),
          backgroundColor: const Color(0xFFF4F7FB),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(AppDimens.dp12),
            child: Column(
              children: [
                AppStandardCard(
                  child: _SummaryLine(
                    label: '提交说明',
                    value: '填写完成备注后提交，任务将流转为已完成状态',
                  ),
                ),
                SizedBox(height: AppDimens.dp12),
                AppStandardCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel('完成备注'),
                      SizedBox(height: AppDimens.dp8),
                      TextField(
                        controller: logic.remarkController,
                        minLines: 4,
                        maxLines: 6,
                        maxLength: 200,
                        decoration: _inputDecoration(hintText: '请输入完成备注（可选）'),
                      ),
                    ],
                  ),
                ),
              ],
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
                  SizedBox(width: AppDimens.dp8),
                  Expanded(
                    child: FilledButton(
                      onPressed: logic.submitting ? null : logic.submit,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF22A06B),
                      ),
                      child: logic.submitting
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('确认完成'),
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

  Widget _fieldLabel(String text, {bool required = false}) {
    return Row(
      children: [
        if (required)
          const Text(
            '* ',
            style: TextStyle(
              color: Color(0xFFE55E59),
              fontWeight: FontWeight.w700,
            ),
          ),
        Text(
          text,
          style: TextStyle(
            color: const Color(0xFF2E3B4D),
            fontSize: AppDimens.sp12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({required String hintText}) {
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
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
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
              color: const Color(0xFF263547),
              fontSize: AppDimens.sp12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
