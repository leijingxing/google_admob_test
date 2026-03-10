import 'package:flutter/material.dart';

import '../../../../../../core/components/app_standard_card.dart';
import '../../../../../../core/components/custom_refresh.dart';
import '../../../../../../core/constants/dimens.dart';
import '../../../../../../core/utils/file_service.dart';
import '../../../../../../data/models/workbench/risk_warning_record_item_model.dart';
import 'appointment_approval_detail_controller.dart';

/// 违规记录
class ViolationDetailSection extends StatelessWidget {
  const ViolationDetailSection({super.key, required this.controller});

  final AppointmentApprovalDetailController controller;

  @override
  Widget build(BuildContext context) {
    return CustomEasyRefreshList<RiskWarningRecordItemModel>(
      key: ValueKey('violation-${controller.item.id ?? ''}'),
      pageSize: 20,
      dataLoader: controller.loadViolationPage,
      padding: EdgeInsets.fromLTRB(
        AppDimens.dp12,
        AppDimens.dp2,
        AppDimens.dp12,
        AppDimens.dp12,
      ),
      itemBuilder: (context, item, index) {
        final type = _display(item.subModuleTypeName);
        final time = _display(item.warningStartTime);
        final position = _display(item.positionDescription ?? item.position);
        final desc = _display(item.description ?? item.abnormalDesc);
        final imageUrl = FileService.getFaceUrl(item.warningFileUrl);
        final title = _display(item.title);
        final warningLevel = _warningLevelText(item.warningLevel);
        final warningStatus = _warningStatusText(item.warningStatus);
        final warningType = _warningTypeText(item.warningType);
        final targetValue = _display(item.targetValue ?? item.carNum);

        return Padding(
          padding: EdgeInsets.only(bottom: AppDimens.dp10),
          child: AppStandardCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title == '--' ? type : '$type / $title',
                        style: TextStyle(
                          color: const Color(0xFFD14E34),
                          fontSize: AppDimens.sp12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Color(0xFF6D7B8E),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppDimens.dp8),
                Wrap(
                  spacing: AppDimens.dp8,
                  runSpacing: AppDimens.dp8,
                  children: [
                    _TagChip(
                      text: warningType,
                      color: const Color(0xFFFFF1ED),
                      textColor: const Color(0xFFD14E34),
                    ),
                    _TagChip(
                      text: warningStatus,
                      color: const Color(0xFFEFF6FF),
                      textColor: const Color(0xFF2563EB),
                    ),
                    if (warningLevel != '--')
                      _TagChip(
                        text: warningLevel,
                        color: const Color(0xFFFFF7E6),
                        textColor: const Color(0xFFB76E00),
                      ),
                  ],
                ),
                SizedBox(height: AppDimens.dp8),
                if (targetValue != '--') ...[
                  Text(
                    '姓名/车牌：$targetValue',
                    style: TextStyle(
                      color: const Color(0xFF2F3E50),
                      fontSize: AppDimens.sp12,
                    ),
                  ),
                  SizedBox(height: AppDimens.dp6),
                ],
                Text(
                  '违规地点：$position',
                  style: TextStyle(
                    color: const Color(0xFF2F3E50),
                    fontSize: AppDimens.sp12,
                  ),
                ),
                SizedBox(height: AppDimens.dp6),
                Text(
                  '违规内容：$desc',
                  style: TextStyle(
                    color: const Color(0xFF4F5E73),
                    fontSize: AppDimens.sp12,
                  ),
                ),
                if (_display(item.remark) != '--') ...[
                  SizedBox(height: AppDimens.dp6),
                  Text(
                    '备注：${_display(item.remark)}',
                    style: TextStyle(
                      color: const Color(0xFF4F5E73),
                      fontSize: AppDimens.sp12,
                    ),
                  ),
                ],
                if (imageUrl != null) ...[
                  SizedBox(height: AppDimens.dp8),
                  _ViolationMediaCard(label: '违规影像', fileUrl: imageUrl),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  String _display(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? '--' : text;
  }

  String _warningLevelText(int value) {
    switch (value) {
      case 1:
        return '红色';
      case 2:
        return '橙色';
      case 3:
        return '黄色';
      case 4:
        return '蓝色';
      case 0:
        return '--';
      default:
        return '--';
    }
  }

  String _warningTypeText(int value) {
    switch (value) {
      case 1:
        return '预警';
      case 2:
        return '报警';
      case 3:
        return '事故';
      case 4:
        return '事件';
      default:
        return '违规记录';
    }
  }

  String _warningStatusText(int value) {
    switch (value) {
      case 0:
        return '正在持续';
      case 1:
        return '已销警';
      default:
        return '状态未知';
    }
  }
}

class _ViolationMediaCard extends StatelessWidget {
  const _ViolationMediaCard({required this.label, required this.fileUrl});

  final String label;
  final String fileUrl;

  @override
  Widget build(BuildContext context) {
    final isImage = FileService.isImageFile(fileUrl);
    final isVideo = FileService.isVideoFile(fileUrl);
    final icon = isVideo
        ? Icons.play_circle_fill_rounded
        : Icons.image_outlined;
    final tagText = isVideo ? '视频' : '图片';

    return GestureDetector(
      onTap: () => FileService.openFile(fileUrl, title: label),
      child: Container(
        width: AppDimens.dp112,
        padding: EdgeInsets.all(AppDimens.dp6),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F9FD),
          borderRadius: BorderRadius.circular(AppDimens.dp10),
          border: Border.all(color: const Color(0xFFE1E8F2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xFF5E6C80),
                      fontSize: AppDimens.sp11,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimens.dp6,
                    vertical: AppDimens.dp2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF1FF),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    tagText,
                    style: TextStyle(
                      color: const Color(0xFF2C62D5),
                      fontSize: AppDimens.sp10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppDimens.dp6),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.dp8),
              child: SizedBox(
                width: double.infinity,
                height: 68,
                child: isImage
                    ? Image.network(
                        fileUrl,
                        headers: FileService.imageHeaders(),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _ViolationMediaFallback(icon: icon),
                      )
                    : _ViolationMediaFallback(icon: icon),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ViolationMediaFallback extends StatelessWidget {
  const _ViolationMediaFallback({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEFF4FB),
      alignment: Alignment.center,
      child: Icon(icon, size: 28, color: const Color(0xFF7B8DA6)),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.text,
    required this.color,
    required this.textColor,
  });

  final String text;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp8,
        vertical: AppDimens.dp4,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: AppDimens.sp11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
