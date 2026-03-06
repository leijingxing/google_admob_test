import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/components/app_standard_card.dart';
import '../../../../../../core/components/select/custom_picker_photo.dart';
import '../../../../../../core/constants/dimens.dart';
import 'alarm_disposal_handle_controller.dart';

/// 报警处置页。
class AlarmDisposalHandleView extends GetView<AlarmDisposalHandleController> {
  const AlarmDisposalHandleView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlarmDisposalHandleController>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: const Text('报警处置')),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(AppDimens.dp12),
            child: Column(
              children: [
                AppStandardCard(
                  child: Column(
                    children: [
                      _line('报警名称', logic.display(logic.item.title)),
                      _line('报警内容', logic.display(logic.item.description)),
                      _line(
                        '报警开始时间',
                        logic.display(logic.item.warningStartTime),
                      ),
                      _line(
                        '报警结束时间',
                        logic.display(logic.item.warningEndTime),
                        isLast: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppDimens.dp12),
                AppStandardCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel('处置描述', required: true),
                      SizedBox(height: AppDimens.dp8),
                      TextField(
                        controller: logic.disposalResultController,
                        minLines: 4,
                        maxLines: 6,
                        maxLength: 300,
                        decoration: InputDecoration(
                          hintText: '请输入处置描述',
                          filled: true,
                          fillColor: const Color(0xFFF8FAFD),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimens.dp10),
                            borderSide: const BorderSide(
                              color: Color(0xFFD7DFEB),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimens.dp10),
                            borderSide: const BorderSide(
                              color: Color(0xFFD7DFEB),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimens.dp10),
                            borderSide: const BorderSide(
                              color: Color(0xFF1F7BFF),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppDimens.dp12),
                      CustomPickerPhoto(
                        title: '附件',
                        imagesList: logic.disposalFiles,
                        callback: logic.onFilesChanged,
                        isRequired: true,
                        maxCount: 6,
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
                      child: logic.submitting
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('提交'),
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

  Widget _line(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppDimens.dp10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppDimens.dp96,
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
      ),
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
