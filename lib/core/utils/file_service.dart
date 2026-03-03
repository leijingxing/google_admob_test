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

/// 文件服务：统一处理文件打开、下载与删除。
class FileService {
  FileService._();

  static final Dio _dio = Dio();

  static const Map<String, String> _mimeTypeMap = {
    'pdf': 'application/pdf',
    'doc': 'application/msword',
    'docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'xls': 'application/vnd.ms-excel',
    'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'ppt': 'application/vnd.ms-powerpoint',
    'pptx': 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
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
        () => ImageViewerPage(imageUrl: path, title: title, appBarColor: color),
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
