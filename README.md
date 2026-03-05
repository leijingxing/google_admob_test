# closed_off_app

Flutter 业务项目基础模板仓库。  
目标是：团队成员 `clone` 后即可按统一规范快速启动开发。

## 1. 项目定位

- 统一技术基线：GetX + Repository + HttpService。
- 统一目录结构、命名规范、构建与提交流程。
- 降低新项目初始化成本，减少“每个项目都重新搭架子”。

详细工程约束见：`AGENTS.md`、`COMMENT_STANDARD.md`。

## 2. 5 分钟上手（新项目）

1. 基于本仓库创建新项目仓库并克隆到本地。
2. 修改应用信息：
   - `pubspec.yaml` 中项目名与版本
   - Android 包名 / iOS Bundle ID
   - 应用展示名称、图标、启动图（按项目需求）
3. 安装依赖：
   - `flutter pub get`
4. 生成代码：
   - `dart run build_runner build --delete-conflicting-outputs`
5. 本地启动开发环境：
   - `flutter run -t lib/main_dev.dart`
6. 首次提交初始化基线，作为后续业务开发起点。

## 3. 目录结构

```text
lib/
  core/        # 基础能力：网络、环境、主题、工具
  data/        # 数据层：models、repository、datasource
  modules/     # 业务模块：page/controller/widget
  router/      # 路由定义与页面注册
  generated/   # 生成代码（禁止手改）
assets/        # 静态资源
ci/            # 构建与 CI 脚本
```

## 4. 开发规范（摘要）

- 状态管理：
  - 默认优先 `GetBuilder`
  - 局部高频刷新使用 `obs + Obx`
- 路由跳转（特殊约束）：
  - 本项目为“嵌入宿主项目”场景，禁止命名路由，避免 GetX 路由表冲突。
  - 仅使用 `Get.to/Get.off/Get.offAll` + `Binding` 的页面实例跳转。
  - 禁止 `Get.toNamed/Get.offNamed/Get.offAllNamed`、`GetPage` 路由表、`initialRoute/getPages`。
  - 跨模块跳转统一通过 `lib/router/module_routes/*.dart` 的封装方法调用。
- 依赖注入：通过 `Binding` 注入，禁止在 View 里直接创建页面级 Controller。
- 网络访问：必须通过 `HttpService`，并经 `data/repository` 对外提供。
- 模型解析：统一使用 `json_serializable`，并在 `repository` 请求时显式传 `parser`。
- 生成文件：`*.g.dart`、`*.freezed.dart`、`lib/generated/**` 严禁手改。
- 注释规范：遵循 `COMMENT_STANDARD.md`。

## 5. 常用命令

```bash
# 安装依赖
flutter pub get

# 开发环境运行
flutter run -t lib/main_dev.dart

# 生产入口运行（验证）
flutter run -t lib/main_prod.dart

# 静态检查
flutter analyze

# 代码格式化
dart format .

# 代码生成（一次性）
dart run build_runner build --delete-conflicting-outputs

# 代码生成（持续监听）
dart run build_runner watch --delete-conflicting-outputs

# 打包统一入口
dart run ci/build_ci.dart
```

## 6. 推荐开发流程

1. 新建模块目录：`lib/modules/<feature>/`
2. 新建页面、`*_controller.dart`、`*_binding.dart`（Binding 与 Controller 分文件）
3. 配置模块跳转封装：`lib/router/module_routes/*.dart`（仅页面实例跳转）
4. 新增模型与仓库逻辑：`lib/data/models`、`lib/data/repository`
5. 模型与接口解析按以下标准实现：
   - 模型使用 `json_serializable`（`@JsonSerializable + part '*.g.dart'`）
   - 每个接口在 `repository` 显式传 `parser`，禁止全局隐式解析
   - 列表接口同样显式解析 `List<T>`
6. 联调后执行：
   - `dart format .`
   - `flutter analyze`
   - `dart run build_runner build --delete-conflicting-outputs`（若涉及模型/序列化/资源）
7. 提交 PR（含验证结果与影响范围）

## 7. parser 示例

```dart
// 单对象
final userRes = await HttpService().get<UserModel>(
  '/user/info',
  parser: (json) => UserModel.fromJson(Map<String, dynamic>.from(json as Map)),
);

// 列表
final usersRes = await HttpService().get<List<UserModel>>(
  '/user/list',
  parser: (json) => (json as List)
      .map((e) => UserModel.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList(),
);
```

## 8. AI 开发固定模板

### 8.1 新增模型模板
```dart
import 'package:json_annotation/json_annotation.dart';
import 'json_converters.dart';

part 'xxx_model.g.dart';

@JsonSerializable()
class XxxModel {
  @IntSafeConverter()
  final int id;

  @StringSafeConverter()
  final String name;

  @NullableStringSafeConverter()
  final String? remark;

  const XxxModel({
    required this.id,
    required this.name,
    this.remark,
  });

  factory XxxModel.fromJson(Map<String, dynamic> json) =>
      _$XxxModelFromJson(json);

  Map<String, dynamic> toJson() => _$XxxModelToJson(this);
}
```

### 8.2 新增接口模板（Repository）
```dart
// 单对象接口
Future<Result<XxxModel>> fetchDetail() {
  return HttpService().get<XxxModel>(
    '/xxx/detail',
    parser: (json) => XxxModel.fromJson(Map<String, dynamic>.from(json as Map)),
  );
}

// 列表接口
Future<Result<List<XxxModel>>> fetchList() {
  return HttpService().get<List<XxxModel>>(
    '/xxx/list',
    parser: (json) => (json as List)
        .map((e) => XxxModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList(),
  );
}
```

### 8.3 AI 生成后检查清单
1. 是否使用了 `json_serializable`（而不是插件生成）
2. 是否使用了统一容错转换器（`IntSafeConverter` 等）
3. 是否在 Repository 显式传了 `parser`
4. 是否执行了 `dart run build_runner build --delete-conflicting-outputs`
5. 是否执行了 `flutter analyze`

## 9. 提交规范

- 建议使用 Conventional Commits，例如：
  - `feat(login): 新增短信验证码登录`
  - `fix(order): 修复订单详情空态闪烁`
  - `refactor(network): 收敛错误码映射逻辑`

## 10. 注意事项

- 不要提交密钥、证书、账号等敏感信息。
- 不要在 Widget 中堆积业务逻辑，应下沉到 Controller/Repository。
- 修改模型、资源或序列化后，务必重新生成代码并确认无脏产物。

