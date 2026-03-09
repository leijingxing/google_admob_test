# Gemini Project Rules - Flutter Base

## 核心开发准则
- **语言与编码**: 注释、提示、文档默认使用 **中文**，编码统一 **UTF-8**。
- **技术栈**: 
  - 状态管理：GetX (`GetxController`, `GetView`, `Binding`)。
  - 网络请求：统一使用 `HttpService`。
  - UI 反馈：统一使用 `AppToast`。
  - 响应式策略：优先使用 `GetBuilder`；高频局部刷新使用 `Obx`（仅包裹最小刷新区域）。
- **注释标准**: 遵循 `COMMENT_STANDARD.md`。

## 路由跳转约束 (嵌入式场景)
- **禁止命名路由**: 严禁使用 `Get.toNamed`, `GetPage` 注册表或 `RouteNames` 字符串。
- **实例跳转**: 必须使用页面实例跳转，例如：`Get.to(() => XxxView(), binding: XxxBinding())`。
- **跨模块跳转**: 统一通过 `lib/router/module_routes/*.dart` 封装的方法，禁止硬编码路由字符串。

## GetX 架构规范
- **文件分离**: Controller (`*_controller.dart`) 与 Binding (`*_binding.dart`) 必须分文件。
- **依赖注入**: 必须通过 `Binding` 注入，禁止在 View 中手动 `Get.put` 页面级 Controller。
- **命名规范**: Controller 以 `Controller` 结尾，Binding 以 `Binding` 结尾。

## 数据流与 AI 代码生成 (强制性)
- **模型序列化**: 必须使用 `json_serializable`。
  - 文件结构：`xxx_model.dart` + `part 'xxx_model.g.dart';`。
  - 必须实现 `fromJson` 和 `toJson`。
- **字段容错**: 必须使用 `lib/data/models/json_converters.dart` 中的转换器：
  - `int` 类型：`@IntSafeConverter()`
  - `String` 类型：`@StringSafeConverter()`
  - `String?` 类型：`@NullableStringSafeConverter()`
- **Repository 约束**:
  - 业务页面禁止直接处理网络细节，必须通过 `data/repository` 获取数据。
  - 请求必须显式传入 `parser`（禁止依赖全局隐式注册表）。
  - 列表接口必须显式解析为 `List<T>`，禁止 `dynamic` 透传。
- **后处理**: 变更模型后必须运行 `dart run build_runner build --delete-conflicting-outputs` 并执行 `flutter analyze`。

## 目录分层约定
- `lib/core/`: 基础能力（网络、环境、主题、工具），不含业务逻辑。
- `lib/data/`: 数据层（models, repository, datasource）。
- `lib/modules/`: 业务模块（View, Controller, Binding）。
- `lib/router/`: 路由跳转入口与跨模块封装。
- `lib/generated/`: 代码生成产物，**严禁手动修改**。

## 禁止事项
- **严禁修改**：`*.g.dart`、`*.freezed.dart`、`lib/generated/**`。
- **禁止逻辑下沉**：禁止在 Widget 层编写业务逻辑，应下沉至 Controller/Repository。
- **禁止直连**：禁止在模块内直接使用第三方网络库或原生 Toast API。
- **安全**：禁止提交密钥、证书或敏感配置明文。

## 常用命令
- 依赖安装：`flutter pub get`
- 代码生成：`dart run build_runner build --delete-conflicting-outputs`
- 静态检查：`flutter analyze`
- 格式化：`dart format .`
- 开发运行：`flutter run -t lib/main_dev.dart`
