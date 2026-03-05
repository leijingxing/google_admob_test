# Repository Guidelines

## 目标与定位
- 本仓库是 Flutter 业务项目的基础模板仓库，目标是：`clone` 后可直接按规范开发。
- 注释、提示、文档默认使用中文，编码统一 UTF-8。
- 注释写作策略以 `COMMENT_STANDARD.md` 为唯一基准；本文件只定义工程结构、实现约束、协作流程。

## 适用范围
- 适用于 `lib/`、`assets/`、`android/`、`ios/`、`ci/` 以及根目录配置文件。
- 生成代码（`*.g.dart`、`*.freezed.dart`、`lib/generated/**`）不在人工编辑范围内。

## 技术基线
- 状态管理：GetX（`GetxController`、`GetView`、`Binding`）。
- 网络层：统一使用项目封装的 `HttpService`。
- 提示反馈：所有 Toast 统一使用 `AppToast`。
- 适配与资源：遵循项目既有约定（如 `flutter_screenutil`、`flutter_gen`）。
- 环境入口：`main_dev.dart`、`main_prod.dart`。

## 目录与分层约定
- `lib/core/`：基础能力（网络、环境、主题、工具），不放业务页面逻辑。
- `lib/data/`：数据层（models、repository、datasource），负责数据获取与转换。
- `lib/modules/`：业务模块（页面、控制器、模块内组件）。
- `lib/router/`：路由封装与页面跳转入口（非命名路由）。
- `lib/generated/`：代码生成产物，禁止手改。

## 路由跳转特例（嵌入场景）
- 本项目会被嵌入到另一个宿主项目中运行，属于特殊场景。
- 为避免与宿主项目的 GetX 命名路由表冲突，禁止使用命名路由。
- 全局仅允许使用页面实例跳转：
  - `Get.to(() => XxxView(), binding: XxxBinding())`
  - `Get.off(() => XxxView(), binding: XxxBinding())`
  - `Get.offAll(() => XxxView(), binding: XxxBinding())`
- 禁止使用以下能力：
  - `Get.toNamed / Get.offNamed / Get.offAllNamed`
  - `GetPage` 路由表注册与 `initialRoute/getPages`
  - 任意 `RouteNames` 字符串常量作为页面跳转入口
- 跨模块跳转统一通过 `lib/router/module_routes/*.dart` 提供的方法封装，禁止在业务层硬编码路由字符串。

## GetX 约束（核心）
- 控制器与对应 Binding 必须分文件维护：
  - `xxx_controller.dart` 仅放 Controller
  - `xxx_binding.dart` 仅放 Binding
- 命名规范：
  - Controller：`*Controller`
  - Binding：`*Binding`（建议 `{PageName}Binding`）
- 依赖注入必须通过 `Binding`，禁止在 View 中手动 `Get.put` 页面级 Controller。

## 状态管理策略（GetBuilder vs Obx）
- 默认优先 `GetBuilder`：用于页面级状态切换与低频刷新，降低响应式复杂度。
- 局部使用 `obs` + `Obx`：用于高频、细粒度、局部刷新场景（如表单联动、倒计时、局部列表项）。
- 禁止无边界全页 `Obx` 包裹；只包裹最小刷新区域。
- 复杂对象状态更新优先不可变方式（`copyWith` 或新对象替换），避免隐式原地突变。

## 网络与数据流约束
- 所有网络请求必须走 `HttpService`，禁止模块内直连第三方网络库。
- `modules/**` 不直接承担网络细节，业务页面通过 `data/repository` 获取数据。
- Repository 中声明接口路径时，统一使用 `'/api/...'` 前缀，禁止混用无前缀路径（如 `'/xxx'`）。
- 请求成功态、空态、失败态必须完整处理，失败态必须可观测（日志或 UI 反馈）。
- 所有模型解析必须在 `repository` 调用时显式传入 `parser`，禁止依赖全局隐式注册表。
- 新增或修改模型后，必须执行代码生成并在对应仓库请求中补齐 `parser`。
- 列表接口必须显式解析 `List<T>`，禁止 `dynamic` 透传到 UI 层。

