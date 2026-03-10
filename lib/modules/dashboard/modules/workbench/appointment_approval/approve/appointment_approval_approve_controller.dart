import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/components/toast/toast_widget.dart';
import '../../../../../../core/http/result.dart';
import '../../../../../../data/models/workbench/appointment_approval_item_model.dart';
import '../../../../../../data/models/workbench/checkpoint_area_option_model.dart';
import '../../../../../../data/repository/workbench_repository.dart';
import '../../../../../../global.dart';

/// 预约审批页控制器。
///
/// 负责详情加载、授权闸机选择以及审批提交。
class AppointmentApprovalApproveController extends GetxController {
  final WorkbenchRepository _repository = WorkbenchRepository();

  late final AppointmentApprovalItemModel item;
  final TextEditingController parkCheckDescController = TextEditingController();

  /// 页面主状态。
  bool loading = false;
  bool gateLoading = false;
  bool submitting = false;
  Map<String, dynamic> detail = const <String, dynamic>{};

  /// 审批表单字段。
  DateTime? validityStart;
  DateTime? validityEnd;
  bool sampleCheck = false;

  /// 入口/出口闸机可选项。
  List<CheckpointAreaOption> inGateOptions = const <CheckpointAreaOption>[];
  List<CheckpointAreaOption> outGateOptions = const <CheckpointAreaOption>[];

  /// 当前选中的区域和设备。
  Set<String> inSelectedAreaIds = <String>{};
  Set<String> outSelectedAreaIds = <String>{};
  Set<String> inSelectedDeviceCodes = <String>{};
  Set<String> outSelectedDeviceCodes = <String>{};

