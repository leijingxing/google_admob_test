import 'package:flutter/material.dart';

import '../../../../../../core/components/app_standard_card.dart';
import '../../../../../../core/constants/dimens.dart';
import '../../../../../../core/utils/file_service.dart';
import 'appointment_approval_detail_controller.dart';

/// 基本信息
class BasicInfoDetailSection extends StatelessWidget {
  const BasicInfoDetailSection({super.key, required this.controller});

  final AppointmentApprovalDetailController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.basicLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (controller.progressTimeline.isEmpty) {
      return const Center(child: Text('暂无基本信息'));
    }
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
        AppDimens.dp12,
        AppDimens.dp2,
        AppDimens.dp12,
        AppDimens.dp12,
      ),
      itemCount: controller.progressTimeline.length,
      itemBuilder: (context, index) {
        final node = controller.progressTimeline[index];
        final typeCode = node['typeCode'] as int?;
        final groups = controller.timelineDisplayGroups(node);
        final title = controller.timelineTypeText(typeCode);
        final timeText = (node['time'] ?? '--').toString();
        final hideGroupTitle = typeCode == 1 || typeCode == 2;
        return Padding(
          padding: EdgeInsets.only(bottom: AppDimens.dp10),
          child: AppStandardCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF3A78F2),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: AppDimens.dp6),
                    Expanded(
                      child: Text(
                        '$title  $timeText',
                        style: TextStyle(
                          color: const Color(0xFF243447),
                          fontSize: AppDimens.sp12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppDimens.dp10),
                if (groups.isEmpty)
                  Text(
                    '暂无字段信息',
                    style: TextStyle(
                      color: const Color(0xFF9AA7B8),
                      fontSize: AppDimens.sp12,
                    ),
                  )
                else
                  ...groups.map((group) {
                    return Container(
                      margin: EdgeInsets.only(bottom: AppDimens.dp8),
                      padding: EdgeInsets.all(AppDimens.dp10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F9FD),
                        borderRadius: BorderRadius.circular(AppDimens.dp8),
                        border: Border.all(color: const Color(0xFFE4EAF3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!hideGroupTitle) ...[
                            Text(
                              group.title,
                              style: TextStyle(
                                color: const Color(0xFF245FD0),
                                fontSize: AppDimens.sp12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: AppDimens.dp8),
                          ],
                          ...group.lines.map((line) {
                            // 控制器会插入空行作为组内分隔标记，这里渲染成细分割线。
                            if (line.label.isEmpty && line.value.isEmpty) {
                              return Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: AppDimens.dp6,
                                ),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Color(0xFFDCE4F0),
                                      width: 1,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return Padding(
                              padding: EdgeInsets.only(bottom: AppDimens.dp8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: AppDimens.dp112,
                                    child: Text(
                                      '${line.label}：',
                                      style: TextStyle(
                                        color: const Color(0xFF6E7B8F),
                                        fontSize: AppDimens.sp12,
                                      ),
                                    ),
                                  ),
                                  Expanded(child: _buildValueWidget(line)),
                                ],
                              ),
                            );
                          }),
                        ],
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

  Widget _buildValueWidget(DetailLine line) {
    if (!_isImageField(line.label)) {
      return Text(
        line.value,
        style: TextStyle(
          color: const Color(0xFF1E2E42),
          fontSize: AppDimens.sp12,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    // 图片类字段可能携带多个文件标识，按逗号拆分后渲染为缩略图列表。
    final urls = line.value
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty && e != '-' && e.toLowerCase() != 'null')
        .toList();
    if (urls.isEmpty) {
      return Text(
        '-',
        style: TextStyle(
          color: const Color(0xFF1E2E42),
          fontSize: AppDimens.sp12,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return Wrap(
      spacing: AppDimens.dp8,
      runSpacing: AppDimens.dp8,
      children: urls.map((url) {
        final fullUrl = FileService.getFaceUrl(url);
        if (fullUrl == null) {
          return Container(
            width: AppDimens.dp88,
            height: AppDimens.dp56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4FA),
              borderRadius: BorderRadius.circular(AppDimens.dp6),
            ),
            child: const Text('-'),
          );
        }
        return ClipRRect(
          borderRadius: BorderRadius.circular(AppDimens.dp6),
          child: Container(
            width: AppDimens.dp88,
            height: AppDimens.dp56,
            color: const Color(0xFFF0F4FA),
            child: InkWell(
              onTap: () => FileService.openFile(fullUrl, title: line.label),
              child: Image.network(
                fullUrl,
                headers: FileService.imageHeaders(),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.broken_image_outlined, size: 18),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  bool _isImageField(String label) {
    const imageLabels = <String>{
      '行驶证',
      '挂车行驶证',
      '正脸照片',
      '驾驶证',
      '道路危险货物驾驶人员从业资格证',
      '道路危险货物押运人员从业资格证',
    };
    return imageLabels.contains(label) || label.contains('电子运单');
  }
}
