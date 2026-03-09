import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../core/components/app_standard_card.dart';
import '../../../../../../../core/constants/dimens.dart';
import 'park_inspection_check_in_controller.dart';

class ParkInspectionCheckInView
    extends GetView<ParkInspectionCheckInController> {
  const ParkInspectionCheckInView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParkInspectionCheckInController>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: const Text('点位打卡')),
          backgroundColor: const Color(0xFFF4F7FB),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(AppDimens.dp12),
            child: Column(
              children: [
                AppStandardCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel('巡检点位', required: true),
                      SizedBox(height: AppDimens.dp8),
                      DropdownButtonFormField<String>(
                        initialValue: logic.selectedPointId,
                        items: logic.pointItems,
                        onChanged: logic.onPointChanged,
                        decoration: const InputDecoration(
                          hintText: '请选择巡检点位',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: AppDimens.dp12),
                      _fieldLabel('打卡位置', required: true),
                      SizedBox(height: AppDimens.dp8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: logic.positionController,
                              decoration: const InputDecoration(
                                hintText: '请输入经度,纬度',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: AppDimens.dp8),
                          FilledButton.tonalIcon(
                            onPressed: logic.locating
                                ? null
                                : logic.fetchCurrentLocation,
                            icon: logic.locating
                                ? const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.my_location_outlined),
                            label: Text(logic.locating ? '定位中' : '获取定位'),
                          ),
                        ],
                      ),
                      SizedBox(height: AppDimens.dp12),
                      _fieldLabel('备注'),
                      SizedBox(height: AppDimens.dp8),
                      TextField(
                        controller: logic.remarkController,
                        minLines: 4,
                        maxLines: 6,
                        maxLength: 200,
                        decoration: const InputDecoration(
                          hintText: '请输入打卡备注',
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
                          : const Text('提交打卡'),
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
