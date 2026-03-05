import 'package:flutter/material.dart';

import '../../../../../../core/components/app_standard_card.dart';
import '../../../../../../core/components/custom_refresh.dart';
import '../../../../../../core/constants/dimens.dart';
import 'appointment_approval_detail_controller.dart';

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
              ],
            ),
          ),
        );
      },
    );
  }
}
