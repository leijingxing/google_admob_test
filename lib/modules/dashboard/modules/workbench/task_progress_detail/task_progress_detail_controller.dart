import 'package:get/get.dart';

/// 工作台任务详情页控制器。
class TaskProgressDetailController extends GetxController {
  /// 顶部任务分类标签。
  final List<String> tabs = const [
    '预约审批',
    '白名单审批',
    '黑名单审批',
    '申诉回复',
    '异常确认',
    '报警处置',
    '预警处置',
    '车辆抽检',
    '园区巡检',
    '隐患治理',
  ];

  int currentIndex = 0;

  /// 切换标签。
  void switchTab(int index) {
    if (index == currentIndex) return;
    currentIndex = index;
    update();
  }

  /// 当前标签标题。
  String get currentTitle => tabs[currentIndex];
}
