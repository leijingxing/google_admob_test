import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/constants/dimens.dart';
import 'appointment_approval_detail_controller.dart';
import 'basic_info_detail_section.dart';
import 'record_detail_section.dart';
import 'violation_detail_section.dart';

/// 预约审批详情页。
class AppointmentApprovalDetailView
    extends GetView<AppointmentApprovalDetailController> {
  const AppointmentApprovalDetailView({super.key});

  @override
  /// 构建详情页整体布局，顶部为分栏切换，底部为内容区。
  Widget build(BuildContext context) {
    return GetBuilder<AppointmentApprovalDetailController>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: const Text('预约详情')),
          body: Column(
            children: [
              _SectionTabs(controller: logic),
              Expanded(child: _SectionBody(controller: logic)),
            ],
          ),
        );
      },
    );
  }
}

/// 顶部分栏切换区域。
class _SectionTabs extends StatelessWidget {
  const _SectionTabs({required this.controller});

  final AppointmentApprovalDetailController controller;

  /// 构建“基本信息 / 出入记录 / 违规记录”切换按钮。
  @override
  Widget build(BuildContext context) {
    const labels = ['基本信息', '出入记录', '违规记录'];
    return Container(
      margin: EdgeInsets.fromLTRB(
        AppDimens.dp12,
        AppDimens.dp10,
        AppDimens.dp12,
        AppDimens.dp8,
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final selected = controller.currentSection == index;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index == labels.length - 1 ? 0 : 8,
              ),
              child: OutlinedButton(
                onPressed: () => controller.onSectionChanged(index),
                style: OutlinedButton.styleFrom(
                  backgroundColor: selected
                      ? const Color(0xFF3A78F2)
                      : Colors.white,
                  side: BorderSide(
                    color: selected
                        ? const Color(0xFF3A78F2)
                        : const Color(0xFFBFD0EE),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.dp8),
                  ),
                ),
                child: Text(
                  labels[index],
                  style: TextStyle(
                    color: selected ? Colors.white : const Color(0xFF2E4F87),
                    fontSize: AppDimens.sp12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// 根据当前分栏切换对应的详情内容。
class _SectionBody extends StatelessWidget {
  const _SectionBody({required this.controller});

  final AppointmentApprovalDetailController controller;

  /// 返回当前选中分栏对应的内容组件。
  @override
  Widget build(BuildContext context) {
    switch (controller.currentSection) {
      case 1:
        return RecordDetailSection(controller: controller);
      case 2:
        return ViolationDetailSection(controller: controller);
      default:
        return BasicInfoDetailSection(controller: controller);
    }
  }
}
