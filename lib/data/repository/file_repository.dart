import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;

import '../../core/components/log_util.dart';
import '../../core/env/env.dart';
import '../../core/http/http_service.dart';

/// 开始上传接口响应数据模型。
class _StartUploadResponseData {
  _StartUploadResponseData({required this.fileName, required this.id});

  factory _StartUploadResponseData.fromJson(Map<String, dynamic> json) {
    return _StartUploadResponseData(
      fileName: json['fileName'] as String? ?? '',
      id: json['id'] as String? ?? '',
    );
  }

  final String fileName;
  final String id;
}

/// 完成上传接口响应数据模型。
class _CompleteUploadResponseData {
  _CompleteUploadResponseData({required this.fileId});

  factory _CompleteUploadResponseData.fromJson(Map<String, dynamic> json) {
    return _CompleteUploadResponseData(fileId: json['fileId'] as String? ?? '');
  }

  final String fileId;
}

/// 文件仓库：提供分片上传能力。
class FileRepository {
  /// 分片上传时每个分片大小（5MB）。
  static const int _chunkSize = 5 * 1024 * 1024;

  static const String _startUploadPath = '/api/system/file/startUpload';
  static const String _uploadChunkPath = '/api/system/file/upload';
  static const String _completeUploadPath = '/api/system/file/completeUpload';

  final HttpService _httpService = HttpService();

  /// 分片上传文件，返回最终文件 ID。
  Future<String> uploadFileByChunks({
    required String filePath,
    String? originalFileName,
    String? tenantId,
    int? maxFileSizeBytes,
  }) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('文件未找到，路径: $filePath');
    }

    final fileSize = await file.length();
    if (maxFileSizeBytes != null &&
        maxFileSizeBytes > 0 &&
        fileSize > maxFileSizeBytes) {
      throw Exception(
        '文件过大，当前大小 ${_formatBytes(fileSize)}，限制 ${_formatBytes(maxFileSizeBytes)}',
      );
    }

    final effectiveOriginalFileName = _resolveOriginalFileName(
      originalFileName,
      file.path,
    );
    final chunkCount = fileSize == 0 ? 1 : (fileSize / _chunkSize).ceil();

    final startResponse = await _startUpload(
      originalFileName: effectiveOriginalFileName,
      chunkCount: chunkCount,
      fileSize: fileSize,
    );

    await _uploadChunks(
      file: file,
      fileSize: fileSize,
      chunkCount: chunkCount,
      taskId: startResponse.id,
      serverFileName: startResponse.fileName,
    );

    return _completeUpload(taskId: startResponse.id, tenantId: tenantId);
  }

  Future<_StartUploadResponseData> _startUpload({
    required String originalFileName,
    required int chunkCount,
    required int fileSize,
  }) async {
    AppLog.verbose(
      '[分片上传] 开始: $originalFileName, 大小: $fileSize, 分片数: $chunkCount',
    );
    final startResult = await _httpService.post<Map<String, dynamic>>(
      _startUploadPath,
      data: {
        'originalFileName': originalFileName,
        'chunks': chunkCount,
        'appCode': Environment.currentEnv.appCode,
      },
      parser: (json) => Map<String, dynamic>.from(json as Map),
    );

    return startResult.when(
      success: (data) {
        final responseData = _StartUploadResponseData.fromJson(data);
        if (responseData.id.isEmpty || responseData.fileName.isEmpty) {
          throw Exception('[分片上传] 开始上传响应缺少 id 或 fileName');
        }
        AppLog.verbose(
          '[分片上传] 已开始。任务 ID: ${responseData.id}, 服务端文件名: ${responseData.fileName}',
        );
        return responseData;
      },
      failure: (error) => throw Exception('[分片上传] 开始上传失败: ${error.message}'),
    );
  }

  Future<void> _uploadChunks({
    required File file,
    required int fileSize,
    required int chunkCount,
    required String taskId,
    required String serverFileName,
  }) async {
    RandomAccessFile? raf;
    try {
      raf = await file.open(mode: FileMode.read);
      for (int i = 0; i < chunkCount; i++) {
        final start = i * _chunkSize;
        final end = min(start + _chunkSize, fileSize);
        final currentChunkSize = end - start;
        final chunkFileName = '$i-$serverFileName';
        final chunkIndex = i + 1;

        List<int> chunkData = [];
        if (currentChunkSize > 0) {
          await raf.setPosition(start);
          chunkData = await raf.read(currentChunkSize);
        } else if (chunkCount == 1 && fileSize == 0) {
          AppLog.verbose('[分片上传] 处理零字节文件上传');
        }

        final formData = FormData.fromMap({
          'file': MultipartFile.fromBytes(chunkData, filename: chunkFileName),
          'id': taskId,
          'chunkFileName': chunkFileName,
          'chunkIndex': chunkIndex,
          'chunkCount': chunkCount,
        });

        AppLog.verbose('[分片上传] 正在上传分片 $i ($currentChunkSize 字节)');
        final result = await _httpService.post<dynamic>(
          _uploadChunkPath,
          data: formData,
        );
        result.when(
          success: (_) {},
          failure: (error) => throw Exception('上传分片 $i 失败: ${error.message}'),
        );
      }
      AppLog.verbose('[分片上传] 所有分片已成功上传');
    } finally {
      await raf?.close();
      AppLog.verbose('[分片上传] 文件句柄已关闭');
    }
  }

  Future<String> _completeUpload({
    required String taskId,
    String? tenantId,
  }) async {
    AppLog.verbose('[分片上传] 正在完成上传，任务 ID: $taskId');
    final completeData = {'id': taskId};
    final queryParams = _buildCompleteQueryParams(tenantId);

    final completeResult = await _httpService.post<Map<String, dynamic>>(
      _completeUploadPath,
      data: completeData,
      queryParameters: queryParams.isEmpty ? null : queryParams,
      parser: (json) => Map<String, dynamic>.from(json as Map),
    );

    return completeResult.when(
      success: (data) {
        final responseData = _CompleteUploadResponseData.fromJson(data);
        if (responseData.fileId.isEmpty) {
          throw Exception('[分片上传] 完成上传响应缺少 fileId');
        }
        AppLog.verbose('[分片上传] 已成功完成。文件 ID: ${responseData.fileId}');
        return responseData.fileId;
      },
      failure: (error) => throw Exception('[分片上传] 完成上传失败: ${error.message}'),
    );
  }

  Map<String, dynamic> _buildCompleteQueryParams(String? tenantId) {
    final queryParams = <String, dynamic>{};
    if (tenantId != null && tenantId.isNotEmpty) {
      queryParams['tenantId'] = tenantId;
    }
    return queryParams;
  }

  String _resolveOriginalFileName(String? originalFileName, String filePath) {
    var resolvedName = originalFileName ?? p.basename(filePath);
    if (resolvedName.isNotEmpty && resolvedName.length > 69) {
      resolvedName = resolvedName.substring(resolvedName.length - 69);
    }
    return resolvedName;
  }

  String _formatBytes(int bytes) {
    const unit = 1024;
    if (bytes < unit) return '$bytes B';
    final exp = (log(bytes) / log(unit)).floor();
    final prefix = 'KMGTPE'[exp - 1];
    final size = bytes / pow(unit, exp);
    return '${size.toStringAsFixed(2)} ${prefix}B';
  }
}
