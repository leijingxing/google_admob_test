import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// 设置页权限工具。
abstract final class PermUtil {
  /// App 所需的权限列表。
  static const List<Permission> allForApp = [
    Permission.camera,
    Permission.photos,
    Permission.location,
    Permission.microphone,
    Permission.notification,
    Permission.storage,
  ];
}

extension PermissionX on Permission {
  /// 权限名称。
  String get displayName {
    switch (this) {
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
        return '未定义($value)';
    }
  }

  /// 权限说明。
  String get description {
    switch (this) {
      case Permission.camera:
        return '用于拍照、扫码等需要调用摄像头的场景';
      case Permission.photos:
        return '用于选择、保存图片等相册相关操作';
      case Permission.location:
        return '用于定位、地图展示等位置相关能力';
      case Permission.microphone:
        return '用于语音采集、录音等音频相关功能';
      case Permission.notification:
        return '用于接收消息提醒、公告通知等系统推送';
      case Permission.storage:
        return '用于文件缓存、下载与读取本地文件';
      default:
        return '用于保障应用相关功能正常使用';
    }
  }

  /// 权限图标。
  IconData get icon {
    switch (this) {
      case Permission.camera:
        return Icons.camera_alt_outlined;
      case Permission.photos:
        return Icons.photo_library_outlined;
      case Permission.location:
        return Icons.location_on_outlined;
      case Permission.microphone:
        return Icons.mic_none_outlined;
      case Permission.notification:
        return Icons.notifications_none_outlined;
      case Permission.storage:
        return Icons.folder_outlined;
      default:
        return Icons.security_outlined;
    }
  }
}

extension PermissionStatusX on PermissionStatus {
  /// 状态文案。
  String get label {
    if (isGranted) {
      return '已开启';
    }
    if (isLimited) {
      return '部分开启';
    }
    if (isPermanentlyDenied) {
      return '已永久拒绝';
    }
    if (isRestricted) {
      return '受系统限制';
    }
    return '未开启';
  }

  /// 状态颜色。
  Color get color {
    if (isGranted) {
      return const Color(0xFF0F9D58);
    }
    if (isLimited) {
      return const Color(0xFFF59E0B);
    }
    if (isPermanentlyDenied || isRestricted) {
      return const Color(0xFFE55252);
    }
    return const Color(0xFF94A3B8);
  }

  /// 操作文案。
  String get actionLabel {
    if (isGranted || isLimited) {
      return '已授权';
    }
    if (isPermanentlyDenied || isRestricted) {
      return '去设置';
    }
    return '去开启';
  }
}
