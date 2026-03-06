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
          backgroundColor: const Color(0xFFF7FBFB),
          body: logic.loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    AppDimens.dp16,
                    AppDimens.dp14,
                    AppDimens.dp16,
                    AppDimens.dp24,
                  ),
                  child: Column(
                    children: [
                      _DetailHeader(logic: logic),
                      SizedBox(height: AppDimens.dp14),
                      ...logic.items.asMap().entries.map((entry) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: AppDimens.dp14),
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

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({required this.logic});

  final SpotInspectionDetailController logic;

  @override
  Widget build(BuildContext context) {
    final result = logic.resultText(logic.overallResult);
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
                  logic.carNumbText,
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
                  color: result == '通过'
                      ? const Color(0xFF06BFCC)
                      : const Color(0xFFFF6A59),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  result == '通过' ? '抽检通过' : '抽检不通过',
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
            logic.checkInfoText,
            style: TextStyle(
              color: const Color(0xFF98A9AB),
              fontSize: AppDimens.sp12,
            ),
          ),
          SizedBox(height: AppDimens.dp14),
          Container(height: 1, color: const Color(0xFFC5D9DA)),
          SizedBox(height: AppDimens.dp14),
          _SummaryLine(label: '检查模板', value: logic.templateText),
          _SummaryLine(label: '检查时间', value: logic.timeText),
          _SummaryLine(label: '检查人员', value: logic.checkerText),
          _SummaryLine(label: '检查结果', value: result, isResult: true),
        ],
      ),
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
      backgroundColor: Colors.white,
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
          _ItemLine(label: '备注', value: _remarkText(item)),
          _MediaLine(
            mediaValue: item.checkFile ?? '',
            isVideo: (item.checkMethod ?? '').trim() == '2',
          ),
        ],
      ),
    );
  }

  String _remarkText(SpotInspectionCheckItemModel item) {
    final text = (item.remark ?? item.remarks ?? '').trim();
    return text.isEmpty ? '--' : text;
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

class _MediaLine extends StatelessWidget {
  const _MediaLine({required this.mediaValue, required this.isVideo});

  final String mediaValue;
  final bool isVideo;

  @override
  Widget build(BuildContext context) {
    final list = mediaValue
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
            '${isVideo ? '视频' : '照片'}：',
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
                        (url) => _MediaThumb(
                          url: FileService.getFaceUrl(url) ?? '',
                          isVideo: isVideo,
                        ),
                      )
                      .toList(),
                ),
        ),
      ],
    );
  }
}

class _MediaThumb extends StatelessWidget {
  const _MediaThumb({required this.url, required this.isVideo});

  final String url;
  final bool isVideo;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => FileService.openFile(url, title: isVideo ? '检查视频' : '检查照片'),
      child: isVideo
          ? Container(
              width: 82,
              height: 82,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFEEF5FF),
                borderRadius: BorderRadius.circular(AppDimens.dp10),
                border: Border.all(color: const Color(0xFFD9E6FF)),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.videocam_outlined,
                    color: Color(0xFF4B6BFB),
                    size: 24,
                  ),
                  SizedBox(height: 6),
                  Text(
                    '点击查看',
                    style: TextStyle(color: Color(0xFF4B6BFB), fontSize: 12),
                  ),
                ],
              ),
            )
          : ClipRRect(
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
