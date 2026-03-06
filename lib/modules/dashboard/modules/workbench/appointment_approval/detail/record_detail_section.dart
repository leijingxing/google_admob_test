import 'package:flutter/material.dart';

import '../../../../../../core/components/app_standard_card.dart';
import '../../../../../../core/constants/dimens.dart';
import '../../../../../../core/utils/file_service.dart';
import 'appointment_approval_detail_controller.dart';

/// 出入记录
class RecordDetailSection extends StatelessWidget {
  const RecordDetailSection({super.key, required this.controller});

  final AppointmentApprovalDetailController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.recordLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (controller.gateRecords.isEmpty) {
      return const Center(child: Text('暂无出入记录'));
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
        AppDimens.dp12,
        AppDimens.dp2,
        AppDimens.dp12,
        AppDimens.dp12,
      ),
      itemCount: controller.gateRecords.length,
      itemBuilder: (context, index) {
        final section = controller.gateRecords[index];
        final startDate = (section['startDate'] ?? '-').toString();
        final endDate = (section['endDate'] ?? '-').toString();
        final eventsRaw = section['data'];
        final events = eventsRaw is List ? eventsRaw : const <dynamic>[];

        return Padding(
          padding: EdgeInsets.only(bottom: AppDimens.dp10),
          child: AppStandardCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '入园/$startDate  -  出园/$endDate',
                  style: TextStyle(
                    color: const Color(0xFF1F2F42),
                    fontSize: AppDimens.sp12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppDimens.dp10),
                ...events.map((e) {
                  final item = e is Map
                      ? Map<String, dynamic>.from(e)
                      : const <String, dynamic>{};
                  final typeValue = item['type'] as int?;
                  final type = controller.recordTypeText(typeValue);
                  final address = (item['address'] ?? '--').toString();
                  final time = (item['createDate'] ?? item['time'] ?? '--')
                      .toString();
                  final headPicUrl = FileService.getFaceUrl(
                    item['headPicUrl']?.toString(),
                  );
                  final tailPicUrl = FileService.getFaceUrl(
                    item['tailPicUrl']?.toString(),
                  );
                  final locationLabel = typeValue == 3 ? '抓拍地点' : '闸机';
                  return Container(
                    margin: EdgeInsets.only(bottom: AppDimens.dp8),
                    padding: EdgeInsets.all(AppDimens.dp10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F8FC),
                      borderRadius: BorderRadius.circular(AppDimens.dp8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          type,
                          style: TextStyle(
                            color: const Color(0xFF2C62D5),
                            fontSize: AppDimens.sp12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: AppDimens.dp4),
                        Text(
                          '$locationLabel：$address',
                          style: TextStyle(
                            color: const Color(0xFF3C4A5C),
                            fontSize: AppDimens.sp12,
                          ),
                        ),
                        SizedBox(height: AppDimens.dp4),
                        Text(
                          '时间：$time',
                          style: const TextStyle(
                            color: Color(0xFF6D7B8E),
                            fontSize: 11,
                          ),
                        ),
                        if (headPicUrl != null || tailPicUrl != null) ...[
                          SizedBox(height: AppDimens.dp8),
                          Wrap(
                            spacing: AppDimens.dp8,
                            runSpacing: AppDimens.dp8,
                            children: [
                              if (headPicUrl != null)
                                _RecordImageCard(
                                  label: typeValue == 2 ? '出园影像' : '入园影像',
                                  imageUrl: headPicUrl,
                                ),
                              if (tailPicUrl != null)
                                _RecordImageCard(
                                  label: typeValue == 2 ? '出园影像' : '入园影像',
                                  imageUrl: tailPicUrl,
                                ),
                            ],
                          ),
                        ],
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
}

class _RecordImageCard extends StatelessWidget {
  const _RecordImageCard({required this.label, required this.imageUrl});

  final String label;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF6D7B8E),
            fontSize: AppDimens.sp11,
          ),
        ),
        SizedBox(height: AppDimens.dp4),
        GestureDetector(
          onTap: () => FileService.openFile(imageUrl, title: label),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppDimens.dp6),
            child: SizedBox(
              width: AppDimens.dp96,
              height: AppDimens.dp60,
              child: Image.network(
                imageUrl,
                headers: FileService.imageHeaders(),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFFF0F4FA),
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image_outlined, size: 18),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
