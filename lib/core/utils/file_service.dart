import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../components/image/image_viewer_page.dart';
import '../components/toast/app_loading_dialog.dart';
import '../components/toast/toast_widget.dart';
import '../env/env.dart';
import 'user_manager.dart';

/// 文件服务：统一处理文件打开、下载与删除。
class FileService {
  FileService._();

  static final Dio _dio = Dio();

  static const Map<String, String> _mimeTypeMap = {
    'pdf': 'application/pdf',
    'doc': 'application/msword',
    'docx':
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'xls': 'application/vnd.ms-excel',
    'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'ppt': 'application/vnd.ms-powerpoint',
    'pptx':
        'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    'txt': 'text/plain',
    'apk': 'application/vnd.android.package-archive',
  };

  static const Set<String> _imageExtensions = {
    'jpg',
    'jpeg',
    'png',
    'gif',
    'jfif',
    'webp',
    'heic',
  };

  static const Set<String> _videoExtensions = {'mp4', 'avi', 'mov', 'mkv'};

  /// 图片地址拼接（兼容文件ID与相对路径）。
  static String? getFaceUrl(String? rawValue) {
    final raw = (rawValue ?? '').trim();
    if (raw.isEmpty || raw == '-' || raw.toLowerCase() == 'null') return null;

    final base = Environment.currentEnv.apiBaseUrl.trim();
    if (base.isEmpty) return null;

    // 修正后端偶发返回的粘连地址：baseUrl + 文件名（缺少 /）
    if ((raw.startsWith('http://') || raw.startsWith('https://')) &&
        raw.startsWith(base) &&
        raw.length > base.length &&
        !raw.substring(base.length).startsWith('/')) {
      return '$base/${raw.substring(base.length)}';
    }

    if (raw.startsWith('http://') || raw.startsWith('https://')) return raw;

    // Web 默认拼接规则：/api/system/file/download/{id}
    // 只要是单段标识（不含 /），不管是否带扩展名，都按下载接口拼接。
    if (!raw.contains('/')) {
      return '$base/api/system/file/download/$raw';
    }

    // 已包含 /api 前缀，直接拼接。
    if (raw.startsWith('/api/')) return '$base$raw';
    if (raw.startsWith('api/')) return '$base/$raw';

    // system 开头路径，自动补 /api 前缀。
    if (raw.startsWith('/system/')) return '$base/api$raw';
    if (raw.startsWith('system/')) return '$base/api/$raw';

    // 其他绝对/相对路径兜底。
    if (raw.startsWith('/')) return '$base$raw';
    return '$base/$raw';
  }

  /// 图片请求鉴权头。
  static Map<String, String>? imageHeaders() {
    final token = (UserManager.token ?? '').trim();
    if (token.isEmpty) return null;
    return {'Authorization': token};
  }

  static bool _isRemotePath(String path) =>
      path.startsWith('http://') || path.startsWith('https://');

  static String? _getFileExtension(String path) {
    if (path.isEmpty) return null;
    try {
      final cleanPath = Uri.parse(path).path;
      final index = cleanPath.lastIndexOf('.');
      if (index == -1 || index == cleanPath.length - 1) {
        return null;
      }
      return cleanPath.substring(index + 1).toLowerCase();
    } catch (_) {
      final index = path.lastIndexOf('.');
      if (index == -1 || index == path.length - 1) {
        return null;
      }
      return path.substring(index + 1).toLowerCase();
    }
  }

  static String _buildCacheFileName(String url) {
    final hash = md5.convert(utf8.encode(url)).toString();
    final ext = _getFileExtension(url);
    if (ext == null) return hash;
    return '$hash.$ext';
  }

  /// 根据文件路径打开文件（支持网络地址和本地路径）。
  static Future<void> openFile(
    String? path, {
    String? title,
    Color? color,
  }) async {
    if (path == null || path.isEmpty) {
      AppToast.showWarning('暂无文件!');
      return;
    }

    final type = _getFileExtension(path);
    if (type == null) {
      AppToast.showWarning('无法识别的文件类型!');
      return;
    }

    if (_imageExtensions.contains(type)) {
      Get.to(
        () => ImageViewerPage(
          imageUrl: path,
          headers: imageHeaders(),
          title: title,
          appBarColor: color,
        ),
      );
      return;
    }

    if (_videoExtensions.contains(type)) {
      AppToast.showWarning('暂不支持播放此文件!');
      return;
    }

    if (_isRemotePath(path)) {
      await downloadFile(path, type: _mimeTypeMap[type]);
      return;
    }

    await OpenFilex.open(path, type: _mimeTypeMap[type]);
  }

  /// 根据 URL 生成本地缓存路径（使用 hash 避免同名覆盖）。
  static Future<String> getLocalSavePath(String url) async {
    final fileName = _buildCacheFileName(url);
    final directory = await getTemporaryDirectory();
    return '${directory.path}/$fileName';
  }

  /// 从网络下载文件，可选自动打开。
  static Future<String?> downloadFile(
    String url, {
    String? type,
    bool isOpen = true,
    Function(int, int)? onReceiveProgress,
    bool isShowLoading = true,
  }) async {
    if (!_isRemotePath(url)) {
      AppToast.showWarning('仅支持下载网络文件');
      return null;
    }

    final savePath = await getLocalSavePath(url);
    final file = File(savePath);

    if (await file.exists()) {
      if (isOpen) {
        await OpenFilex.open(savePath, type: type);
      }
      return savePath;
    }

    if (isShowLoading) {
      AppLoadingDialog.show(title: '正在下载...', clickClose: true);
    }

    try {
      await _dio.download(url, savePath, onReceiveProgress: onReceiveProgress);

      if (isOpen) {
        await OpenFilex.open(savePath, type: type);
      }
      return savePath;
    } catch (e) {
      debugPrint('文件下载失败: $e');
      AppToast.showError('文件下载失败!');
      if (await file.exists()) {
        await file.delete();
      }
      return null;
    } finally {
      if (isShowLoading) {
        AppLoadingDialog.close();
      }
    }
  }

  /// 删除缓存文件。
  static Future<void> delete(String? url) async {
    if (url == null || url.isEmpty || !_isRemotePath(url)) return;

    try {
      final savePath = await getLocalSavePath(url);
      final file = File(savePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('文件删除失败: $e');
    }
  }
}
