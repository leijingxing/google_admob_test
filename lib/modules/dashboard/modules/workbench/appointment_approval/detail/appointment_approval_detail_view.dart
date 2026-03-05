import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/components/app_standard_card.dart';
import '../../../../../../core/constants/dimens.dart';
import 'appointment_approval_detail_controller.dart';

/// 预约审批详情页。
class AppointmentApprovalDetailView
    extends GetView<AppointmentApprovalDetailController> {
  const AppointmentApprovalDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppointmentApprovalDetailController>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: const Text('预约详情')),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(AppDimens.dp12),
            child: AppStandardCard(
              child: logic.loading
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : Column(
                      children: logic.buildDetailLines().map((line) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: AppDimens.dp10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: AppDimens.dp92,
                                child: Text(
                                  '${line.label}：',
                                  style: TextStyle(
                                    color: const Color(0xFF7B8798),
                                    fontSize: AppDimens.sp12,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  line.value,
                                  style: TextStyle(
                                    color: const Color(0xFF263547),
                                    fontSize: AppDimens.sp12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ),
        );
      },
    );
  }
}
