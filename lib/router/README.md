# Router 维护约定

## 目标
- 路由定义集中在 `lib/router/` 目录，避免散落到 `modules/**`。
- 路由按模块拆分为“一个模块一个文件”，降低 `app_pages.dart` 体积。

## 目录约定
- `app_pages.dart`：只做聚合与初始路由配置。
- `module_routes/*.dart`：按模块拆分路由文件，一个模块一个文件，文件内同时维护：
  - 路由名常量（如 `AuthRouteNames`）
  - `GetPage` 列表（如 `AuthRoutes.routes`）
  - 示例：`module_routes/splash_routes.dart`

## 新增模块路由步骤
1. 在 `module_routes/` 下新增对应文件（如 `order_routes.dart`）。
2. 在该文件中声明本模块路由名常量与 `GetPage` 列表。
3. 在 `app_pages.dart` 中 `import` 并使用 `...XxxRoutes.routes` 聚合。
4. 跨模块跳转时，直接引用目标模块的 `XxxRouteNames` 常量，避免硬编码字符串。
