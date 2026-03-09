import 'package:get/get.dart';

import 'exception_confirmation_controller.dart';

/// 异常确认依赖注入。
class ExceptionConfirmationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExceptionConfirmationController>(
      ExceptionConfirmationController.new,
    );
  }
}
