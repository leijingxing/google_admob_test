# flutter_base

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
- 依赖注入：通过 `Binding` 注入，禁止在 View 里直接创建页面级 Controller。
- 网络访问：必须通过 `HttpService`，并经 `data/repository` 对外提供。
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
3. 配置路由：`lib/router/app_routes.dart`、`lib/router/app_pages.dart`
4. 新增模型与仓库逻辑：`lib/data/models`、`lib/data/repository`
5. 联调后执行：
   - `dart format .`
   - `flutter analyze`
   - `dart run build_runner build --delete-conflicting-outputs`（若涉及模型/序列化/资源）
6. 提交 PR（含验证结果与影响范围）

## 7. 提交规范

- 建议使用 Conventional Commits，例如：
  - `feat(login): 新增短信验证码登录`
  - `fix(order): 修复订单详情空态闪烁`
  - `refactor(network): 收敛错误码映射逻辑`

## 8. 注意事项

- 不要提交密钥、证书、账号等敏感信息。
- 不要在 Widget 中堆积业务逻辑，应下沉到 Controller/Repository。
- 修改模型、资源或序列化后，务必重新生成代码并确认无脏产物。