  /// 详情接口返回的默认值，用于首次回填。
  List<String> _inDefaultAreaIds = const <String>[];
  List<String> _outDefaultAreaIds = const <String>[];
  List<String> _inDefaultDeviceCodes = const <String>[];
  List<String> _outDefaultDeviceCodes = const <String>[];
  List<String> _inDefaultAreaNames = const <String>[];
  List<String> _outDefaultAreaNames = const <String>[];
  List<String> _inDefaultDeviceNames = const <String>[];
  List<String> _outDefaultDeviceNames = const <String>[];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is AppointmentApprovalItemModel) {
      item = args;
      if ((item.id ?? '').isNotEmpty) {
        loadDetail();
      }
    } else {
      item = const AppointmentApprovalItemModel();
    }
  }

  @override
  void onClose() {
    parkCheckDescController.dispose();
    super.onClose();
  }

  Future<void> loadDetail() async {
    final id = item.id ?? '';
    if (id.isEmpty) return;

    loading = true;
    update();

    final result = await _repository.getReservationProgressInfo(id: id);
    if (result is Success<Map<String, dynamic>>) {
      detail = result.data;
      _applyDetailDefaults();
      await _reloadGateOptions();
    } else if (result is Failure<Map<String, dynamic>>) {
      talker.error('审批详情加载失败', result.error, StackTrace.current);
      AppToast.showError(result.error.message);
    }

    loading = false;
    update();
  }

  void _applyDetailDefaults() {
    final data = _detailData();
    validityStart = _parseDateTime(data['validityBeginTime']);
    validityEnd = _parseDateTime(data['validityEndTime']);
    sampleCheck = shouldShowSampleCheck && _toInt(data['sampleCheck']) == 1;

    final desc = (data['parkCheckDesc'] ?? '').toString().trim();
    if (desc.isNotEmpty && parkCheckDescController.text.trim().isEmpty) {
      parkCheckDescController.text = desc;
    }

    _inDefaultAreaIds = _splitCsv(data['inDistrictId']);
    _outDefaultAreaIds = _splitCsv(data['outDistrictId']);
    _inDefaultDeviceCodes = _splitCsv(data['inDeviceCode']);
    _outDefaultDeviceCodes = _splitCsv(data['outDeviceCode']);
    _inDefaultAreaNames = _splitCsv(data['inDistrictName']);
    _outDefaultAreaNames = _splitCsv(data['outDistrictName']);
    _inDefaultDeviceNames = _splitCsv(data['inDeviceName']);
    _outDefaultDeviceNames = _splitCsv(data['outDeviceName']);
  }

  Future<void> onValidityDateChanged(DateTime? start, DateTime? end) async {
    if (start == null || end == null) {
      validityStart = start;
      validityEnd = end;
    } else {
      validityStart = start.isBefore(end) ? start : end;
      validityEnd = start.isBefore(end) ? end : start;
    }
    update();
    await _reloadGateOptions();
  }

  void onSampleCheckChanged(bool value) {
    sampleCheck = value;
    update();
  }

  /// 仅危化车、危废车需要展示并提交抽检字段。
  bool get shouldShowSampleCheck =>
      item.reservationType == 3 || item.reservationType == 4;

  Future<void> _reloadGateOptions() async {
    gateLoading = true;
    update();

    await Future.wait([
      _loadGateOptions(isIn: true),
      _loadGateOptions(isIn: false),
    ]);

    gateLoading = false;
    update();
  }

  Future<void> _loadGateOptions({required bool isIn}) async {
    final result = await _repository.getCheckPointDevice(
      inOrOut: isIn ? 2 : 1,
      deviceType: item.reservationType == 1 ? 2 : 1,
      validityBeginTime: validityStart == null
          ? null
          : _formatDateTime(validityStart!),
      validityEndTime: validityEnd == null
          ? null
          : _formatDateTime(validityEnd!),
    );

    result.when(
      success: (data) {
        final options = data;
        if (isIn) {
          inGateOptions = options;
          _syncSelectionByOptions(isIn: true);
        } else {
          outGateOptions = options;
          _syncSelectionByOptions(isIn: false);
        }
      },
      failure: (error) {
        talker.error('闸机选项加载失败 isIn=$isIn', error, StackTrace.current);
        if (isIn) {
          inGateOptions = const <CheckpointAreaOption>[];
        } else {
          outGateOptions = const <CheckpointAreaOption>[];
        }
        AppToast.showError(error.message);
      },
    );
  }

  void _syncSelectionByOptions({required bool isIn}) {
    final options = isIn ? inGateOptions : outGateOptions;
    final allAreaIds = options
        .map((e) => e.districtId)
        .where((e) => e.isNotEmpty)
        .toSet();

    final defaultAreaIds = (isIn ? _inDefaultAreaIds : _outDefaultAreaIds)
        .where((e) => allAreaIds.contains(e))
        .toSet();

    Set<String> selectedAreas = isIn ? inSelectedAreaIds : outSelectedAreaIds;
    Set<String> selectedDevices = isIn
        ? inSelectedDeviceCodes
        : outSelectedDeviceCodes;

    if (selectedAreas.isEmpty) {
      selectedAreas = defaultAreaIds.isNotEmpty ? defaultAreaIds : allAreaIds;
    } else {
      selectedAreas = selectedAreas
          .where((e) => allAreaIds.contains(e))
          .toSet();
      if (selectedAreas.isEmpty) {
        selectedAreas = defaultAreaIds.isNotEmpty ? defaultAreaIds : allAreaIds;
      }
    }

    final availableDeviceCodes = _allDeviceCodesByAreas(
      options: options,
      areaIds: selectedAreas,
    );
    if (selectedDevices.isEmpty) {
      final defaultCodes =
          (isIn ? _inDefaultDeviceCodes : _outDefaultDeviceCodes)
              .where((e) => availableDeviceCodes.contains(e))
              .toSet();
      selectedDevices = defaultCodes.isNotEmpty
          ? defaultCodes
          : availableDeviceCodes;
    } else {
      selectedDevices = selectedDevices
          .where((e) => availableDeviceCodes.contains(e))
          .toSet();
      if (selectedDevices.isEmpty) {
        selectedDevices = availableDeviceCodes;
      }
    }

    if (isIn) {
      inSelectedAreaIds = selectedAreas;
      inSelectedDeviceCodes = selectedDevices;
    } else {
      outSelectedAreaIds = selectedAreas;
      outSelectedDeviceCodes = selectedDevices;
    }
  }

  Future<void> refreshGateOptionsIfNeeded({required bool isIn}) async {
    final options = isIn ? inGateOptions : outGateOptions;
    if (options.isNotEmpty) return;
    gateLoading = true;
    update();
    await _loadGateOptions(isIn: isIn);
    gateLoading = false;
    update();
  }

  void applyGateSelection({
    required bool isIn,
    required Set<String> areaIds,
    required Set<String> deviceCodes,
  }) {
    final options = isIn ? inGateOptions : outGateOptions;
    final availableDeviceCodes = _allDeviceCodesByAreas(
      options: options,
      areaIds: areaIds,
    );
    final finalDeviceCodes = deviceCodes
        .where((code) => availableDeviceCodes.contains(code))
        .toSet();

    if (isIn) {
      inSelectedAreaIds = areaIds;
      inSelectedDeviceCodes = finalDeviceCodes;
    } else {
      outSelectedAreaIds = areaIds;
      outSelectedDeviceCodes = finalDeviceCodes;
    }
    update();
  }

  Set<String> allDeviceCodesForAreaIds({
    required bool isIn,
    required Set<String> areaIds,
  }) {
    return _allDeviceCodesByAreas(
      options: isIn ? inGateOptions : outGateOptions,
      areaIds: areaIds,
    );
  }

  List<CheckpointDeviceOption> devicesByAreaIds({
    required bool isIn,
    required Set<String> areaIds,
  }) {
    final options = isIn ? inGateOptions : outGateOptions;
    return _devicesByAreaIds(options: options, areaIds: areaIds);
  }

  List<String> selectedAreaNames({required bool isIn}) {
    final options = isIn ? inGateOptions : outGateOptions;
    final selected = isIn ? inSelectedAreaIds : outSelectedAreaIds;
    final names = options
        .where((area) => selected.contains(area.districtId))
        .map((area) => area.districtName)
        .where((name) => name.isNotEmpty)
        .toList();

    if (names.isNotEmpty) return names;
    return isIn ? _inDefaultAreaNames : _outDefaultAreaNames;
  }

  List<String> selectedDeviceNames({required bool isIn}) {
    final options = isIn ? inGateOptions : outGateOptions;
    final selected = isIn ? inSelectedDeviceCodes : outSelectedDeviceCodes;
    final nameMap = <String, String>{};

    for (final area in options) {
      for (final device in area.deviceList) {
        if (device.deviceCode.isNotEmpty) {
          nameMap[device.deviceCode] = device.deviceName;
        }
      }
    }

    final names = selected.map((code) => nameMap[code] ?? code).toList();
    if (names.isNotEmpty) return names;
    return isIn ? _inDefaultDeviceNames : _outDefaultDeviceNames;
  }

  Future<void> submitApproval({required int parkCheckStatus}) async {
    final id = item.id ?? '';
    if (id.isEmpty) {
      AppToast.showError('缺少预约记录ID');
      return;
    }
    if (validityStart == null || validityEnd == null) {
      AppToast.showError('请选择授权期限');
      return;
    }
    if (inSelectedAreaIds.isEmpty || inSelectedDeviceCodes.isEmpty) {
      AppToast.showError('请选择授权入口');
      return;
    }
    if (outSelectedAreaIds.isEmpty || outSelectedDeviceCodes.isEmpty) {
      AppToast.showError('请选择授权出口');
      return;
    }

    submitting = true;
    update();

    final result = await _repository.parkApproveReservation(
      id: id,
      parkCheckStatus: parkCheckStatus,
      parkCheckDesc: parkCheckDescController.text.trim(),
      validityBeginTime: _formatDateTime(validityStart!),
      validityEndTime: _formatDateTime(validityEnd!),
      inDistrictIds: inSelectedAreaIds.toList(),
      outDistrictIds: outSelectedAreaIds.toList(),
      inDeviceCodes: inSelectedDeviceCodes.toList(),
      outDeviceCodes: outSelectedDeviceCodes.toList(),
      sampleCheck: shouldShowSampleCheck && sampleCheck ? 1 : 0,
    );

    submitting = false;
    update();

    result.when(
      success: (_) {
        AppToast.showSuccess('审批成功');
        Get.back<bool>(result: true);
      },
      failure: (error) {
        talker.error('审批提交失败', error, StackTrace.current);
        AppToast.showError(error.message);
      },
    );
  }

  String reservationTypeText(int type) {
    switch (type) {
      case 1:
        return '来访人员';
      case 2:
        return '普通车辆';
      case 3:
        return '危化车辆';
      case 4:
        return '危废车辆';
      case 5:
        return '普通货车';
      default:
        return '未知类型';
    }
  }

  List<AppointmentApproveDetailLine> buildDetailLines() {
    final data = _detailData();
    return <AppointmentApproveDetailLine>[
      AppointmentApproveDetailLine(
        label: '预约类型',
        value: reservationTypeText(item.reservationType),
      ),
      AppointmentApproveDetailLine(
        label: '车牌号',
        value: _firstNonEmpty(data['carNumb'], item.carNumb),
      ),
      AppointmentApproveDetailLine(
        label: '驾驶员',
        value: _firstNonEmpty(data['realName'], item.realName),
      ),
      AppointmentApproveDetailLine(
        label: '联系电话',
        value: _firstNonEmpty(data['userPhone']),
      ),
      AppointmentApproveDetailLine(
        label: '目的地',
        value: _firstNonEmpty(data['targetName']),
      ),
      AppointmentApproveDetailLine(
        label: '提交时间',
        value: _firstNonEmpty(data['createDate'], item.createDate),
      ),
    ].where((e) => e.value != '--').toList();
  }

  Map<String, dynamic> _detailData() {
    final specific = detail['specificData'];
    if (specific is Map) {
      return Map<String, dynamic>.from(specific);
    }
    return detail;
  }

  List<String> _splitCsv(Object? value) {
    final text = (value ?? '').toString();
    if (text.trim().isEmpty) return const <String>[];
    return text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty && e.toLowerCase() != 'null')
        .toList();
  }

  Set<String> _allDeviceCodesByAreas({
    required List<CheckpointAreaOption> options,
    required Set<String> areaIds,
  }) {
    return _devicesByAreaIds(options: options, areaIds: areaIds)
        .map((device) => device.deviceCode)
        .where((code) => code.isNotEmpty)
        .toSet();
  }

  List<CheckpointDeviceOption> _devicesByAreaIds({
    required List<CheckpointAreaOption> options,
    required Set<String> areaIds,
  }) {
    if (areaIds.isEmpty) return const <CheckpointDeviceOption>[];
    final list = <CheckpointDeviceOption>[];
    for (final area in options) {
      if (!areaIds.contains(area.districtId)) continue;
      list.addAll(area.deviceList);
    }
    return list;
  }

  DateTime? _parseDateTime(Object? value) {
    final text = (value ?? '').toString().trim();
    if (text.isEmpty || text.toLowerCase() == 'null') return null;
    return DateTime.tryParse(text.replaceFirst(' ', 'T'));
  }

  int _toInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse((value ?? '').toString()) ?? 0;
  }

  String _formatDateTime(DateTime date) {
    return '${date.year}-${_pad2(date.month)}-${_pad2(date.day)} ${_pad2(date.hour)}:${_pad2(date.minute)}:${_pad2(date.second)}';
  }

  String _pad2(int value) => value.toString().padLeft(2, '0');

  String _firstNonEmpty([Object? a, Object? b, Object? c]) {
    for (final value in <Object?>[a, b, c]) {
      final text = value?.toString().trim() ?? '';
      if (text.isNotEmpty && text.toLowerCase() != 'null') return text;
    }
    return '--';
  }
}

class AppointmentApproveDetailLine {
  const AppointmentApproveDetailLine({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}
