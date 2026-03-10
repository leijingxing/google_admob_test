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
    final isPersonReservation = controller.isPersonReservation;
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
                Container(
                  padding: EdgeInsets.all(AppDimens.dp10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF4F8FF), Color(0xFFEAF1FF)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(AppDimens.dp10),
                    border: Border.all(color: const Color(0xFFD8E4FA)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: AppDimens.dp34,
                        height: AppDimens.dp34,
                        decoration: const BoxDecoration(
                          color: Color(0xFF3A78F2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.timeline_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      SizedBox(width: AppDimens.dp10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '通行时间段',
                              style: TextStyle(
                                color: const Color(0xFF5A6B82),
                                fontSize: AppDimens.sp11,
                              ),
                            ),
                            SizedBox(height: AppDimens.dp4),
                            Text(
                              '入园 $startDate  至  出园 $endDate',
                              style: TextStyle(
                                color: const Color(0xFF1F2F42),
                                fontSize: AppDimens.sp13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                  final time =
                      (item['dateTime'] ??
                              item['createDate'] ??
                              item['time'] ??
                              '--')
                          .toString();
                  final violationTypeName = (item['violationTypeName'] ?? '')
                      .toString()
                      .trim();
                  final remark = (item['remark'] ?? '').toString().trim();
                  final headPicUrl = FileService.getFaceUrl(
                    item['headPicUrl']?.toString(),
                  );
                  final tailPicUrl = FileService.getFaceUrl(
                    item['tailPicUrl']?.toString(),
                  );
                  final locationLabel = (typeValue == 3 || typeValue == 4)
                      ? '抓拍地点'
                      : '闸机';
                  return Container(
                    margin: EdgeInsets.only(bottom: AppDimens.dp8),
                    padding: EdgeInsets.all(AppDimens.dp12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppDimens.dp10),
                      border: Border.all(color: const Color(0xFFE4EAF3)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0A243447),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: AppDimens.dp2),
                              width: AppDimens.dp10,
                              height: AppDimens.dp10,
                              decoration: const BoxDecoration(
                                color: Color(0xFF3A78F2),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: AppDimens.dp8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: AppDimens.dp8,
                                          vertical: AppDimens.dp3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEAF1FF),
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                        ),
                                        child: Text(
                                          type,
                                          style: TextStyle(
                                            color: const Color(0xFF2C62D5),
                                            fontSize: AppDimens.sp11,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: AppDimens.dp8),
                                      Expanded(
                                        child: Text(
                                          time,
                                          style: TextStyle(
                                            color: const Color(0xFF7A8798),
                                            fontSize: AppDimens.sp11,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: AppDimens.dp10),
                                  _RecordInfoRow(
                                    icon: typeValue == 3 || typeValue == 4
                                        ? Icons.place_outlined
                                        : Icons.meeting_room_outlined,
                                    label: locationLabel,
                                    value: address,
                                  ),
                                  if (violationTypeName.isNotEmpty) ...[
                                    SizedBox(height: AppDimens.dp8),
                                    _RecordInfoRow(
                                      icon: Icons.warning_amber_rounded,
                                      label: '违规类型',
                                      value: violationTypeName,
                                    ),
                                  ],
                                  if (remark.isNotEmpty) ...[
                                    SizedBox(height: AppDimens.dp8),
                                    _RecordInfoRow(
                                      icon: Icons.notes_rounded,
                                      label: '备注',
                                      value: remark,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (headPicUrl != null || tailPicUrl != null) ...[
                          SizedBox(height: AppDimens.dp12),
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: const Color(0xFFE8EEF7),
                          ),
                          SizedBox(height: AppDimens.dp8),
                          Wrap(
                            spacing: AppDimens.dp8,
                            runSpacing: AppDimens.dp8,
                            children: [
                              if (headPicUrl != null)
                                _RecordMediaCard(
                                  label: isPersonReservation ? '人员照片' : '车头影像',
                                  fileUrl: headPicUrl,
                                ),
                              if (tailPicUrl != null)
                                _RecordMediaCard(
                                  label: isPersonReservation ? '人员照片' : '车尾影像',
                                  fileUrl: tailPicUrl,
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

class _RecordInfoRow extends StatelessWidget {
  const _RecordInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF7C8CA1)),
        SizedBox(width: AppDimens.dp6),
        Text(
          '$label：',
          style: TextStyle(
            color: const Color(0xFF6D7B8E),
            fontSize: AppDimens.sp12,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: const Color(0xFF1E2E42),
              fontSize: AppDimens.sp12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _RecordMediaCard extends StatelessWidget {
  const _RecordMediaCard({required this.label, required this.fileUrl});

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
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            fileUrl,
                            headers: FileService.imageHeaders(),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _RecordMediaFallback(icon: icon),
                          ),
                          if (isVideo)
                            const Center(
                              child: Icon(
                                Icons.play_circle_fill_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                        ],
                      )
                    : _RecordMediaFallback(icon: icon),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecordMediaFallback extends StatelessWidget {
  const _RecordMediaFallback({required this.icon});

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
