import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionInfoController extends GetxController {
  String version = '';
  String appName = '';
  String updateStatus = '检查更新';
  bool hasNewVersion = false;

  @override
  void onInit() {
    super.onInit();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    version = info.version;
    appName = info.appName;
    update();
  }

  Future<void> checkUpdate() async {
    if (updateStatus == '正在检查...') return;
    
    updateStatus = '正在检查...';
    update();
    
    // 模拟检查更新延迟
    await Future.delayed(const Duration(seconds: 1));
    
    updateStatus = '已是最新版本';
    hasNewVersion = false;
    update();
  }
}
