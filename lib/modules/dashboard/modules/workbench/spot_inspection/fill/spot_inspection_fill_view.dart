import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/components/app_standard_card.dart';
import '../../../../../../core/components/select/custom_picker_photo.dart';
import '../../../../../../core/constants/dimens.dart';
import 'spot_inspection_fill_controller.dart';

/// 抽检填写页。
class SpotInspectionFillView extends GetView<SpotInspectionFillController> {
  const SpotInspectionFillView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SpotInspectionFillController>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: const Text('抽检')),
          backgroundColor: const Color(0xFFF5F7FB),
          body: logic.loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    AppDimens.dp12,
                    AppDimens.dp12,
                    AppDimens.dp12,
                    AppDimens.dp120,
                  ),
                  child: Column(
                    children: [
                      _SummaryCard(controller: logic),
                      SizedBox(height: AppDimens.dp12),
                      ...List.generate(logic.items.length, (index) {
                        final item = logic.items[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: AppDimens.dp12),
                          child: _InspectionEditorCard(
                            index: index,
                            item: item,
                            controller: logic,
                          ),
                        );
                      }),
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
                boxShadow: [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 12,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        '检查结果',
                        style: TextStyle(
                          color: const Color(0xFF1D2B3A),
                          fontSize: AppDimens.sp13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: AppDimens.dp12),
                      _ResultRadio(
                        label: '通过',
                        selected: logic.overallResult == 1,
                        onTap: () => logic.updateOverallResult(1),
                      ),
                      SizedBox(width: AppDimens.dp16),
                      _ResultRadio(
                        label: '不通过',
                        selected: logic.overallResult == 0,
                        onTap: () => logic.updateOverallResult(0),
                      ),
                    ],
                  ),
                  SizedBox(height: AppDimens.dp12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: logic.submitting ? null : Get.back,
                          child: const Text('取消'),
                        ),
                      ),
                      SizedBox(width: AppDimens.dp12),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.controller});

  final SpotInspectionFillController controller;

  @override
  Widget build(BuildContext context) {
    return AppStandardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SummaryLine(label: '检查信息', value: controller.checkInfoText),
          _SummaryLine(label: '车牌号', value: controller.carNumbText),
          _SummaryLine(label: '检查模板', value: controller.templateText),
          _SummaryLine(label: '检查时间', value: controller.timeText),
          _SummaryLine(label: '检查人员', value: controller.checkerText),
        ],
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
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimens.dp8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 74,
            child: Text(
              '$label：',
              style: TextStyle(
                color: const Color(0xFF6D7889),
                fontSize: AppDimens.sp12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: const Color(0xFF1D2B3A),
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

class _InspectionEditorCard extends StatelessWidget {
  const _InspectionEditorCard({
    required this.index,
    required this.item,
    required this.controller,
  });

  final int index;
  final InspectionEditableItem item;
  final SpotInspectionFillController controller;

  @override
  Widget build(BuildContext context) {
    return AppStandardCard(
      padding: EdgeInsets.all(AppDimens.dp14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppDimens.dp28,
                height: AppDimens.dp28,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF1FF),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${index + 1}'.padLeft(2, '0'),
                  style: TextStyle(
                    color: const Color(0xFF225BE6),
                    fontSize: AppDimens.sp12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: AppDimens.dp10),
              Expanded(
                child: Text(
                  item.checkItemName,
                  style: TextStyle(
                    color: const Color(0xFF1D2B3A),
                    fontSize: AppDimens.sp14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimens.dp12),
          _FormLine(
            label: '检查说明',
            child: Text(
              item.checkDescribe,
              style: TextStyle(
                color: const Color(0xFF344255),
                fontSize: AppDimens.sp12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: AppDimens.dp10),
          _FormLine(
            label: '是否合格',
            child: Row(
              children: [
                _ResultRadio(
                  label: '是',
                  selected: item.pass,
                  onTap: () => controller.updateItemPass(index, true),
                ),
                SizedBox(width: AppDimens.dp16),
                _ResultRadio(
                  label: '否',
                  selected: !item.pass,
                  onTap: () => controller.updateItemPass(index, false),
                ),
              ],
            ),
          ),
          SizedBox(height: AppDimens.dp10),
          _FormLine(
            label: '备注',
            child: TextFormField(
              initialValue: item.remark,
              onChanged: (value) => controller.updateItemRemark(index, value),
              decoration: InputDecoration(
                hintText: '请输入备注',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppDimens.dp10,
                  vertical: AppDimens.dp8,
                ),
                filled: true,
                fillColor: const Color(0xFFF8FAFD),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimens.dp8),
                  borderSide: const BorderSide(color: Color(0xFFD7DFEB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimens.dp8),
                  borderSide: const BorderSide(color: Color(0xFFD7DFEB)),
                ),
              ),
            ),
          ),
          SizedBox(height: AppDimens.dp10),
          _FormLine(
            label: '照片',
            child: CustomPickerPhoto(
              title: '上传图片',
              isShowTitle: false,
              maxCount: 3,
              imagesList: item.checkFile
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList(),
              callback: (value) => controller.updateItemPhotos(index, value),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormLine extends StatelessWidget {
  const _FormLine({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 62,
          child: Padding(
            padding: EdgeInsets.only(top: AppDimens.dp6),
            child: Text(
              '$label：',
              style: TextStyle(
                color: const Color(0xFF6D7889),
                fontSize: AppDimens.sp12,
              ),
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}

class _ResultRadio extends StatelessWidget {
  const _ResultRadio({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            selected
                ? Icons.radio_button_checked_rounded
                : Icons.radio_button_off_rounded,
            color: selected ? const Color(0xFF1F7BFF) : const Color(0xFFB6C0CF),
            size: 18,
          ),
          SizedBox(width: AppDimens.dp4),
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF344255),
              fontSize: AppDimens.sp12,
            ),
          ),
        ],
      ),
    );
  }
}
