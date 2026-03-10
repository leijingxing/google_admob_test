import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/components/toast/toast_widget.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/dimens.dart';
import '../../../core/env/env.dart';

/// 蒲公英应用信息。
class PgyerAppInfo {
  PgyerAppInfo({
    required this.buildHaveNewVersion,
    required this.buildVersion,
    required this.downloadURL,
    required this.needForceUpdate,
    this.buildBuildVersion,
    this.buildVersionNo,
    this.appURL,
    this.buildShortcutUrl,
    this.forceUpdateVersion,
    this.forceUpdateVersionNo,
    this.buildUpdateDescription,
  });

  final bool buildHaveNewVersion;
  final String buildVersion;
  final int? buildBuildVersion;
  final String? buildVersionNo;
  final String downloadURL;
  final String? appURL;
  final String? buildShortcutUrl;
  final String? forceUpdateVersion;
  final String? forceUpdateVersionNo;
  final String? buildUpdateDescription;
  final bool needForceUpdate;

  factory PgyerAppInfo.fromJson(Map<String, dynamic> json) {
    return PgyerAppInfo(
      buildHaveNewVersion:
          json['buildHaveNewVersion'] == true ||
          json['buildHaveNewVersion'] == 1,
      buildVersion: (json['buildVersion'] ?? '').toString(),
      buildBuildVersion: json['buildBuildVersion'] is int
          ? json['buildBuildVersion'] as int
          : int.tryParse(json['buildBuildVersion']?.toString() ?? ''),
      buildVersionNo: json['buildVersionNo']?.toString(),
      downloadURL: (json['downloadURL'] ?? '').toString(),
      appURL: json['appURL']?.toString(),
      buildShortcutUrl: json['buildShortcutUrl']?.toString(),
      forceUpdateVersion: json['forceUpdateVersion']?.toString(),
      forceUpdateVersionNo: json['forceUpdateVersionNo']?.toString(),
      buildUpdateDescription: json['buildUpdateDescription']?.toString(),
      needForceUpdate:
          json['needForceUpdate'] == true || json['needForceUpdate'] == 1,
    );
  }

  String get versionLabel => buildVersion.isEmpty ? '未知版本' : buildVersion;

  String get description {
    final text = buildUpdateDescription?.trim() ?? '';
    return text.isEmpty ? '暂无更新说明' : text;
  }
}

