import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../core/components/app_standard_card.dart';
import '../../../../../../../core/constants/dimens.dart';
import '../../../../../../../core/utils/file_service.dart';
import 'park_inspection_record_detail_controller.dart';

class ParkInspectionRecordDetailView
    extends GetView<ParkInspectionRecordDetailController> {
  const ParkInspectionRecordDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParkInspectionRecordDetailController>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: const Text('细则检查结果')),
          backgroundColor: const Color(0xFFF4F7FB),
          body: logic.loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                  padding: EdgeInsets.all(AppDimens.dp12),
                  itemCount: logic.details.length,
                  separatorBuilder: (_, _) => SizedBox(height: AppDimens.dp10),
                  itemBuilder: (context, index) {
                    final item = logic.details[index];
                    return AppStandardCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.ruleName ?? item.ruleId ?? '--',
                            style: TextStyle(
                              color: const Color(0xFF223146),
                              fontSize: AppDimens.sp14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: AppDimens.dp8),
                          _InfoLine(
                            label: '检查结果',
                            value: logic.resultText(item.resultStatus),
                          ),
                          _InfoLine(label: '备注', value: item.remark ?? '--'),
                          _AttachmentPreview(
                            ids: item.attachments ?? const <String>[],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

class _AttachmentPreview extends StatelessWidget {
  const _AttachmentPreview({required this.ids});

  final List<String> ids;

  @override
  Widget build(BuildContext context) {
    if (ids.isEmpty) {
      return const Text('--');
    }
    return Wrap(
      spacing: AppDimens.dp8,
      runSpacing: AppDimens.dp8,
      children: ids.map((id) {
        final imageUrl = FileService.getFaceUrl(id);
        return InkWell(
          onTap: imageUrl == null
              ? null
              : () => FileService.openFile(imageUrl, title: '附件预览'),
          child: Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FB),
              borderRadius: BorderRadius.circular(AppDimens.dp10),
              border: Border.all(color: const Color(0xFFE2E8F2)),
            ),
            child: imageUrl == null
                ? const Icon(Icons.image_not_supported_outlined)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimens.dp10),
                    child: Image.network(
                      imageUrl,
                      headers: FileService.imageHeaders(),
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          const Icon(Icons.broken_image_outlined),
                    ),
                  ),
          ),
        );
      }).toList(),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value});

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
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
