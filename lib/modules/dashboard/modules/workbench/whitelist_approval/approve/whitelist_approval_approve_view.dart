import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/components/app_standard_card.dart';
import '../../../../../../core/components/date_picker/custom_date_range_picker.dart';
import '../../../../../../core/constants/dimens.dart';
import 'whitelist_approval_approve_controller.dart';

/// 白名单审批页。
class WhitelistApprovalApproveView
    extends GetView<WhitelistApprovalApproveController> {
  const WhitelistApprovalApproveView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WhitelistApprovalApproveController>(
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
    required WhitelistApprovalApproveController logic,
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
      backgroundColor: const Color(0xFFF6F8FC),
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
                  AppDimens.dp10,
                  AppDimens.dp16,
                  AppDimens.dp16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: AppDimens.dp40,
                        height: 4,
                        margin: EdgeInsets.only(bottom: AppDimens.dp10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD0D8E6),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    Text(
                      isIn ? '授权入口' : '授权出口',
                      style: TextStyle(
                        fontSize: AppDimens.sp16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E2A3A),
                      ),
                    ),
                    SizedBox(height: AppDimens.dp10),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(AppDimens.dp10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppDimens.dp10),
                        border: Border.all(color: const Color(0xFFE2E7F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '区域选择',
                                style: TextStyle(
                                  fontSize: AppDimens.sp12,
                                  color: const Color(0xFF2F3F53),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  setModalState(() {
                                    tempAreaIds = options
                                        .map((e) => e.districtId)
                                        .toSet();
                                    tempDeviceCodes = logic
                                        .allDeviceCodesForAreaIds(
                                          isIn: isIn,
                                          areaIds: tempAreaIds,
                                        );
                                  });
                                },
                                child: const Text('全选'),
                              ),
                              TextButton(
                                onPressed: () {
                                  setModalState(() {
                                    tempAreaIds.clear();
                                    tempDeviceCodes.clear();
                                  });
                                },
                                child: const Text('清空'),
                              ),
                            ],
                          ),
                          Wrap(
                            spacing: AppDimens.dp8,
                            runSpacing: AppDimens.dp8,
                            children: options.map((area) {
                              final selected = tempAreaIds.contains(
                                area.districtId,
                              );
                              return FilterChip(
                                selected: selected,
                                showCheckmark: false,
                                selectedColor: const Color(0xFFE8F1FF),
                                side: BorderSide(
                                  color: selected
                                      ? const Color(0xFF3A78F2)
                                      : const Color(0xFFD8DFEA),
                                ),
                                label: Text(
                                  area.districtName,
                                  style: TextStyle(
                                    color: selected
                                        ? const Color(0xFF2D62D6)
                                        : const Color(0xFF4A5A70),
                                  ),
                                ),
                                onSelected: (_) => toggleArea(area.districtId),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppDimens.dp12),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(AppDimens.dp10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppDimens.dp10),
                        border: Border.all(color: const Color(0xFFE2E7F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '设备选择（${devices.length}）',
                            style: TextStyle(
                              fontSize: AppDimens.sp12,
                              color: const Color(0xFF2F3F53),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: AppDimens.dp8),
                          if (devices.isEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: AppDimens.dp8,
                              ),
                              child: Text(
                                '请先选择区域',
                                style: TextStyle(
                                  fontSize: AppDimens.sp12,
                                  color: const Color(0xFF8A97A8),
                                ),
                              ),
                            )
                          else
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.32,
                              ),
                              child: SingleChildScrollView(
                                child: Wrap(
                                  spacing: AppDimens.dp8,
                                  runSpacing: AppDimens.dp8,
                                  children: devices.map((device) {
                                    final selected = tempDeviceCodes.contains(
                                      device.deviceCode,
                                    );
                                    final name = device.deviceName.isEmpty
                                        ? device.deviceCode
                                        : device.deviceName;
                                    return FilterChip(
                                      selected: selected,
                                      showCheckmark: false,
                                      selectedColor: const Color(0xFFE8F1FF),
                                      side: BorderSide(
                                        color: selected
                                            ? const Color(0xFF3A78F2)
                                            : const Color(0xFFD8DFEA),
                                      ),
                                      avatar: Icon(
                                        selected
                                            ? Icons.check_box_rounded
                                            : Icons
                                                  .check_box_outline_blank_rounded,
                                        size: 15,
                                        color: selected
                                            ? const Color(0xFF3A78F2)
                                            : const Color(0xFF8EA0B8),
                                      ),
                                      label: ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          maxWidth: 140,
                                        ),
                                        child: Text(
                                          name,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      onSelected: (_) {
                                        setModalState(() {
                                          if (selected) {
                                            tempDeviceCodes.remove(
                                              device.deviceCode,
                                            );
                                          } else {
                                            tempDeviceCodes.add(
                                              device.deviceCode,
                                            );
                                          }
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppDimens.dp14),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(sheetContext).pop();
                            },
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
    final areaCount = areaNames.length;
    final deviceCount = deviceNames.length;
    final subtitle = areaCount == 0
        ? '点击选择$title'
        : '已选区域 $areaCount 个，设备 $deviceCount 个';

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
            padding: EdgeInsets.all(AppDimens.dp10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimens.dp8),
              border: Border.all(color: const Color(0xFFD2DBE9)),
              color: const Color(0xFFFAFBFE),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          color: areaCount == 0
                              ? const Color(0xFF9AA7B8)
                              : const Color(0xFF314255),
                          fontSize: AppDimens.sp12,
                          fontWeight: FontWeight.w600,
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
                if (areaNames.isNotEmpty) ...[
                  SizedBox(height: AppDimens.dp8),
                  Wrap(
                    spacing: AppDimens.dp6,
                    runSpacing: AppDimens.dp6,
                    children: areaNames
                        .map((name) => _GateTag(text: name, primary: true))
                        .toList(),
                  ),
                ],
                if (deviceNames.isNotEmpty) ...[
                  SizedBox(height: AppDimens.dp8),
                  Wrap(
                    spacing: AppDimens.dp6,
                    runSpacing: AppDimens.dp6,
                    children: deviceNames
                        .map((name) => _GateTag(text: name))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GateTag extends StatelessWidget {
  const _GateTag({required this.text, this.primary = false});

  final String text;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dp8,
        vertical: AppDimens.dp4,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: primary ? const Color(0xFFEAF1FF) : const Color(0xFFF2F5FA),
        border: Border.all(
          color: primary ? const Color(0xFFC7D8FF) : const Color(0xFFDCE4EF),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: primary ? const Color(0xFF2D62D6) : const Color(0xFF54657A),
          fontSize: AppDimens.sp11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
