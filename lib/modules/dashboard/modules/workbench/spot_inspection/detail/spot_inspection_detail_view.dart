import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/components/app_standard_card.dart';
import '../../../../../../core/constants/dimens.dart';
import '../../../../../../core/utils/file_service.dart';
import '../../../../../../data/models/workbench/spot_inspection_check_item_model.dart';
import 'spot_inspection_detail_controller.dart';

/// 抽检详情页。
class SpotInspectionDetailView extends GetView<SpotInspectionDetailController> {
  const SpotInspectionDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SpotInspectionDetailController>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: const Text('详情')),
          backgroundColor: const Color(0xFFF5F7FB),
          body: logic.loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    AppDimens.dp12,
                    AppDimens.dp12,
                    AppDimens.dp12,
                    AppDimens.dp24,
                  ),
                  child: Column(
                    children: [
                      AppStandardCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SummaryLine(
                              label: '检查信息',
                              value: logic.checkInfoText,
                            ),
                            _SummaryLine(
                              label: '车牌号',
                              value: logic.carNumbText,
                            ),
                            _SummaryLine(
                              label: '检查模板',
                              value: logic.templateText,
                            ),
                            _SummaryLine(label: '检查时间', value: logic.timeText),
                            _SummaryLine(
                              label: '检查人员',
                              value: logic.checkerText,
                            ),
                            _SummaryLine(
                              label: '检查结果',
                              value: logic.resultText(logic.overallResult),
                              isResult: true,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppDimens.dp12),
                      ...logic.items.asMap().entries.map((entry) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: AppDimens.dp12),
                          child: _DetailInspectionCard(
                            index: entry.key,
                            item: entry.value,
                            controller: logic,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({
    required this.label,
    required this.value,
    this.isResult = false,
  });

  final String label;
  final String value;
  final bool isResult;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimens.dp10),
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
            child: isResult
                ? Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimens.dp10,
                      vertical: AppDimens.dp5,
                    ),
                    decoration: BoxDecoration(
                      color: value == '通过'
                          ? const Color(0xFFE7F8EE)
                          : const Color(0xFFFFF1E8),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      value,
                      style: TextStyle(
                        color: value == '通过'
                            ? const Color(0xFF0E8C4C)
                            : const Color(0xFFDA5A18),
                        fontSize: AppDimens.sp12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                : Text(
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

class _DetailInspectionCard extends StatelessWidget {
  const _DetailInspectionCard({
    required this.index,
    required this.item,
    required this.controller,
  });

  final int index;
  final SpotInspectionCheckItemModel item;
  final SpotInspectionDetailController controller;

  @override
  Widget build(BuildContext context) {
    return AppStandardCard(
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
                  item.checkItemName ?? '--',
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
          _ItemLine(label: '检查说明', value: item.checkDescribe ?? '--'),
          _ItemLine(
            label: '是否合格',
            value: controller.itemResultText(item),
            isResult: true,
          ),
          _ItemLine(
            label: '备注',
            value: (item.remark ?? '').isEmpty ? '--' : item.remark!,
          ),
          _ImageLine(imageValue: item.checkFile ?? ''),
        ],
      ),
    );
  }
}

class _ItemLine extends StatelessWidget {
  const _ItemLine({
    required this.label,
    required this.value,
    this.isResult = false,
  });

  final String label;
  final String value;
  final bool isResult;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimens.dp10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 62,
            child: Text(
              '$label：',
              style: TextStyle(
                color: const Color(0xFF6D7889),
                fontSize: AppDimens.sp12,
              ),
            ),
          ),
          Expanded(
            child: isResult
                ? Text(
                    value,
                    style: TextStyle(
                      color: value == '是'
                          ? const Color(0xFF0E8C4C)
                          : const Color(0xFFDA5A18),
                      fontSize: AppDimens.sp12,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : Text(
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

class _ImageLine extends StatelessWidget {
  const _ImageLine({required this.imageValue});

  final String imageValue;

  @override
  Widget build(BuildContext context) {
    final list = imageValue
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty && e.toLowerCase() != 'null')
        .toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 62,
          child: Text(
            '照片：',
            style: TextStyle(
              color: const Color(0xFF6D7889),
              fontSize: AppDimens.sp12,
            ),
          ),
        ),
        Expanded(
          child: list.isEmpty
              ? Text(
                  '--',
                  style: TextStyle(
                    color: const Color(0xFF1D2B3A),
                    fontSize: AppDimens.sp12,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : Wrap(
                  spacing: AppDimens.dp8,
                  runSpacing: AppDimens.dp8,
                  children: list
                      .map(
                        (url) =>
                            _ImageThumb(url: FileService.getFaceUrl(url) ?? ''),
                      )
                      .toList(),
                ),
        ),
      ],
    );
  }
}

class _ImageThumb extends StatelessWidget {
  const _ImageThumb({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => FileService.openFile(url, title: '检查照片'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.dp10),
        child: Image.network(
          url,
          width: 82,
          height: 82,
          headers: FileService.imageHeaders(),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: 82,
            height: 82,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F3F8),
              borderRadius: BorderRadius.circular(AppDimens.dp10),
              border: Border.all(color: const Color(0xFFDCE4EF)),
            ),
            child: const Icon(Icons.broken_image_outlined),
          ),
        ),
      ),
    );
  }
}
