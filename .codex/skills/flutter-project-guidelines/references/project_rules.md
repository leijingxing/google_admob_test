# flutter_base 项目规则（给 AI 的执行摘要）

## 1. 基础定位

- 本仓库是 Flutter 业务模板，目标是 clone 后按统一规范直接开发。
- 注释、文档默认中文，编码 UTF-8。
- 注释规范以 `COMMENT_STANDARD.md` 为准。

## 2. 分层约束

- `lib/core/`：基础能力，不放业务页面逻辑。
- `lib/data/`：models、repository、datasource，负责数据获取与转换。
- `lib/modules/`：业务页面与控制器。
- `lib/router/`：路由常量与页面注册。
- `lib/generated/`：生成产物，禁止手改。

## 3. GetX 约束

- Controller 与 Binding 分文件：
  - `xxx_controller.dart` 仅放 Controller。
  - `xxx_binding.dart` 仅放 Binding。
- 命名：`*Controller`、`*Binding`。
- 依赖注入通过 Binding，禁止在 View 中 `Get.put` 页面级 Controller。

## 4. 状态管理策略

- 默认优先 `GetBuilder`（页面级、低频刷新）。
- 高频局部刷新使用 `obs + Obx`，仅包裹最小刷新区域。
- 禁止无边界全页 `Obx`。
- 复杂对象更新优先不可变替换（`copyWith` 或新对象）。

## 5. 网络与数据流

- 所有网络请求必须通过 `HttpService`。
- `modules/**` 不直接写网络细节，页面通过 `data/repository` 取数据。
- 成功、空态、失败态必须完整处理；失败态可观测（日志或 UI 反馈）。
- Repository 请求必须显式传 `parser`。
- 列表接口必须显式解析 `List<T>`，禁止 `dynamic` 透传 UI。

## 6. AI 生成模型/仓库约束

- 模型必须使用 `json_serializable`，并包含 `part '*.g.dart'`、`fromJson`、`toJson`。
- 字段容错优先：
  - `@IntSafeConverter()`
  - `@StringSafeConverter()`
  - `@NullableStringSafeConverter()`
- 禁止：
  - `FlutterJsonBeanFactory`
  - `JsonConvert.fromJsonAsT` 全局注册表
  - 在 UI 层直接解析 JSON

## 7. 代码生成约束

- 严禁手改：`*.g.dart`、`*.freezed.dart`、`lib/generated/**`。
- 模型/资源/序列化变更后执行：
  - `dart run build_runner build --delete-conflicting-outputs`

## 8. 质量门禁

- `dart format --set-exit-if-changed .`
- `flutter analyze`
- `dart run build_runner build --delete-conflicting-outputs`
- 生成产物一致性：
  - `git diff --exit-code -- lib/generated ':(glob)**/*.g.dart' ':(glob)**/*.freezed.dart'`

## 9. 禁止事项

- 禁止手改任何生成文件。
- 禁止在 `modules/**` 直接编写网络实现细节。
- 禁止把业务逻辑堆在 Widget 层。
- 禁止使用 `BotToast.showText`、`Get.snackbar` 等替代 `AppToast`。
- 禁止提交密钥、证书或敏感配置明文。
