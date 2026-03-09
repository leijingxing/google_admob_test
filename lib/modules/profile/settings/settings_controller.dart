import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/components/toast/toast_widget.dart';
import '../../../core/constants/dimens.dart';
import 'perm_util.dart';

class SettingsController extends GetxController with WidgetsBindingObserver {
  String cacheSize = '计算中...';
  final Map<Permission, PermissionStatus> permissionStatuses = {};

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    loadCacheSize();
    loadPermissionStatuses();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      loadPermissionStatuses();
    }
  }

  /// 加载缓存大小
  Future<void> loadCacheSize() async {
    try {
      final tempDir = await getTemporaryDirectory();
      double totalSize = 0;
      if (tempDir.existsSync()) {
        totalSize = await _getTotalSizeOfFilesInDir(tempDir);
      }
      cacheSize = _formatBytes(totalSize, 2);
      update();
    } catch (e) {
      cacheSize = '获取失败';
      update();
    }
  }

  /// 递归计算目录大小
  Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    if (file is File) {
      return (await file.length()).toDouble();
    }
    if (file is Directory) {
      final children = file.listSync();
      double total = 0;
      for (final child in children) {
        total += await _getTotalSizeOfFilesInDir(child);
      }
      return total;
    }
    return 0;
  }

  /// 格式化字节数
  String _formatBytes(double bytes, int decimals) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    final i = (bytes > 0 ? (math.log(bytes) / math.log(1024)).floor() : 0)
        .toInt();
    return '${(bytes / math.pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  /// 清理缓存
  Future<void> clearCache() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.dp16),
        ),
        title: const Text(
          '确认操作',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('确定要清除所有本地缓存吗？'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('取消', style: TextStyle(color: Color(0xFF6B7E9E))),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text(
              '确认清除',
              style: TextStyle(
                color: Color(0xFFE55252),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      if (Hive.isBoxOpen('storage')) {
        await Hive.box('storage').clear();
      }
      final tempDir = await getTemporaryDirectory();
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
      AppToast.showSuccess('缓存已清除');
    } catch (e) {
      AppToast.showError('清除失败: $e');
    } finally {
      await loadCacheSize();
    }
  }

  /// 加载权限状态
  Future<void> loadPermissionStatuses() async {
    for (final permission in PermUtil.allForApp) {
      permissionStatuses[permission] = await permission.status;
    }
    update();
  }

  /// 处理单个权限授权
  Future<void> handlePermissionTap(Permission permission) async {
    final status = permissionStatuses[permission] ?? await permission.status;

    if (status.isGranted || status.isLimited) {
      AppToast.showInfo('${permission.displayName}权限已开启');
      return;
    }

    if (status.isPermanentlyDenied || status.isRestricted) {
      final opened = await openAppSettings();
      if (!opened) {
        AppToast.showWarning('无法打开系统设置，请手动授权${permission.displayName}权限');
      }
      return;
    }

    final result = await permission.request();
    permissionStatuses[permission] = result;
    update();

    if (result.isGranted || result.isLimited) {
      AppToast.showSuccess('${permission.displayName}权限已开启');
      return;
    }

    if (result.isPermanentlyDenied) {
      AppToast.showWarning('${permission.displayName}权限已被永久拒绝，请前往系统设置开启');
      return;
    }

    AppToast.showWarning('${permission.displayName}权限未开启，相关功能可能无法使用');
  }

  /// 打开系统权限设置
  Future<void> openPermissionSettings() async {
    final opened = await openAppSettings();
    if (!opened) {
      AppToast.showWarning('无法打开系统设置');
    }
  }
}
