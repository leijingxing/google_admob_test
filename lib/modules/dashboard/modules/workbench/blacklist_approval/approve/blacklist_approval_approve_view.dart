import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/components/app_standard_card.dart';
import '../../../../../../core/components/date_picker/custom_date_range_picker.dart';
import '../../../../../../core/constants/dimens.dart';
import 'blacklist_approval_approve_controller.dart';

/// 黑名单审批/更改授权页面。
class BlacklistApprovalApproveView
    extends GetView<BlacklistApprovalApproveController> {
  const BlacklistApprovalApproveView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BlacklistApprovalApproveController>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: Text(logic.pageTitle)),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(AppDimens.dp12),
            child: Column(
              children: [
                AppStandardCard(
                  child: logic.loading
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : Column(
                          children: logic.buildDetailLines().map((line) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: AppDimens.dp10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: AppDimens.dp92,
                                    child: Text(
                                      '${line.label}：',
                                      style: TextStyle(
                                        color: const Color(0xFF7B8798),
                                        fontSize: AppDimens.sp12,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      line.value,
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
                          }).toList(),
                        ),
                ),
                SizedBox(height: AppDimens.dp12),
                AppStandardCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (logic.authorizationMode) ...[
                        _fieldLabel('有效期限', required: true),
                        SizedBox(height: AppDimens.dp8),
                        CustomDateRangePicker(
                          startDate: logic.validityStart,
                          endDate: logic.validityEnd,
                          onDateRangeSelected: logic.onValidityDateChanged,
                          compact: true,
                        ),
                      ] else ...[
                        _fieldLabel('审批意见'),
                        SizedBox(height: AppDimens.dp8),
                        TextField(
                          controller: logic.parkCheckDescController,
                          minLines: 4,
                          maxLines: 6,
                          maxLength: 200,
                          decoration: InputDecoration(
                            hintText: '请输入审批意见',
                            filled: true,
                            fillColor: const Color(0xFFF8FAFD),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimens.dp10,
                              ),
                              borderSide: const BorderSide(
                                color: Color(0xFFD7DFEB),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimens.dp10,
                              ),
                              borderSide: const BorderSide(
                                color: Color(0xFFD7DFEB),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimens.dp10,
                              ),
                              borderSide: const BorderSide(
                                color: Color(0xFF1F7BFF),
                              ),
                            ),
                          ),
                        ),
                      ],
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
              child: logic.authorizationMode
                  ? _authorizationActions(logic)
                  : _approvalActions(logic),
            ),
          ),
        );
      },
    );
  }

  Widget _authorizationActions(BlacklistApprovalApproveController logic) {
    return Row(
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
            onPressed: logic.submitting ? null : logic.submitAuthorization,
            child: logic.submitting
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('确定'),
          ),
        ),
      ],
    );
  }

  Widget _approvalActions(BlacklistApprovalApproveController logic) {
    return Row(
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
            onPressed: logic.submitting
                ? null
                : () => logic.submitApproval(parkCheckStatus: 1),
            child: logic.submitting
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('确定'),
          ),
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
