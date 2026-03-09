import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../core/components/app_form_styles.dart';
import '../../../../../../../core/components/app_standard_card.dart';
import '../../../../../../../core/constants/dimens.dart';
import 'park_inspection_check_in_controller.dart';

class ParkInspectionCheckInView extends GetView<ParkInspectionCheckInController> {
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
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppDimens.dp12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFF2F8FF), Color(0xFFFAFCFF)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(AppDimens.dp10),
                      border: Border.all(color: const Color(0xFFD8E6FF)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: AppDimens.dp30,
                              height: AppDimens.dp30,
                              decoration: BoxDecoration(color: const Color(0xFFE8F1FF), borderRadius: BorderRadius.circular(AppDimens.dp9)),
                              child: const Icon(Icons.pin_drop_outlined, size: 18, color: Color(0xFF3A78F2)),
                            ),
                            SizedBox(width: AppDimens.dp10),
                            Expanded(
                              child: Text(
                                '打卡说明',
                                style: TextStyle(color: const Color(0xFF243447), fontSize: AppDimens.sp13, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppDimens.dp8),
                        Text(
                          '请选择巡检点位，并填写或获取当前设备经纬度后提交，确保巡检打卡位置准确可追溯。',
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
                      _fieldLabel('巡检点位', required: true),
                      SizedBox(height: AppDimens.dp8),
                      DropdownButtonFormField<String>(
                        initialValue: logic.selectedPointId,
                        isExpanded: true,
                        itemHeight: null,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF7B8798)),
                        borderRadius: AppFormStyles.dropdownBorderRadius,
                        dropdownColor: AppFormStyles.dropdownBackgroundColor,
                        menuMaxHeight: AppFormStyles.dropdownMenuMaxHeight,
                        items: logic.pointItems,
                        selectedItemBuilder: (context) {
                          return logic.detailController.planPoints.map((item) => AppDropdownSelectedText(item.pointName ?? '--')).toList();
                        },
                        onChanged: logic.onPointChanged,
                        decoration: AppFormStyles.inputDecoration(
                          hintText: '请选择巡检点位',
                          prefixIcon: const Icon(Icons.place_outlined, size: 18, color: Color(0xFF7B8798)),
                        ),
                      ),
                      SizedBox(height: AppDimens.dp14),
                      _sectionTitle('定位信息'),
                      SizedBox(height: AppDimens.dp10),
                      _fieldLabel('打卡位置', required: true),
                      SizedBox(height: AppDimens.dp8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: logic.positionController,
                              decoration: AppFormStyles.inputDecoration(
                                hintText: '请输入经度,纬度',
                                prefixIcon: const Icon(Icons.my_location_outlined, size: 18, color: Color(0xFF7B8798)),
                              ),
                            ),
                          ),
                          SizedBox(width: AppDimens.dp8),
                          SizedBox(
                            height: AppDimens.dp48,
                            child: FilledButton.tonalIcon(
                              style: FilledButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: AppDimens.dp14),
                                backgroundColor: const Color(0xFFEAF2FF),
                                foregroundColor: const Color(0xFF2F6FE4),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.dp10)),
                                elevation: 0,
                              ),
                              onPressed: logic.locating ? null : logic.fetchCurrentLocation,
                              icon: logic.locating ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.gps_fixed_rounded, size: 18),
                              label: Text(logic.locating ? '定位中' : '获取定位'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppDimens.dp6),
                      Padding(
                        padding: EdgeInsets.only(left: AppDimens.dp2),
                        child: Text(
                          '支持手动输入，也可点击右侧按钮自动获取当前设备定位',
                          style: TextStyle(color: const Color(0xFF8A97A8), fontSize: AppDimens.sp11),
                        ),
                      ),
                      SizedBox(height: AppDimens.dp14),
                      _sectionTitle('补充说明'),
                      SizedBox(height: AppDimens.dp10),
                      _fieldLabel('备注'),
                      SizedBox(height: AppDimens.dp8),
                      TextField(
                        controller: logic.remarkController,
                        minLines: 4,
                        maxLines: 6,
                        maxLength: 300,
                        decoration: AppFormStyles.inputDecoration(hintText: '请输入打卡备注，可补充现场情况说明'),
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
                        backgroundColor: const Color(0xFF3A78F2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.dp10)),
                        elevation: 0,
                      ),
                      onPressed: logic.submitting ? null : logic.submit,
                      child: logic.submitting ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('提交打卡'),
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
          decoration: BoxDecoration(color: const Color(0xFF3A78F2), borderRadius: BorderRadius.circular(999)),
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
