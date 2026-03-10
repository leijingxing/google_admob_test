import 'package:get/get.dart';

import 'task_progress_detail_controller.dart';

/// 工作台任务详情页依赖注入。
class TaskProgressDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskProgressDetailController>(TaskProgressDetailController.new);
  }
}
