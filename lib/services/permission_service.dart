import 'package:permission_handler/permission_handler.dart';

/// 权限服务
///
/// 统一封装应用权限检查、名称映射与系统设置跳转能力。
class PermissionService {
  /// App 所需权限清单
  static const List<Permission> allForApp = [
    Permission.camera,
    Permission.photos,
    Permission.location,
    Permission.microphone,
    Permission.notification,
    Permission.storage,
  ];

  /// 获取权限状态
  ///
  /// 当 [autoReq] 为 `true` 时，未授权将自动触发申请。
  static Future<bool> isAvailable(
    Permission permission, {
    bool autoReq = false,
  }) async {
    final permissionStatus = await permission.status;
    if (permissionStatus.isGranted) {
      return true;
    }

    if (autoReq) {
      final requestResult = await permission.request();
      return requestResult.isGranted;
    }

    return false;
  }

  /// 权限显示名
  static String displayName(Permission permission) {
    switch (permission) {
      case Permission.camera:
        return '相机';
      case Permission.photos:
        return '相册';
      case Permission.location:
        return '定位';
      case Permission.microphone:
        return '麦克风';
      case Permission.notification:
        return '通知';
      case Permission.storage:
        return '存储';
      default:
        return '未定义(${permission.value})';
    }
  }

  /// 打开应用权限设置页
  static Future<bool> openSettings() {
    return openAppSettings();
  }
}
