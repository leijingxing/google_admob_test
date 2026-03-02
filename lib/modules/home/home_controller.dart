import 'package:get/get.dart';

import '../../core/components/toast/toast_widget.dart';
import '../../core/utils/user_manager.dart';
import '../../router/app_routes.dart';

/// 首页控制器，提供开发指引页所需展示数据。
class HomeController extends GetxController {
  /// 页面主标题。
  final String guideTitle = 'Flutter 基础模板开发指引';

  /// 页面副标题。
  final String guideSubtitle = '按步骤新增业务页面，遵循 GetX + Repository 规范。';

  /// 顶部标签。
  final List<String> guideTags = const [
    'GetX',
    'HttpService',
    'json_serializable',
    'Parser 显式传入',
  ];

  /// 新增页面分步指引。
  final List<GuideStep> guideSteps = const [
    GuideStep(
      index: 1,
      title: '创建模块三件套',
      desc: '在 lib/modules/xxx 新建 view、controller、binding 三个文件并保持命名一致。',
      warning: '禁止在 View 中手动 Get.put 页面级 Controller。',
    ),
    GuideStep(
      index: 2,
      title: '补充路由常量',
      desc: '在 app_routes.dart 增加新页面路由常量，避免硬编码字符串。',
      warning: '路由命名需统一前缀，避免与已有模块冲突。',
    ),
    GuideStep(
      index: 3,
      title: '注册 GetPage',
      desc: '在 app_pages.dart 注册 GetPage(name/page/binding) 并按需挂载中间件。',
      warning: '页面依赖注入必须通过 Binding 完成。',
    ),
    GuideStep(
      index: 4,
      title: '接入 Repository 与模型解析',
      desc: '在 data/repository 通过 HttpService 发请求，parser 显式转换单对象或 List<T>。',
      warning: '禁止在 UI 层直接解析 JSON，禁止 dynamic 透传到页面。',
    ),
    GuideStep(
      index: 5,
      title: '执行本地校验',
      desc: '完成后执行 flutter analyze；模型变更时执行 build_runner 生成代码。',
      warning: '禁止手改 *.g.dart / *.freezed.dart / lib/generated/**。',
    ),
  ];

  /// 开发规范清单。
  final List<GuideChecklistGroup> checklistGroups = const [
    GuideChecklistGroup(
      title: 'GetX 约束',
      items: [
        'Controller 与 Binding 分文件维护（xxx_controller / xxx_binding）',
        '页面级状态优先 GetBuilder，局部高频再使用 Obx',
        '复杂对象状态优先 copyWith 或新对象替换',
      ],
    ),
    GuideChecklistGroup(
      title: '网络与模型约束',
      items: [
        '所有网络请求统一走 HttpService',
        'Repository 请求必须显式传入 parser',
        '模型统一使用 json_serializable，并执行代码生成',
      ],
    ),
    GuideChecklistGroup(
      title: '提交前检查',
      items: [
        'dart format --set-exit-if-changed .',
        'flutter analyze',
        'dart run build_runner build --delete-conflicting-outputs（模型变更时）',
      ],
    ),
  ];

  /// 指引页演示入口。
  final List<GuideDemoEntry> demoEntries = const [
    GuideDemoEntry(
      title: '查看登录页示例',
      subtitle: '演示页面表单 + Binding 注入',
      route: Routes.authLogin,
      icon: 'lock',
    ),
    GuideDemoEntry(
      title: '返回首页（当前页）',
      subtitle: '演示首页路由常量与页面注册',
      route: Routes.home,
      icon: 'home',
    ),
    GuideDemoEntry(
      title: '查看启动页流转',
      subtitle: '演示启动页根据登录态重定向',
      route: Routes.splash,
      icon: 'rocket',
    ),
  ];

  /// 点击演示入口。
  void onTapDemoEntry(GuideDemoEntry entry) {
    if (Get.currentRoute == entry.route) {
      AppToast.showInfo('当前已在该页面：${entry.route}');
      return;
    }
    if (entry.route == Routes.home) {
      Get.offAllNamed(entry.route);
      return;
    }
    Get.toNamed(entry.route);
  }

  /// 退出登录并返回登录页。
  Future<void> logout() async {
    await UserManager.logout();
  }
}

/// 开发步骤模型。
class GuideStep {
  final int index;
  final String title;
  final String desc;
  final String warning;

  const GuideStep({
    required this.index,
    required this.title,
    required this.desc,
    required this.warning,
  });
}

/// 规范清单分组模型。
class GuideChecklistGroup {
  final String title;
  final List<String> items;

  const GuideChecklistGroup({required this.title, required this.items});
}

/// 演示入口模型。
class GuideDemoEntry {
  final String title;
  final String subtitle;
  final String route;
  final String icon;

  const GuideDemoEntry({
    required this.title,
    required this.subtitle,
    required this.route,
    required this.icon,
  });
}
