import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/components/app_standard_card.dart';
import '../../../../../../core/components/date_picker/custom_date_range_picker.dart';
import '../../../../../../core/constants/dimens.dart';
import 'appointment_approval_approve_controller.dart';

/// 预约审批页。
class AppointmentApprovalApproveView
    extends GetView<AppointmentApprovalApproveController> {
  const AppointmentApprovalApproveView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppointmentApprovalApproveController>(
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(title: const Text('审批')),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(AppDimens.dp12),
            child: Column(
              children: [
                AppStandardCard(
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
                SizedBox(height: AppDimens.dp12),
                AppStandardCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel('授权期限', required: true),
                      SizedBox(height: AppDimens.dp8),
                      CustomDateRangePicker(
                        startDate: logic.validityStart,
                        endDate: logic.validityEnd,
                        onDateRangeSelected: logic.onValidityDateChanged,
                        compact: true,
                      ),
                      SizedBox(height: AppDimens.dp12),
                      _GateSelectorField(
                        title: '授权入口',
                        required: true,
                        areaNames: logic.selectedAreaNames(isIn: true),
                        deviceNames: logic.selectedDeviceNames(isIn: true),
                        loading: logic.gateLoading,
                        onTap: () => _showGatePickerSheet(
                          context: context,
                          logic: logic,
                          isIn: true,
                        ),
                      ),
                      SizedBox(height: AppDimens.dp12),
                      _GateSelectorField(
                        title: '授权出口',
                        required: true,
                        areaNames: logic.selectedAreaNames(isIn: false),
                        deviceNames: logic.selectedDeviceNames(isIn: false),
                        loading: logic.gateLoading,
                        onTap: () => _showGatePickerSheet(
                          context: context,
                          logic: logic,
                          isIn: false,
                        ),
                      ),
                      SizedBox(height: AppDimens.dp12),
                      _fieldLabel('是否抽检', required: true),
                      SizedBox(height: AppDimens.dp4),
                      Switch(
                        value: logic.sampleCheck,
                        onChanged: logic.onSampleCheckChanged,
                      ),
                      SizedBox(height: AppDimens.dp8),
                      _fieldLabel('审批意见'),
                      SizedBox(height: AppDimens.dp8),
                      TextField(
                        controller: logic.parkCheckDescController,
                        minLines: 4,
                        maxLines: 6,
                        maxLength: 200,
                        decoration: const InputDecoration(
                          hintText: '请输入审批意见',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppDimens.dp12,
                AppDimens.dp8,
                AppDimens.dp12,
                AppDimens.dp8,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: logic.submitting ? null : Get.back,
                      child: const Text('取消'),
                    ),
                  ),
                  SizedBox(width: AppDimens.dp8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: logic.submitting
                          ? null
                          : () => logic.submitApproval(parkCheckStatus: 2),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFE05544),
                      ),
                      child: logic.submitting
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('不通过'),
                    ),
                  ),
                  SizedBox(width: AppDimens.dp8),
                  Expanded(
                    child: FilledButton(
                      onPressed: logic.submitting
                          ? null
                          : () => logic.submitApproval(parkCheckStatus: 1),
                      child: logic.submitting
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('通过'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _fieldLabel(String text, {bool required = false}) {
    return Row(
      children: [
        if (required)
          const Text(
            '* ',
            style: TextStyle(
              color: Color(0xFFE55E59),
              fontWeight: FontWeight.w700,
            ),
          ),
        Text(
          text,
          style: TextStyle(
            color: const Color(0xFF2E3B4D),
            fontSize: AppDimens.sp12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Future<void> _showGatePickerSheet({
    required BuildContext context,
    required AppointmentApprovalApproveController logic,
    required bool isIn,
  }) async {
    await logic.refreshGateOptionsIfNeeded(isIn: isIn);
    if (!context.mounted) return;

    final options = isIn ? logic.inGateOptions : logic.outGateOptions;
    Set<String> tempAreaIds = Set<String>.from(
      isIn ? logic.inSelectedAreaIds : logic.outSelectedAreaIds,
    );
    Set<String> tempDeviceCodes = Set<String>.from(
      isIn ? logic.inSelectedDeviceCodes : logic.outSelectedDeviceCodes,
    );

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final devices = logic.devicesByAreaIds(
              isIn: isIn,
              areaIds: tempAreaIds,
            );

            void toggleArea(String areaId) {
              setModalState(() {
                if (tempAreaIds.contains(areaId)) {
                  tempAreaIds.remove(areaId);
                } else {
                  tempAreaIds.add(areaId);
                }
                final allowedCodes = logic.allDeviceCodesForAreaIds(
                  isIn: isIn,
                  areaIds: tempAreaIds,
                );
                tempDeviceCodes = tempDeviceCodes
                    .where((code) => allowedCodes.contains(code))
                    .toSet();
                if (tempDeviceCodes.isEmpty) {
                  tempDeviceCodes = Set<String>.from(allowedCodes);
                }
              });
            }

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppDimens.dp16,
                  AppDimens.dp12,
                  AppDimens.dp16,
                  AppDimens.dp16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isIn ? '授权入口' : '授权出口',
                      style: TextStyle(
                        fontSize: AppDimens.sp16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E2A3A),
                      ),
                    ),
                    SizedBox(height: AppDimens.dp10),
                    Text(
                      '区域选择',
                      style: TextStyle(
                        fontSize: AppDimens.sp12,
                        color: const Color(0xFF627182),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppDimens.dp8),
                    Wrap(
                      spacing: AppDimens.dp8,
                      runSpacing: AppDimens.dp8,
                      children: options.map((area) {
                        final selected = tempAreaIds.contains(area.districtId);
                        return FilterChip(
                          selected: selected,
                          label: Text(area.districtName),
                          onSelected: (_) => toggleArea(area.districtId),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: AppDimens.dp12),
                    Text(
                      '设备选择',
                      style: TextStyle(
                        fontSize: AppDimens.sp12,
                        color: const Color(0xFF627182),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppDimens.dp8),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.36,
                      ),
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: AppDimens.dp8,
                          runSpacing: AppDimens.dp8,
                          children: devices.map((device) {
                            final selected = tempDeviceCodes.contains(
                              device.deviceCode,
                            );
                            return FilterChip(
                              selected: selected,
                              label: Text(
                                device.deviceName.isEmpty
                                    ? device.deviceCode
                                    : device.deviceName,
                              ),
                              onSelected: (_) {
                                setModalState(() {
                                  if (selected) {
                                    tempDeviceCodes.remove(device.deviceCode);
                                  } else {
                                    tempDeviceCodes.add(device.deviceCode);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: AppDimens.dp12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(sheetContext).pop(),
                            child: const Text('取消'),
                          ),
                        ),
                        SizedBox(width: AppDimens.dp10),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              logic.applyGateSelection(
                                isIn: isIn,
                                areaIds: tempAreaIds,
                                deviceCodes: tempDeviceCodes,
                              );
                              Navigator.of(sheetContext).pop();
                            },
                            child: const Text('确定'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _GateSelectorField extends StatelessWidget {
  const _GateSelectorField({
    required this.title,
    required this.required,
    required this.areaNames,
    required this.deviceNames,
    required this.loading,
    required this.onTap,
  });

  final String title;
  final bool required;
  final List<String> areaNames;
  final List<String> deviceNames;
  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (required)
              const Text(
                '* ',
                style: TextStyle(
                  color: Color(0xFFE55E59),
                  fontWeight: FontWeight.w700,
                ),
              ),
            Text(
              title,
              style: TextStyle(
                color: const Color(0xFF2E3B4D),
                fontSize: AppDimens.sp12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: AppDimens.dp6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimens.dp8),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.dp10,
              vertical: AppDimens.dp10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimens.dp8),
              border: Border.all(color: const Color(0xFFDCE2EC)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    areaNames.isEmpty ? '请选择$title' : areaNames.join('、'),
                    style: TextStyle(
                      color: areaNames.isEmpty
                          ? const Color(0xFF9AA7B8)
                          : const Color(0xFF314255),
                      fontSize: AppDimens.sp12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (loading)
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF8190A4),
                  ),
              ],
            ),
          ),
        ),
        if (deviceNames.isNotEmpty) ...[
          SizedBox(height: AppDimens.dp8),
          Wrap(
            spacing: AppDimens.dp8,
            runSpacing: AppDimens.dp8,
            children: deviceNames
                .map(
                  (name) => Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimens.dp8,
                      vertical: AppDimens.dp5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF4FF),
                      borderRadius: BorderRadius.circular(AppDimens.dp6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_box_rounded,
                          size: 14,
                          color: Color(0xFF3A78F2),
                        ),
                        SizedBox(width: AppDimens.dp4),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 120),
                          child: Text(
                            name,
                            style: TextStyle(
                              color: const Color(0xFF3A78F2),
                              fontSize: AppDimens.sp12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}
