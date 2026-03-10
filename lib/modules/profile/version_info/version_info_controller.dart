import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'pgyer_update_service.dart';

class VersionInfoController extends GetxController {
  String version = '';
  String buildNumber = '';
  String appName = '';
  String updateStatus = '检查更新';
  bool hasNewVersion = false;
  bool checkingUpdate = false;

  late final PgyerUpdateService _updateService;

  PgyerAppInfo? get latestInfo => _updateService.lastInfo;

  @override
  void onInit() {
    super.onInit();
    _updateService = PgyerUpdateService();
    _initPackageInfo();
  }

  @override
  void onReady() {
    super.onReady();
    checkUpdate(showToastWhenLatest: false);
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    version = info.version;
    buildNumber = info.buildNumber;
    appName = info.appName;
    update();
  }

  Future<void> checkUpdate({bool showToastWhenLatest = true}) async {
    if (checkingUpdate) return;

    checkingUpdate = true;
    updateStatus = '正在检查更新...';
    update();

    final hasUpdate = await _updateService.checkAndUpdate(
      showToastWhenLatest: showToastWhenLatest,
    );

    hasNewVersion = hasUpdate;
    final remoteVersion = latestInfo?.versionLabel ?? '';
    updateStatus = hasUpdate
        ? (remoteVersion.isEmpty ? '发现新版本' : '发现新版本 $remoteVersion')
        : '当前版本已是最新';
    checkingUpdate = false;
    update();
  }
}
