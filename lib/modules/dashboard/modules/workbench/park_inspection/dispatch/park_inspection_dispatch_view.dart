import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/components/app_form_styles.dart';
import '../../../../../../core/components/app_standard_card.dart';
import '../../../../../../core/components/date_picker/ios_date_picker.dart';
import '../../../../../../core/constants/dimens.dart';
import 'park_inspection_dispatch_controller.dart';

class ParkInspectionDispatchView
    extends GetView<ParkInspectionDispatchController> {
  const ParkInspectionDispatchView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParkInspectionDispatchController>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: const Text('手动派发任务')),
          backgroundColor: const Color(0xFFF4F7FB),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppDimens.dp12,
                  AppDimens.dp12,
                  AppDimens.dp12,
                  0,
                ),
                child: TextField(
                  onChanged: logic.onKeywordChanged,
                  decoration: AppFormStyles.inputDecoration(
                    hintText: '搜索计划名称',
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      size: 18,
                      color: Color(0xFF7B8798),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(AppDimens.dp12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: AppDimens.dp150,
                        child: AppStandardCard(
                          child: logic.loading
                              ? const Center(child: CircularProgressIndicator())
                              : ListView.separated(
                                  itemCount: logic.filteredPlans.length,
                                  separatorBuilder: (context, index) =>
                                      const Divider(
                                        height: 1,
                                        color: Color(0xFFF0F2F6),
                                      ),
                                  itemBuilder: (context, index) {
                                    final item = logic.filteredPlans[index];
                                    final selected =
                                        logic.selectedPlan?.id == item.id;
                                    return InkWell(
                                      onTap: () => logic.onPlanSelected(item),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: AppDimens.dp10,
                                          vertical: AppDimens.dp10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: selected
                                              ? const Color(0xFFEFF5FF)
                                              : null,
                                          borderRadius: BorderRadius.circular(
                                            AppDimens.dp10,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.planName ?? '--',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: const Color(0xFF223146),
                                                fontSize: AppDimens.sp13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(height: AppDimens.dp4),
                                            Text(
                                              item.planCode ?? '--',
                                              style: TextStyle(
                                                color: const Color(0xFF7B8798),
                                                fontSize: AppDimens.sp11,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                      SizedBox(width: AppDimens.dp12),
                      Expanded(
                        child: AppStandardCard(
                          child: logic.selectedPlan == null
                              ? const Center(child: Text('请选择左侧巡检计划'))
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _DetailLine(
                                      label: '计划名称',
                                      value:
                                          logic.selectedPlan!.planName ?? '--',
                                    ),
                                    _DetailLine(
                                      label: '计划编码',
                                      value:
                                          logic.selectedPlan!.planCode ?? '--',
                                    ),
                                    _DetailLine(
                                      label: '巡检类型',
                                      value: logic.parentController.typeText(
                                        logic.selectedPlan!.typeCode,
                                      ),
                                    ),
                                    _DetailLine(
                                      label: '多人巡检',
                                      value:
                                          (logic.selectedPlan!.isMultiPerson ??
                                                  '') ==
                                              '1'
                                          ? '是'
                                          : '否',
                                    ),
                                    SizedBox(height: AppDimens.dp12),
                                    Text(
                                      '任务日期',
                                      style: TextStyle(
                                        color: const Color(0xFF5D6B7D),
                                        fontSize: AppDimens.sp12,
                                      ),
                                    ),
                                    SizedBox(height: AppDimens.dp6),
                                    TextField(
                                      controller: logic.dateController,
                                      readOnly: true,
                                      onTap: () {
                                        showIosDatePicker(
                                          context: context,
                                          initialTime: DateTime.now(),
                                          minTime: DateTime(2024),
                                          maxTime: DateTime(2100, 12, 31),
                                          mode: CupertinoDatePickerMode.date,
                                          onConfirm: logic.onTaskDateChanged,
                                        );
                                      },
                                      decoration: AppFormStyles.inputDecoration(
                                        hintText: '请选择任务日期',
                                        prefixIcon: const Icon(
                                          Icons.event_note_rounded,
                                          size: 18,
                                          color: Color(0xFF7B8798),
                                        ),
                                        suffixIcon: const Icon(
                                          Icons.date_range_rounded,
                                          size: 18,
                                          color: Color(0xFF7B8798),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
                          : const Text('派发'),
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

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.label, required this.value});

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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