## AI 生成约束（必须遵守）
- 生成模型时必须使用 `json_serializable`：
  - 文件结构：`xxx_model.dart` + `part 'xxx_model.g.dart';`
  - 必须实现：`factory XxxModel.fromJson(...)` 和 `toJson()`
- 字段容错统一使用 `lib/data/models/json_converters.dart`：
  - `int` 字段优先 `@IntSafeConverter()`
  - `String` 字段优先 `@StringSafeConverter()`
  - `String?` 字段优先 `@NullableStringSafeConverter()`
- Repository 请求必须显式传 `parser`：
  - 单对象：`parser: (json) => XxxModel.fromJson(Map<String, dynamic>.from(json as Map))`
  - 列表：`parser: (json) => (json as List).map(...).toList()`
- 禁止输出或依赖以下方案：
  - 禁止 Android Studio 插件 `FlutterJsonBeanFactory`
  - 禁止 `JsonConvert.fromJsonAsT` 全局注册表方案
  - 禁止在 UI 层直接解析 JSON
- 生成完成后必须执行：
  - `dart run build_runner build --delete-conflicting-outputs`
  - `flutter analyze`

## 代码生成与资源约束
- 严禁手动修改：`*.g.dart`、`*.freezed.dart`、`lib/generated/**`。
- 资源访问优先使用生成访问器，禁止硬编码资源路径字符串。
- 变更模型/资源/序列化后必须执行：
  - `dart run build_runner build --delete-conflicting-outputs`

## 开发与检查命令
- 安装依赖：`flutter pub get`
- 开发运行：`flutter run -t lib/main_dev.dart`
- 生产入口验证：`flutter run -t lib/main_prod.dart`
- 静态检查：`flutter analyze`
- 格式化：`dart format .`
- 持续生成：`dart run build_runner watch --delete-conflicting-outputs`
- 图标生成：`dart run icons_launcher:create`
- 打包（统一入口）：`dart run ci/build_ci.dart`

## 质量门禁（建议 CI 强制）
- `dart format --set-exit-if-changed .`
- `flutter analyze`
- `dart run build_runner build --delete-conflicting-outputs`
- 校验生成产物一致性：
  - `git diff --exit-code -- lib/generated ':(glob)**/*.g.dart' ':(glob)**/*.freezed.dart'`

## 测试策略（模板导向）
- 模板默认不预置业务测试用例。
- 关键路径（金额、鉴权、下单、配置解析等）允许并建议按需补充测试。
- 若当前迭代不写测试，PR 描述必须给出最小人工验证步骤与结果。

## 提交与 PR 规范
- 提交信息建议使用 Conventional Commits，例如：`feat(order): 新增订单详情状态流转`。
- PR 必填：改动动机、影响范围、回滚方案、验证结果（至少包含 `flutter analyze`）。
- 涉及 UI 改动时，附关键页面截图或录屏。

## 禁止事项（MUST NOT）
- 禁止手改任何生成文件。
- 禁止在 `modules/**` 直接编写网络实现细节。
- 禁止把业务逻辑堆在 Widget 层（应下沉至 Controller/Repository）。
- 禁止直接使用第三方或原生 Toast API（如 `BotToast.showText`、`Get.snackbar` 等）替代 `AppToast`。
- 禁止提交密钥、证书或任何敏感配置明文。

## 推荐事项（SHOULD）
- 小步提交，单一职责，避免“超大 PR”。
- 公共能力优先沉淀到 `core/` 或 `data/`，减少业务模块重复实现。
- 优先复用现有 Skill：
  - 版本号递增：`flutter-version`
  - Android 打包并上传蒲公英：`flutter-build-split-pgyer`
