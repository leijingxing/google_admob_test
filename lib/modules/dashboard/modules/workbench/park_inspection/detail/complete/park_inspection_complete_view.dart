import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../core/components/app_form_styles.dart';
import '../../../../../../../core/components/app_standard_card.dart';
import '../../../../../../../core/constants/dimens.dart';
import 'park_inspection_complete_controller.dart';

class ParkInspectionCompleteView extends GetView<ParkInspectionCompleteController> {
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
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppDimens.dp12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFF1FBF6), Color(0xFFFAFFFC)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(AppDimens.dp10),
                      border: Border.all(color: const Color(0xFFD6F0E1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: AppDimens.dp30,
                              height: AppDimens.dp30,
                              decoration: BoxDecoration(color: const Color(0xFFE6F7EE), borderRadius: BorderRadius.circular(AppDimens.dp9)),
                              child: const Icon(Icons.task_alt_rounded, size: 18, color: Color(0xFF22A06B)),
                            ),
                            SizedBox(width: AppDimens.dp10),
                            Expanded(
                              child: Text(
                                '完成提交说明',
                                style: TextStyle(color: const Color(0xFF243447), fontSize: AppDimens.sp13, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppDimens.dp8),
                        Text(
                          '填写完成备注后提交，任务将流转为已完成状态。建议补充本次巡检结果、现场情况或收尾说明。',
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
                      _sectionTitle('完成信息'),
                      SizedBox(height: AppDimens.dp10),
                      _fieldLabel('完成备注'),
                      SizedBox(height: AppDimens.dp8),
                      TextField(
                        controller: logic.remarkController,
                        minLines: 4,
                        maxLines: 6,
                        maxLength: ParkInspectionCompleteController.maxRemarkLength,
                        decoration: AppFormStyles.inputDecoration(hintText: '请输入完成备注（可选）'),
                      ),
                      SizedBox(height: AppDimens.dp6),
                      Padding(
                        padding: EdgeInsets.only(left: AppDimens.dp2),
                        child: Text(
                          '可不填。若现场已处理完成，建议补充结果说明，便于后续追溯。',
                          style: TextStyle(color: const Color(0xFF8A97A8), fontSize: AppDimens.sp11),
                        ),
                      ),
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
                        backgroundColor: const Color(0xFF22A06B),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.dp10)),
                        elevation: 0,
                      ),
                      onPressed: logic.submitting ? null : logic.submit,
                      child: logic.submitting ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('确认完成'),
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
            style: TextStyle(color: Color(0xFFE55E59), fontWeight: FontWeight.w700),
          ),
        Text(
          text,
          style: TextStyle(color: const Color(0xFF2E3B4D), fontSize: AppDimens.sp12, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _sectionTitle(String text) {
    return Row(
      children: [
        Container(
          width: AppDimens.dp4,
          height: AppDimens.dp14,
          decoration: BoxDecoration(color: const Color(0xFF22A06B), borderRadius: BorderRadius.circular(999)),
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
