import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../../../core/components/toast/toast_widget.dart';
import '../../../../../../../services/permission_service.dart';
import '../park_inspection_detail_controller.dart';

class ParkInspectionCheckInController extends GetxController {
  late final ParkInspectionDetailController detailController;

  final TextEditingController positionController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();

  String? selectedPointId;
  bool locating = false;
  bool submitting = false;

  @override
  void onInit() {
    super.onInit();
    detailController = Get.find<ParkInspectionDetailController>();
  }

  List<DropdownMenuItem<String>> get pointItems {
    return detailController.planPoints.map((item) {
      return DropdownMenuItem<String>(value: item.pointId ?? item.id, child: Text(item.pointName ?? '--'));
    }).toList();
  }

  void onPointChanged(String? value) {
    selectedPointId = value;
    update();
  }

  Future<void> fetchCurrentLocation() async {
    if (locating) return;
    final permission = Permission.location;
    final granted = await PermissionService.isAvailable(permission, autoReq: true);
    if (!granted) {
      await _promptOpenPermissionSettings(permission);
      return;
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await _promptOpenLocationServiceSettings();
      return;
    }

    locating = true;
    update();
    try {
      final position = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
      positionController.text = '${position.longitude.toStringAsFixed(6)},${position.latitude.toStringAsFixed(6)}';
    } on LocationServiceDisabledException {
      await _promptOpenLocationServiceSettings();
    } catch (_) {
      AppToast.showError('获取定位失败');
    } finally {
      locating = false;
      update();
    }
  }

  Future<void> _promptOpenPermissionSettings(Permission permission) async {
    final status = await permission.status;
    final message = status.isPermanentlyDenied ? '定位权限已被永久拒绝，请前往系统设置开启' : '未获得定位权限，请允许后再获取当前位置';
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('需要定位权限'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('取消')),
          FilledButton(onPressed: () => Get.back(result: true), child: const Text('去开启')),
        ],
      ),
      barrierDismissible: false,
    );
    if (result == true) {
      await PermissionService.openSettings();
    }
  }

  Future<void> _promptOpenLocationServiceSettings() async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('请开启定位服务'),
        content: const Text('系统定位服务未开启，请前往系统定位设置开启后重试'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('取消')),
          FilledButton(onPressed: () => Get.back(result: true), child: const Text('去设置')),
        ],
      ),
      barrierDismissible: false,
    );
    if (result == true) {
      await Geolocator.openLocationSettings();
    }
  }

  Future<void> submit() async {
    if ((selectedPointId ?? '').trim().isEmpty) {
      AppToast.showWarning('请选择巡检点位');
      return;
    }
    if (positionController.text.trim().isEmpty) {
      AppToast.showWarning('请输入打卡位置');
      return;
    }
    if (submitting) return;

    submitting = true;
    update();
    final success = await detailController.submitCheckIn(pointId: selectedPointId!.trim(), position: positionController.text.trim(), remark: remarkController.text.trim());
    submitting = false;
    update();

    if (success) {
      Get.back<bool>(result: true);
    }
  }

  @override
  void onClose() {
    positionController.dispose();
    remarkController.dispose();
    super.onClose();
  }
}
