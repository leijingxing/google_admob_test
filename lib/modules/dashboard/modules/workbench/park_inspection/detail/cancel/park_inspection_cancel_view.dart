import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel('取消原因', required: true),
                      SizedBox(height: AppDimens.dp8),
                      TextField(
                        controller: logic.reasonController,
                        minLines: 4,
                        maxLines: 6,
                        maxLength: 200,
                        decoration: const InputDecoration(
                          hintText: '请输入取消原因',
                          border: OutlineInputBorder(),
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
                      child: const Text('返回'),
                    ),
                  ),
                  SizedBox(width: AppDimens.dp8),
                  Expanded(
                    child: FilledButton(
                      onPressed: logic.submitting ? null : logic.submit,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFE06A4B),
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
}
