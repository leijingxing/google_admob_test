import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../core/components/app_form_styles.dart';
import '../../../../../../../core/components/app_standard_card.dart';
import '../../../../../../../core/constants/dimens.dart';
import 'park_inspection_cancel_controller.dart';

class ParkInspectionCancelView extends GetView<ParkInspectionCancelController> {
  const ParkInspectionCancelView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParkInspectionCancelController>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: const Text('取消任务')),
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
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFF4F1), Color(0xFFFFFBFA)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppDimens.dp10),
                      border: Border.all(color: const Color(0xFFFFD9CF)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: AppDimens.dp30,
                              height: AppDimens.dp30,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFE9E2),
                                borderRadius: BorderRadius.circular(
                                  AppDimens.dp9,
                                ),
                              ),
                              child: const Icon(
                                Icons.block_outlined,
                                size: 18,
                                color: Color(0xFFE06A4B),
                              ),
                            ),
                            SizedBox(width: AppDimens.dp10),
                            Expanded(
                              child: Text(
                                '取消操作提示',
                                style: TextStyle(
                                  color: const Color(0xFF243447),
                                  fontSize: AppDimens.sp13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppDimens.dp8),
                        Text(
                          '取消后任务将不可继续执行，请填写明确的取消原因，便于后续追溯和沟通。',
                          style: TextStyle(
                            color: const Color(0xFF6C7A8C),
                            fontSize: AppDimens.sp12,
                            height: 1.6,
                          ),
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
                      _sectionTitle('取消信息'),
                      SizedBox(height: AppDimens.dp10),
                      _fieldLabel('取消原因', required: true),
                      SizedBox(height: AppDimens.dp8),
                      TextField(
                        controller: logic.reasonController,
                        minLines: 4,
                        maxLines: 6,
                        maxLength: 200,
                        decoration: AppFormStyles.inputDecoration(
                          hintText: '请输入取消原因',
                        ),
                      ),
                      SizedBox(height: AppDimens.dp6),
                      Padding(
                        padding: EdgeInsets.only(left: AppDimens.dp2),
                        child: Text(
                          '建议说明取消背景、当前处理情况或后续安排，避免任务状态不清。',
                          style: TextStyle(
                            color: const Color(0xFF8A97A8),
                            fontSize: AppDimens.sp11,
                          ),
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
              padding: EdgeInsets.fromLTRB(
                AppDimens.dp12,
                AppDimens.dp10,
                AppDimens.dp12,
                AppDimens.dp10,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE7EDF5))),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0A0F172A),
                    blurRadius: 14,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size.fromHeight(AppDimens.dp44),
                        side: const BorderSide(color: Color(0xFFD7DFEB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimens.dp10),
                        ),
                        foregroundColor: const Color(0xFF5C6B7D),
                      ),
                      onPressed: logic.submitting ? null : Get.back,
                      child: const Text('返回'),
                    ),
                  ),
                  SizedBox(width: AppDimens.dp10),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: Size.fromHeight(AppDimens.dp44),
                        backgroundColor: const Color(0xFFE06A4B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimens.dp10),
                        ),
                        elevation: 0,
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
                          : const Text('确认取消'),
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

  Widget _sectionTitle(String text) {
    return Row(
      children: [
        Container(
          width: AppDimens.dp4,
          height: AppDimens.dp14,
          decoration: BoxDecoration(
            color: const Color(0xFFE06A4B),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        SizedBox(width: AppDimens.dp8),
        Text(
          text,
          style: TextStyle(
            color: const Color(0xFF223146),
            fontSize: AppDimens.sp13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
