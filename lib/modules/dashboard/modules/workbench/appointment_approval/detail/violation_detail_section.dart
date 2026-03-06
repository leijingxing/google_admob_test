import 'package:flutter/material.dart';

import '../../../../../../core/components/app_standard_card.dart';
import '../../../../../../core/components/custom_refresh.dart';
import '../../../../../../core/constants/dimens.dart';
import '../../../../../../core/utils/file_service.dart';
import 'appointment_approval_detail_controller.dart';

/// 违规记录
class ViolationDetailSection extends StatelessWidget {
  const ViolationDetailSection({super.key, required this.controller});

  final AppointmentApprovalDetailController controller;

  @override
  Widget build(BuildContext context) {
    return CustomEasyRefreshList<Map<String, dynamic>>(
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
        final type = (item['subModuleTypeName'] ?? '--').toString();
        final time = (item['createDate'] ?? '--').toString();
        final position = (item['position'] ?? '--').toString();
        final desc = (item['description'] ?? '--').toString();
        final imageUrl = FileService.getFaceUrl(item['fileUrl']?.toString());

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
                        type,
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
                if (imageUrl != null) ...[
                  SizedBox(height: AppDimens.dp8),
                  Text(
                    '违规影像',
                    style: TextStyle(
                      color: const Color(0xFF6D7B8E),
                      fontSize: AppDimens.sp11,
                    ),
                  ),
                  SizedBox(height: AppDimens.dp4),
                  GestureDetector(
                    onTap: () => FileService.openFile(imageUrl, title: '违规影像'),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppDimens.dp6),
                      child: SizedBox(
                        width: AppDimens.dp96,
                        height: AppDimens.dp60,
                        child: Image.network(
                          imageUrl,
                          headers: FileService.imageHeaders(),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: const Color(0xFFF0F4FA),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.broken_image_outlined,
                                  size: 18,
                                ),
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