/// 蒲公英更新服务。
class PgyerUpdateService {
  PgyerUpdateService({String? apiKey, String? appKey, Dio? dio})
    : apiKey = apiKey ?? _defaultApiKey,
      appKey = appKey ?? _resolveDefaultAppKey(),
      _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 30),
            ),
          );

  /// 与打包脚本保持一致的蒲公英 API Key。
  static const String _defaultApiKey = '51703a1d7b85abc64a6727ab4a9d7812';

  /// 开发服蒲公英 App Key。
  static const String _devAppKey = '8307b188ebaaa128dbf952ced73de6b8';

  /// 正式服蒲公英 App Key。
  static const String _prodAppKey = '99bd43076d61e4afbe8540f594e56d2e';

  final String apiKey;
  final String appKey;
  final Dio _dio;

  static bool _dialogShowing = false;

  PgyerAppInfo? lastInfo;
  PackageInfo? _packageInfo;

  Future<PackageInfo> _ensurePackageInfo() async {
    return _packageInfo ??= await PackageInfo.fromPlatform();
  }

  static String _resolveDefaultAppKey() {
    return Environment.currentEnv.debug ? _devAppKey : _prodAppKey;
  }

  Future<bool> checkAndUpdate({
    bool showToastWhenLatest = false,
    bool showDialogOnUpdate = true,
  }) async {
    if (apiKey.trim().isEmpty || appKey.trim().isEmpty) {
      AppToast.showWarning('请先在版本更新服务中配置蒲公英 appKey');
      return false;
    }

    final result = await _fetchLatest();
    if (result == null) return false;

    if (_isSameVersion(result)) {
      if (showToastWhenLatest) {
        AppToast.showSuccess('当前版本已是最新版本');
      }
      return false;
    }

    if (!result.buildHaveNewVersion) {
      if (showToastWhenLatest) {
        AppToast.showSuccess('当前版本已是最新版本');
      }
      return false;
    }

    if (showDialogOnUpdate) {
      _showUpdateDialog(result);
    }
    return true;
  }

  Future<PgyerAppInfo?> _fetchLatest() async {
    try {
      final packageInfo = await _ensurePackageInfo();
      final response = await _dio.post(
        'https://api.pgyer.com/apiv2/app/check',
        options: Options(contentType: Headers.formUrlEncodedContentType),
        data: {
          '_api_key': apiKey,
          'appKey': appKey,
          'buildVersion': packageInfo.version,
          'buildBuildVersion': int.tryParse(packageInfo.buildNumber),
        },
      );

      if (response.data is! Map) {
        AppToast.showError('检查更新失败，返回数据异常');
        return null;
      }

      final body = response.data as Map;
      if (body['code'] != 0) {
        AppToast.showError(body['message']?.toString() ?? '检查更新失败');
        return null;
      }

      final data = body['data'];
      if (data is! Map) {
        AppToast.showError('检查更新失败，缺少版本信息');
        return null;
      }

      final info = PgyerAppInfo.fromJson(Map<String, dynamic>.from(data));
      lastInfo = info;
      return info;
    } on DioException catch (e) {
      AppToast.showError('检查更新失败：${e.message}');
      return null;
    } catch (e) {
      AppToast.showError('检查更新失败：$e');
      return null;
    }
  }

  Future<bool> _ensureInstallPermission() async {
    if (!GetPlatform.isAndroid) return true;

    final current = await Permission.requestInstallPackages.status;
    if (current.isGranted) return true;

    final requested = await Permission.requestInstallPackages.request();
    if (requested.isGranted) return true;

    AppToast.showWarning('缺少安装权限，请允许当前应用安装未知来源应用后重试');
    return false;
  }

  bool _isSameVersion(PgyerAppInfo info) {
    final local = _packageInfo;
    if (local == null) return false;

    final localVersion = local.version.split('-').first;
    final remoteVersion = info.buildVersion.split('-').first;
    return _compareVersionString(remoteVersion, localVersion) <= 0;
  }

  int _compareVersionString(String remote, String local) {
    final remoteParts = remote.split('.');
    final localParts = local.split('.');
    final maxLength = remoteParts.length > localParts.length
        ? remoteParts.length
        : localParts.length;

    for (var i = 0; i < maxLength; i++) {
      final remoteValue = i < remoteParts.length
          ? int.tryParse(remoteParts[i]) ?? 0
          : 0;
      final localValue = i < localParts.length
          ? int.tryParse(localParts[i]) ?? 0
          : 0;
      if (remoteValue > localValue) return 1;
      if (remoteValue < localValue) return -1;
    }
    return 0;
  }

  void _showUpdateDialog(PgyerAppInfo info) {
    if (_dialogShowing) return;
    _dialogShowing = true;
    double progress = 0;
    bool downloading = false;

    Get.dialog<void>(
      PopScope(
        canPop: !downloading && !info.needForceUpdate,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  width: AppDimens.dp300,
                  padding: EdgeInsets.all(AppDimens.dp18),
                  margin: EdgeInsets.symmetric(horizontal: AppDimens.dp20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppDimens.dp18),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14243447),
                        blurRadius: 18,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: AppDimens.dp48,
                            height: AppDimens.dp48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE9F2FF),
                              borderRadius: BorderRadius.circular(
                                AppDimens.dp14,
                              ),
                            ),
                            child: const Icon(
                              Icons.system_update_alt_rounded,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(width: AppDimens.dp12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '发现新版本',
                                  style: TextStyle(
                                    fontSize: AppDimens.sp18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: AppDimens.dp4),
                                Text(
                                  '版本号 ${info.versionLabel}',
                                  style: TextStyle(
                                    fontSize: AppDimens.sp13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!info.needForceUpdate)
                            InkWell(
                              onTap: downloading ? null : Get.back<void>,
                              borderRadius: BorderRadius.circular(
                                AppDimens.dp16,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(AppDimens.dp4),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: AppDimens.sp18,
                                  color: downloading
                                      ? AppColors.textHint
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: AppDimens.dp16),
                      Text(
                        '更新说明',
                        style: TextStyle(
                          fontSize: AppDimens.sp14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: AppDimens.dp8),
                      Container(
                        width: double.infinity,
                        constraints: BoxConstraints(maxHeight: AppDimens.dp196),
                        padding: EdgeInsets.all(AppDimens.dp12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F9FF),
                          borderRadius: BorderRadius.circular(AppDimens.dp12),
                          border: Border.all(color: const Color(0xFFE3EAF5)),
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            info.description,
                            style: TextStyle(
                              fontSize: AppDimens.sp13,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                      if (downloading) ...[
                        SizedBox(height: AppDimens.dp14),
                        Text(
                          '下载进度 ${(progress * 100).toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: AppDimens.sp13,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: AppDimens.dp8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppDimens.dp10),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: AppDimens.dp12,
                            backgroundColor: const Color(0xFFE7EDF6),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                      SizedBox(height: AppDimens.dp16),
                      Row(
                        children: [
                          if (!info.needForceUpdate)
                            Expanded(
                              child: OutlinedButton(
                                onPressed: downloading ? null : Get.back<void>,
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Color(0xFFD3DCE9),
                                  ),
                                  minimumSize: Size(
                                    double.infinity,
                                    AppDimens.dp44,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppDimens.dp12,
                                    ),
                                  ),
                                ),
                                child: const Text('稍后再说'),
                              ),
                            ),
                          if (!info.needForceUpdate)
                            SizedBox(width: AppDimens.dp10),
                          Expanded(
                            child: FilledButton(
                              onPressed: downloading
                                  ? null
                                  : () async {
                                      await _startDownload(
                                        info,
                                        setDownloading: (flag) {
                                          setState(() => downloading = flag);
                                        },
                                        setProgress: (value) {
                                          setState(() => progress = value);
                                        },
                                      );
                                    },
                              style: FilledButton.styleFrom(
                                minimumSize: Size(
                                  double.infinity,
                                  AppDimens.dp44,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppDimens.dp12,
                                  ),
                                ),
                              ),
                              child: Text(
                                downloading
                                    ? '下载中 ${(progress * 100).toStringAsFixed(0)}%'
                                    : '立即更新',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    ).whenComplete(() {
      _dialogShowing = false;
    });
  }

  Future<void> _startDownload(
    PgyerAppInfo info, {
    required void Function(bool) setDownloading,
    required void Function(double) setProgress,
  }) async {
    setDownloading(true);
    setProgress(0);
    await _downloadAndInstall(
      info,
      onProgress: (received, total) {
        final ratio = total <= 0 ? 0.0 : received / total;
        setProgress(ratio.clamp(0.0, 1.0));
      },
    );
    setDownloading(false);
  }

  Future<void> _downloadAndInstall(
    PgyerAppInfo info, {
    ProgressCallback? onProgress,
  }) async {
    if (!GetPlatform.isAndroid) {
      AppToast.showWarning('当前仅支持 Android 应用内更新');
      return;
    }

    if (info.downloadURL.trim().isEmpty) {
      AppToast.showError('未获取到下载地址');
      return;
    }

    final permissionOk = await _ensureInstallPermission();
    if (!permissionOk) return;

    final savePath = await _buildSavePath(info.downloadURL);
    try {
      await _dio.download(
        info.downloadURL,
        savePath,
        onReceiveProgress: onProgress,
      );
      await OpenFilex.open(
        savePath,
        type: 'application/vnd.android.package-archive',
      );
    } on DioException catch (e) {
      AppToast.showError('下载失败：${e.message}');
    } catch (e) {
      AppToast.showError('下载失败：$e');
    }
  }

  Future<String> _buildSavePath(String url) async {
    final directory = await getTemporaryDirectory();
    final uri = Uri.tryParse(url);
    final fileName = uri != null && uri.pathSegments.isNotEmpty
        ? uri.pathSegments.last
        : 'update.apk';
    return '${directory.path}/$fileName';
  }
}
