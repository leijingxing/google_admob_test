import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/components/app_standard_card.dart';
import '../../../../../../core/components/select/custom_picker_photo.dart';
import '../../../../../../core/constants/dimens.dart';
import '../../../../../../core/utils/file_service.dart';
import '../../../../../../data/models/workbench/spot_inspection_editable_item_model.dart';
import '../../../../../../data/models/workbench/spot_inspection_check_item_model.dart';
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
          backgroundColor: const Color(0xFFF7FBFB),
          body: logic.loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    AppDimens.dp16,
                    AppDimens.dp14,
                    AppDimens.dp16,
                    AppDimens.dp120,
                  ),
                  child: Column(
                    children: [
                      _HeaderSection(controller: logic),
                      SizedBox(height: AppDimens.dp14),
                      ...List.generate(logic.items.length, (index) {
                        final item = logic.items[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: AppDimens.dp14),
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
                AppDimens.dp16,
                AppDimens.dp12,
                AppDimens.dp16,
                AppDimens.dp12,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: const Border(top: BorderSide(color: Color(0xFFE1EFEF))),
                boxShadow: const [
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
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppDimens.dp12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5FBFB),
                      borderRadius: BorderRadius.circular(AppDimens.dp16),
                      border: Border.all(color: const Color(0xFFD7ECEC)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '检查结果',
                          style: TextStyle(
                            color: const Color(0xFF1D2B3A),
                            fontSize: AppDimens.sp13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: AppDimens.dp10),
                        Row(
                          children: [
                            Expanded(
                              child: _BottomResultCard(
                                label: '通过',
                                hint: '全部检查项满足要求',
                                selected: logic.overallResult == 1,
                                selectedColor: const Color(0xFF06BFCC),
                                selectedBgColor: const Color(0xFFE8FBFC),
                                onTap: () => logic.updateOverallResult(1),
                              ),
                            ),
                            SizedBox(width: AppDimens.dp12),
                            Expanded(
                              child: _BottomResultCard(
                                label: '不通过',
                                hint: '存在异常项需处理',
                                selected: logic.overallResult == 0,
                                selectedColor: const Color(0xFFFF6A59),
                                selectedBgColor: const Color(0xFFFFEFEC),
                                onTap: () => logic.updateOverallResult(0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppDimens.dp12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: logic.submitting ? null : Get.back,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF06BFCC),
                            side: const BorderSide(color: Color(0xFF80DCE2)),
                            minimumSize: const Size.fromHeight(44),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          child: const Text('取消'),
                        ),
                      ),
                      SizedBox(width: AppDimens.dp12),
                      Expanded(
                        child: FilledButton(
                          onPressed: logic.submitting ? null : logic.submit,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF06BFCC),
                            minimumSize: const Size.fromHeight(44),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
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

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.controller});

  final SpotInspectionFillController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppDimens.dp16,
        AppDimens.dp16,
        AppDimens.dp16,
        AppDimens.dp14,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFF1FBFB)],
        ),
        borderRadius: BorderRadius.circular(AppDimens.dp18),
        border: Border.all(color: const Color(0xFFCBE7E9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  controller.carNumbText,
                  style: TextStyle(
                    color: const Color(0xFF25322F),
                    fontSize: AppDimens.sp18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimens.dp12,
                  vertical: AppDimens.dp6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF06BFCC),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '待抽检',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppDimens.sp11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimens.dp6),
          Text(
            controller.checkInfoText,
            style: TextStyle(
              color: const Color(0xFF98A9AB),
              fontSize: AppDimens.sp12,
            ),
          ),
          SizedBox(height: AppDimens.dp14),
          Container(height: 1, color: const Color(0xFFC5D9DA)),
          SizedBox(height: AppDimens.dp14),
          _SummaryLine(label: '检查模板', value: controller.templateText),
          _SummaryLine(label: '检查时间', value: controller.timeText),
          _SummaryLine(label: '上传要求', value: '请按检查项上传对应影像资料'),
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
  final SpotInspectionEditableItemModel item;
  final SpotInspectionFillController controller;

  @override
  Widget build(BuildContext context) {
    return AppStandardCard(
      padding: EdgeInsets.all(AppDimens.dp16),
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppDimens.dp30,
                height: AppDimens.dp30,
                decoration: BoxDecoration(
                  color: const Color(0xFF06BFCC).withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(AppDimens.dp10),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${index + 1}'.padLeft(2, '0'),
                  style: TextStyle(
                    color: const Color(0xFF06BFCC),
                    fontSize: AppDimens.sp12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: AppDimens.dp10),
              Expanded(
                child: Text(
                  '检查项：${item.checkItemName}',
                  style: TextStyle(
                    color: const Color(0xFF25322F),
                    fontSize: AppDimens.sp14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimens.dp12),
          InkWell(
            onTap: () => _showCheckDescribeDialog(context, item),
            borderRadius: BorderRadius.circular(AppDimens.dp12),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppDimens.dp12),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F9FD),
                borderRadius: BorderRadius.circular(AppDimens.dp12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '检查说明',
                    style: TextStyle(
                      color: const Color(0xFF9EACAE),
                      fontSize: AppDimens.sp12,
                    ),
                  ),
                  SizedBox(width: AppDimens.dp12),
                  Expanded(
                    child: Text(
                      item.checkDescribe,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: const Color(0xFF6C8185),
                        fontSize: AppDimens.sp12,
                        height: 1.45,
                      ),
                    ),
                  ),
                  SizedBox(width: AppDimens.dp10),
                  Container(
                    width: AppDimens.dp24,
                    height: AppDimens.dp24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF06BFCC).withValues(alpha: 0.16),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: Color(0xFF06BFCC),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppDimens.dp10),
          _FormLine(
            label: '是否合格',
            child: Wrap(
              spacing: AppDimens.dp10,
              runSpacing: AppDimens.dp10,
              children: [
                _CheckChoiceChip(
                  label: '是',
                  selected: item.pass,
                  selectedColor: const Color(0xFF06BFCC),
                  selectedBgColor: const Color(0xFFE8FBFC),
                  onTap: () => controller.updateItemPass(index, true),
                ),
                _CheckChoiceChip(
                  label: '否',
                  selected: !item.pass,
                  selectedColor: const Color(0xFFFF6A59),
                  selectedBgColor: const Color(0xFFFFEFEC),
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
                isDense: true,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 62,
                child: Padding(
                  padding: EdgeInsets.only(top: AppDimens.dp8),
                  child: Text(
                    '${item.checkMethod == '2' ? '视频' : '照片'}：',
                    style: TextStyle(
                      color: const Color(0xFF92A8AB),
                      fontSize: AppDimens.sp12,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: CustomPickerPhoto(
                  title: item.checkMethod == '2' ? '上传视频' : '上传图片',
                  isShowTitle: false,
                  mediaType: item.checkMethod == '2'
                      ? CustomPickerMediaType.video
                      : CustomPickerMediaType.image,
                  maxCount: item.checkMethod == '2' ? 1 : 3,
                  maxFileSizeBytes: item.checkMethod == '2'
                      ? CustomPickerPhoto.defaultMaxVideoSizeBytes
                      : CustomPickerPhoto.defaultMaxImageSizeBytes,
                  imagesList: item.checkFile
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList(),
                  callback: (value) =>
                      controller.updateItemPhotos(index, value),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showCheckDescribeDialog(
    BuildContext context,
    SpotInspectionEditableItemModel item,
  ) async {
    final detail = await controller.getCheckItemDetail(item.id);
    if (detail == null) return;

    if (!context.mounted) return;

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CheckItemDetailSheet(item: item, detail: detail),
    );
  }
}

class _CheckItemDetailSheet extends StatelessWidget {
  const _CheckItemDetailSheet({required this.item, required this.detail});

  final SpotInspectionEditableItemModel item;
  final SpotInspectionCheckItemModel detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: const Color(0xFFF7FBFB),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimens.dp24),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: AppDimens.dp10),
          Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFD8E2EA),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppDimens.dp16,
              AppDimens.dp14,
              AppDimens.dp16,
              AppDimens.dp12,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.checkItemName,
                    style: TextStyle(
                      color: const Color(0xFF22303C),
                      fontSize: AppDimens.sp16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                AppDimens.dp16,
                0,
                AppDimens.dp16,
                AppDimens.dp24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if ((detail.checkFile ?? '').trim().isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(bottom: AppDimens.dp14),
                      child: _SheetMediaCard(
                        mediaValue: detail.checkFile ?? '',
                        isVideo: (detail.checkMethod ?? '').trim() == '2',
                      ),
                    ),
                  AppStandardCard(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.all(AppDimens.dp16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '检查说明',
                          style: TextStyle(
                            color: const Color(0xFF22303C),
                            fontSize: AppDimens.sp14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: AppDimens.dp12),
                        Text(
                          (detail.checkDescribe ?? '').trim().isEmpty
                              ? '暂无内容'
                              : detail.checkDescribe!,
                          style: TextStyle(
                            color: const Color(0xFF38515D),
                            fontSize: AppDimens.sp13,
                            height: 1.7,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetMediaCard extends StatelessWidget {
  const _SheetMediaCard({required this.mediaValue, required this.isVideo});

  final String mediaValue;
  final bool isVideo;

  @override
  Widget build(BuildContext context) {
    final items = mediaValue
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty && e.toLowerCase() != 'null')
        .toList();

    return AppStandardCard(
      backgroundColor: Colors.white,
      padding: EdgeInsets.all(AppDimens.dp12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isVideo ? '检查视频' : '检查图片',
            style: TextStyle(
              color: const Color(0xFF22303C),
              fontSize: AppDimens.sp14,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppDimens.dp12),
          Wrap(
            spacing: AppDimens.dp10,
            runSpacing: AppDimens.dp10,
            children: items
                .map(
                  (value) => _SheetMediaThumb(
                    url: FileService.getFaceUrl(value) ?? '',
                    isVideo: isVideo,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _SheetMediaThumb extends StatelessWidget {
  const _SheetMediaThumb({required this.url, required this.isVideo});

  final String url;
  final bool isVideo;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => FileService.openFile(url, title: isVideo ? '检查视频' : '检查图片'),
      borderRadius: BorderRadius.circular(AppDimens.dp14),
      child: isVideo
          ? Container(
              width: 108,
              height: 108,
              decoration: BoxDecoration(
                color: const Color(0xFFEEF5FF),
                borderRadius: BorderRadius.circular(AppDimens.dp14),
                border: Border.all(color: const Color(0xFFD9E6FF)),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.videocam_rounded,
                    color: Color(0xFF4B6BFB),
                    size: 28,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '点击查看',
                    style: TextStyle(color: Color(0xFF4B6BFB), fontSize: 12),
                  ),
                ],
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.dp14),
              child: Image.network(
                url,
                width: 108,
                height: 108,
                headers: FileService.imageHeaders(),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 108,
                  height: 108,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F3F8),
                    borderRadius: BorderRadius.circular(AppDimens.dp14),
                    border: Border.all(color: const Color(0xFFDCE4EF)),
                  ),
                  child: const Icon(Icons.broken_image_outlined),
                ),
              ),
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

class _CheckChoiceChip extends StatelessWidget {
  const _CheckChoiceChip({
    required this.label,
    required this.selected,
    required this.selectedColor,
    required this.selectedBgColor,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color selectedColor;
  final Color selectedBgColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.dp14,
          vertical: AppDimens.dp10,
        ),
        decoration: BoxDecoration(
          color: selected ? selectedBgColor : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? selectedColor : const Color(0xFFD9E4E7),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              size: 18,
              color: selected ? selectedColor : const Color(0xFFB6C0CF),
            ),
            SizedBox(width: AppDimens.dp6),
            Text(
              label,
              style: TextStyle(
                color: selected ? selectedColor : const Color(0xFF47596A),
                fontSize: AppDimens.sp12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomResultCard extends StatelessWidget {
  const _BottomResultCard({
    required this.label,
    required this.hint,
    required this.selected,
    required this.selectedColor,
    required this.selectedBgColor,
    required this.onTap,
  });

  final String label;
  final String hint;
  final bool selected;
  final Color selectedColor;
  final Color selectedBgColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.dp14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.all(AppDimens.dp12),
        decoration: BoxDecoration(
          color: selected ? selectedBgColor : Colors.white,
          borderRadius: BorderRadius.circular(AppDimens.dp14),
          border: Border.all(
            color: selected ? selectedColor : const Color(0xFFD9E4E7),
            width: selected ? 1.6 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: selectedColor.withValues(alpha: 0.10),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  selected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: 18,
                  color: selected ? selectedColor : const Color(0xFFB6C0CF),
                ),
                SizedBox(width: AppDimens.dp6),
                Text(
                  label,
                  style: TextStyle(
                    color: selected ? selectedColor : const Color(0xFF334452),
                    fontSize: AppDimens.sp13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppDimens.dp6),
            Text(
              hint,
              style: TextStyle(
                color: const Color(0xFF839399),
                fontSize: AppDimens.sp11,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
