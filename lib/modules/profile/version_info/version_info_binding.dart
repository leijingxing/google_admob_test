import 'package:get/get.dart';
import 'version_info_controller.dart';

class VersionInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VersionInfoController());
  }
}
